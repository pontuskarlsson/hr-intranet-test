# Migration responsible for creating a table with notifications
class CreateActivityNotificationTables < ActiveRecord::Migration
  # Create tables
  def change
    create_table :activity_notifications do |t|
      t.belongs_to :target,     polymorphic: true, null: false
      t.belongs_to :notifiable, polymorphic: true, null: false
      t.string     :key,                                        null: false
      t.belongs_to :group,      polymorphic: true
      t.integer    :group_owner_id,                index: true
      t.belongs_to :notifier,   polymorphic: true
      t.text       :parameters
      t.datetime   :opened_at

      t.timestamps null: false
    end
    add_index :activity_notifications, [:target_type, :target_id], name: 'index_notifications_on_target_id_and_type'
    add_index :activity_notifications, [:notifiable_type, :notifiable_id], name: 'index_notifications_on_notifiable_id_and_type'
    add_index :activity_notifications, [:group_type, :group_id], name: 'index_notifications_on_group_id_and_type'
    add_index :activity_notifications, [:notifier_type, :notifier_id], name: 'index_notifications_on_notifier_id_and_type'

    create_table :notifications_subscriptions do |t|
      t.belongs_to :target,     polymorphic: true, null: false
      t.string     :key,                           index: true, null: false
      t.boolean    :subscribing,                                null: false, default: true
      t.boolean    :subscribing_to_email,                       null: false, default: true
      t.datetime   :subscribed_at
      t.datetime   :unsubscribed_at
      t.datetime   :subscribed_to_email_at
      t.datetime   :unsubscribed_to_email_at
      t.text       :optional_targets

      t.timestamps null: false
    end
    add_index :notifications_subscriptions, [:target_type, :target_id], name: 'index_subscriptions_on_target_id_and_type'
    add_index :notifications_subscriptions, [:target_type, :target_id, :key], unique: true, name: 'index_subscriptions_on_target_id_type_and_key'
  end
end
