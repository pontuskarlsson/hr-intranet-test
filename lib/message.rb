require 'active_record'

class Message < ActiveRecord::Base
  self.table_name = 'amqp_messages'

  belongs_to :sender, polymorphic: true

  attr_accessible :queue, :message

  validates :queue, :message,     presence: true

end
