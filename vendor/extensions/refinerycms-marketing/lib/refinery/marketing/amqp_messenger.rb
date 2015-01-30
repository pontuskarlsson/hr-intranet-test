require 'benchmark'
require 'logger'
require 'eventmachine'
require 'amqp'
require 'json'

module Refinery
  module Marketing
    class AmqpMessenger
      AMQP_HOST = ENV['AMQP_HOST']
      AMQP_USER = ENV['AMQP_USER']
      AMQP_PASS = ENV['AMQP_PASS']

      DEFAULT_SLEEP_DELAY = 5

      cattr_accessor :logger, :sleep_delay

      def self.reset
        self.sleep_delay      = DEFAULT_SLEEP_DELAY
        self.logger =
            if defined?(Rails)
              Rails.logger
            elsif defined?(RAILS_DEFAULT_LOGGER)
              RAILS_DEFAULT_LOGGER
            end
      end

      reset

      def initialize(options = {})
        @options = options
      end

      def start
        trap('TERM') do
          say 'Exiting...'
          stop
        end

        trap('INT') do
          say 'Exiting...'
          stop
        end

        say 'Starting AMQP Messenger'

        EventMachine.run do
          @connection = AMQP.connect(host: AMQP_HOST, username: AMQP_USER, password: AMQP_PASS)
          @amq = AMQP::Channel.new(@connection)
          @amq.queue('connection.test').publish('Foo')

          main_proc = Proc.new do
            @realtime = Benchmark.realtime do
              @found_message = find_and_process_one_message
            end

            if stop?
              say 'Closing connection'
              @connection.close { EventMachine.stop }
            end

            # If we found a message, we don't sleep in case there
            # is another message waiting to be processed.
            if @found_message
              main_proc.call
            else
              EventMachine.add_timer(self.class.sleep_delay, &main_proc)
            end
          end

          EventMachine.add_timer(1, &main_proc)
        end

      end

      def stop
        @exit = true
      end

      def stop?
        !!@exit
      end

      def say(text, level = 'info')
        @pid ||= Process.pid
        text = "[AMQP(#{@pid})] #{text}"
        puts text unless @quiet
        return unless logger

        logger.send(level, "#{Time.now.strftime('%FT%T%z')}: #{text}")
      end

      private
      def find_and_process_one_message
        message = Message.where(sent_at: nil).first
        if message
          say 'Found a message...'
          send_message message
          true
        else
          false
        end
      end

      def send_message(message)
        message.sent_at = DateTime.now
        message.save

        # Register for response first
        response_queue_name = "response.message.#{message.id}"
        @amq.queue(response_queue_name).subscribe do |msg|
          say "Response in queue: #{response_queue_name}"
          message.handle_response(msg) if message.respond_to?(:handle_response)
        end

        request_queue_name = "request.#{message.queue}"
        obj = JSON.parse(message.message)
        obj['respond_to_queue'] = response_queue_name
        say "Sending message to queue '#{ request_queue_name}'"
        @amq.queue(request_queue_name).publish(obj.to_json)
      end

    end
  end
end
