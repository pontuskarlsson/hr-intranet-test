class CreateMarketingAmqpMessages < ActiveRecord::Migration
  def up
    create_table :refinery_amqp_messages, :force => true do |table|
      table.string    :queue,     null: false
      table.text      :message,   null: false
      table.text      :type,      null: false
      table.integer   :sender_id
      table.string    :sender_type
      table.datetime  :sent_at
      table.timestamps
    end

    add_index :refinery_amqp_messages, :sent_at
    add_index :refinery_amqp_messages, [:sender_id, :sender_type]
  end

  def down
    remove_index :refinery_amqp_messages, :sent_at
    remove_index :refinery_amqp_messages, [:sender_id, :sender_type]

    drop_table :refinery_amqp_messages
  end
end
