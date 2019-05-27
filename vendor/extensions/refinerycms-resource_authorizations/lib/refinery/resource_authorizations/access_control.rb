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
              if @access.has_key? role_title
                if role_titles.include? role_title
                  @access[role_title].nil? || @access[role_title].call(user, conditions)
                end
              end
            }
          end
        end

        def allow!(role_title, &block)
          @access ||= {}
          @access[role_title] = block
        end
      end

    end
  end
end
