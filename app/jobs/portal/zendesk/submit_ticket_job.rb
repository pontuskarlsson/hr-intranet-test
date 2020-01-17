module Portal
  module Zendesk
    class SubmitTicketJob < Struct.new(:name, :email, :subject, :message)

      # def enqueue(job)
      #
      # end

      def perform
        user = find_or_create_user! email
        create_ticket! user, subject, message
      end

      # def before(job)
      #
      # end

      # def after(job)
      #
      # end

      def success(job)
        ErrorMailer.notification_email(["SubmitTicketJob #{job.id} has succeeded."]).deliver
      end

      def error(job, exception)
        ErrorMailer.error_email(exception).deliver
      end

      def failure(job)
        ErrorMailer.notification_email(["SubmitTicketJob #{job.id} has failed after trying too many times unsuccessfully.", job.inspect]).deliver
      end

      private

      def client
        @client ||= Portal::Zendesk::Client.client
      end

      def find_or_create_user!(email)
        client.users.search(query: email).first ||
            client.users.create!(email: email, name: name)
      end

      def create_ticket!(user, subject, description)
        client.tickets.create!(
            submitter_id: user.id,
            requester_id: user.id,
            subject: subject,
            description: description
        )
      end
    end
  end
end
