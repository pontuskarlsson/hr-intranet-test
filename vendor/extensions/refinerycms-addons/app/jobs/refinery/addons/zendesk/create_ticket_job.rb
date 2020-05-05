module Refinery
  module Addons
    module Zendesk
      class CreateTicketJob < Struct.new(:commentable_id, :commentable_type, :comment_id)

        # def enqueue(job)
        #
        # end

        def perform
          if commentable.present?
            zendesk_meta = commentable.zendesk_meta || {}
            submitter = find_or_create_user! commentable.submitter_email, commentable.submitter_full_name
            requester = find_or_create_user! commentable.requester_email, commentable.requester_full_name
            ticket = create_ticket! submitter, requester, zendesk_meta['subject'], zendesk_meta['description']

            commentable.zendesk_id = ticket.id
            commentable.zendesk_meta = ticket.attributes.to_hash
            commentable.save

            if comment.present?
              comment.zendesk_id = ticket.comments[0].id
              comment.save
            end
          end
        end

        # def before(job)
        #
        # end

        # def after(job)
        #
        # end

        def success(job)
          ErrorMailer.notification_email(["CreateTicketJob #{job.id} has succeeded."]).deliver
        end

        def error(job, exception)
          ErrorMailer.error_email(exception).deliver
        end

        def failure(job)
          ErrorMailer.notification_email(["CreateTicketJob #{job.id} has failed after trying too many times unsuccessfully.", job.inspect]).deliver
        end

        private

        def client
          @client ||= Portal::Zendesk::Client.client
        end

        def find_or_create_user!(email, name)
          @zendesk_users ||= {}
          @zendesk_users[email] ||=
              client.users.search(query: email).first ||
              client.users.create!(email: email, name: name)
        end

        def create_ticket!(submitter, requester, subject, description)
          client.tickets.create!(
              submitter_id: submitter.id,
              requester_id: requester.id,
              followers: default_followers + company_followers,
              external_id: "#{commentable_type}/#{commentable_id}",
              subject: subject,
              description: description
          )
        end

        def commentable
          @commentable ||= commentable_type.constantize.find commentable_id
        end

        def comment
          @comment ||= commentable.comments.find comment_id
        end

        def default_followers
          if Rails.env.production?
            [
                { user_id: find_or_create_user!('pontus.karlsson@happyrabbit.com', 'Pontus Karlsson')&.id },
                { user_id: find_or_create_user!('leontina.heffernan@happyrabbit.com', 'Leontina Heffernan')&.id },
                { user_id: find_or_create_user!('ryan.lai@happyrabbit.com', 'Ryan Lai')&.id }
            ].reject { |u| u[:user_id].nil? }

          elsif Rails.env.development?
            [
                { user_id: find_or_create_user!('daniel.viklund@happyrabbit.com', 'Daniel Viklund')&.id },
                { user_id: find_or_create_user!('daniel@fabriqo.com', 'Daniel (Fabriqo)')&.id },
            ].reject { |u| u[:user_id].nil? }

          else
            []
          end
        end

        def company_followers
          if commentable.respond_to?(:company_followers)
            commentable.company_followers.map { |user|
              { user_id: find_or_create_user!(user.email, user.full_name)&.id }
            }.reject { |u| u[:user_id].nil? }
          else
            []
          end
        end
      end
    end
  end
end
