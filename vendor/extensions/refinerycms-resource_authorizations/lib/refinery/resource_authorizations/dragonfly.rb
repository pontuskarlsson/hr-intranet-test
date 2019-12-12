module Refinery
  module ResourceAuthorizations
    module Dragonfly

      class << self
        def configure!
          [:refinery_resources, :refinery_images].each do |app_name|
            app = ::Dragonfly.app(app_name)

            app.configure do
              before_serve do |job, env|
                user = env['warden'].user
                throw :halt, [401, {"Content-Type" => "text/plain"}, ["Unauthorized"]] unless user

                if job.fetch_step
                  klass, col = case job.app.name
                            when :refinery_images then [Refinery::Image, :image_uid]
                            when :refinery_resources then [Refinery::Resource, :file_uid]
                            else []
                          end

                  throw :halt, [400, {"Content-Type" => "text/plain"}, ["Bad Request"]] unless klass

                  if (file = klass.find_by(col => job.fetch_step.uid)).present?
                    if ::Refinery::ResourceAuthorizations::AccessControl.allowed? file.authorizations_access, user
                      # Allowed
                    else
                      throw :halt, [403, {"Content-Type" => "text/plain"}, ["Forbidden"]]
                    end
                  else
                    # explicitly 404 here to avoid sending files which are no longer in the database but still exist on disk
                    throw :halt, [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
                  end
                else
                  # allow fetch_file, fetch_url and generate
                end
              end
            end
          end
        end
      end

    end
  end
end
