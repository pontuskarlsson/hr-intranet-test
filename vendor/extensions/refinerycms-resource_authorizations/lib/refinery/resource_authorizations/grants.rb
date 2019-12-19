require 'active_support/concern'

module Refinery
  module ResourceAuthorizations
    module Grants
      extend ActiveSupport::Concern

      included do
        class_attribute :_grants, :_reverse_grants, :_grant_all
        self._grants = {}
        self._reverse_grants = {}
        self._grant_all = []
      end

      def granted_users
        klass = Refinery::Authentication::Devise::User

        _reverse_grants.each_pair.reduce(klass.none) do |base, (role, scope)|
          base.or(scope.call(klass.for_role(role), self))
        end
      end

      module ClassMethods

        def grant_all(*roles)
          self._grant_all |= roles
        end

        def grant_conditional(*roles)
          options = roles.extract_options!

          raise 'missing option :scope' unless options.has_key? :scope
          raise 'missing option :reverse_scope' unless options.has_key? :reverse_scope

          _grants[roles] = -> (base, user) {
            base.send(options[:scope], user)
          }
          _reverse_grants[roles] = -> (base, record) {
            base.send(options[:reverse_scope], record)
          }
        end

        def for_user_roles_test(user, role_titles = nil)
          titles = role_titles || user.roles.pluck(:title)

          if (titles & _grant_all).any?
            # Grant All role present, no need to go through the granted
            # scopes.
            #
            where(nil)

          else
            # Start off with the +none+ scope, then use +or+ to chain
            # the resulting scope from the proc granted for the roles.
            #
            _grants.each_pair.reduce(none) do |chain, (roles, proc)|
              if (titles & roles).any?
                chain.or(proc.call(self, user))
              else
                chain
              end
            end
          end
        end

      end
    end
  end
end
