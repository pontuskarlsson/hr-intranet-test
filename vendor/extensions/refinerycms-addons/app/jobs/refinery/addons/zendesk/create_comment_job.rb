module Refinery
  module Addons
    module Zendesk
      class CreateCommentJob < Struct.new(:comment_id)

        # def enqueue(job)
        #
        # end

        def perform
          comment = ::Refinery::Addons::Comment.find comment_id
          create_comment! comment
        end

        # def before(job)
        #
        # end

        # def after(job)
        #
        # end

        def success(job)
          ErrorMailer.notification_email(["CreateCommentJob #{job.id} has succeeded."]).deliver
        end

        def error(job, exception)
          ErrorMailer.error_email(exception).deliver
        end

        def failure(job)
          ErrorMailer.notification_email(["CreateCommentJob #{job.id} has failed after trying too many times unsuccessfully.", job.inspect]).deliver
        end

        private

        def client
          @client ||= Portal::Zendesk::Client.client
        end

        def find_or_create_user!(email)
          client.users.search(query: email).first ||
              client.users.create!(email: email, name: name)
        end

        def create_comment!(comment)
          user = find_or_create_user! comment.comment_by.email
          ticket = client.tickets.find id: comment.commentable.zendesk_id

          ticket.update(comment: { body: comment.body, author_id: user.id })

          if comment.comment_by_is_internal?
            ticket.update(followers: [{ user_id: user.id }])
          elsif user.id != ticket.requester_id
            ticket.update(email_ccs: [{ user_id: user.id }])
          end

          if ticket.save
            comment.zendesk_id = ticket.comments.last.id
            comment.save
          end
        end

      end
    end
  end
end
