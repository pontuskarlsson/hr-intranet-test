module Refinery
  module ResourceAuthorizations
    module AccessControl

      # Regular expression to parse the authorization format of resources. It expects it
      # to be stored in none to multiple instances of the following pattern:
      #
      #   [ROLE_NAME{CONDITIONS}]
      #
      # where examples of ROLE_NAME can be "Superuser", "Business:Internal" and examples
      # of CONDITIONS can be "company_id:456".
      #
      CTRL_REG = /\[([A-Za-z:]+)\{([a-z_0-9:,]*)\}\]/


      class << self
        def allowed?(access, user)
          role_titles = user && user.roles.pluck(:title) || []

          # Always allow Superuser role
          if access.blank? || role_titles.include?('Superuser')
            true

          else
            access.scan(CTRL_REG).any? { |(role_title, conditions)|
              cond = parse_conditions(conditions)

              if role_title == 'User'
                user && cond[:user_id] && user.id == cond[:user_id].to_i

              elsif @access.has_key? role_title
                if role_titles.include? role_title
                  @access[role_title].nil? || @access[role_title].call(user, cond)
                end
              end
            }
          end

        rescue ActiveRecord::RecordNotFound => e
          false
        end

        def allow!(role_title, &block)
          @access ||= {}
          @access[role_title] = block
        end

        def parse_conditions(conditions)
          conditions.split(',').inject({}) { |acc, c|
            key, value = c.split(':')
            acc.merge(key.to_sym => value)
          }
        rescue StandardError => e
          {}
        end
      end

    end
  end
end
