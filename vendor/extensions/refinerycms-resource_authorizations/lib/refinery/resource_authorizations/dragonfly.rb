module Refinery
  module ResourceAuthorizations
    module Dragonfly

      class << self
        def model_from_job(job)
          case job.app.name
          when :refinery_images then Refinery::Image.find_by!(image_uid: job.fetch_step.uid)
          when :refinery_resources then Refinery::Resource.find_by!(file_uid: job.fetch_step.uid)
          else throw :halt, [400, {'Content-Type' => 'text/plain' }, ['Bad Request']]
          end

        rescue ::ActiveRecord::RecordNotFound => e
          throw :halt, [404, { 'Content-Type' => 'text/plain' }, ['Not Found']]
        end

        def configure!
          [:refinery_resources, :refinery_images].each do |app_name|
            app = ::Dragonfly.app(app_name)

            app.configure do
              before_serve do |job, env|
                user = env['warden'].user

                if job.fetch_step
                  model = ::Refinery::ResourceAuthorizations::Dragonfly.model_from_job job

                  if ::Refinery::ResourceAuthorizations::AccessControl.allowed? model.authorizations_access, user
                    # Allowed
                  else
                    throw :halt, [403, {"Content-Type" => "text/plain"}, ["Forbidden"]]
                  end
                else
                  # allow fetch_file, fetch_url and generate
                end
              end

              response_header "Cache-Control" do |job, request, headers|
                if job.fetch_step
                  model = ::Refinery::ResourceAuthorizations::Dragonfly.model_from_job job

                  if model.authorizations_access.present?
                    'private, max-age=0'
                  else
                    "public, max-age=#{Rails.env.production? ? '86400' : '3600'}"
                  end
                end
              end
            end
          end
        end
      end

    end
  end
end
