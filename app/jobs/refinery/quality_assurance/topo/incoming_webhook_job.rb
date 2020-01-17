module Refinery
  module QualityAssurance
    module Topo
      class IncomingWebhookJob < Struct.new(:payload)

        attr_reader :syncer

        def enqueue(job)

        end

        def perform
          @syncer = Portal::Topo::Syncer.new

          ActiveRecord::Base.transaction do
            @syncer.run_webhook! payload
          end
        end

        # def before(job)
        #
        # end

        # def after(job)
        #
        # end

        def success(job)
          if job.syncer&.inspection&.status == 'Inspected'
            if job.syncer.inspection.to_be_verified.any?
              job.syncer.inspection.notify :'refinery/authentication/devise/users', key: 'inspection.verify'

            else
              job.syncer.inspection.notify :'refinery/authentication/devise/users'
              job.syncer.inspection.status = 'Notified'
              job.syncer.inspection.save!
            end
          end
        end

        def error(job, exception)
          ErrorMailer.error_email(exception).deliver
        end

        # def failure(job)
        #
        # end

        private


      end
    end
  end
end
