require 'active_record'

module Refinery
  module Marketing

    class Message < ActiveRecord::Base
      self.table_name = 'refinery_amqp_messages'

      belongs_to :sender, polymorphic: true

      attr_accessible :queue, :message

      validates :queue, :message,     presence: true

    end
  end
end
