module Refinery
  module Business
    class ConfirmPlanForm < ApplicationTransForm
      set_main_model :plan, class_name: '::Refinery::Business::Plan', proxy: { attributes: %w() }

      attribute :confirmed_by_id,   Integer
      attribute :remote_ip,         String

      validates :current_user,      presence: true
      validate do
        errors.add(:plan, :invalid) unless plan&.status == 'proposed'

        unless current_user&.id == confirmed_by_id
          errors.add(:confirmed_by_id, :mismatch)
        end
      end

      def model=(model)
        self.plan = model
      end

      transaction do
        plan.confirmed_by_id = confirmed_by_id
        plan.confirmed_at = DateTime.now
        plan.confirmed_from_ip = remote_ip
        plan.status = 'confirmed'
        plan.save!

        #Delayed::Job.enqueue(Refinery::Business::ConfirmContractJob.new(plan.id, current_user.id))
      end

      private

    end
  end
end
