module Refinery
  module Addons
    class CommentCreator < ApplicationTransForm

      ATTR = %w(commentable_id commentable_type body)

      set_main_model :comment, class_name: '::Refinery::Addons::Comment', proxy: { attributes: ATTR }

      def model=(model)
        self.comment = model
      end

      transaction do
        comment.commentable = commentable
        comment.body = body

        comment.save!

        push_to_zendesk
      end

      private

      def commentable
        case commentable_type
        when 'Refinery::Business::Request' then ::Refinery::Business::Request.for_user_roles(current_user).find commentable_id
        else raise ActiveRecord::RecordNotFound
        end
      end

      def push_to_zendesk
        Delayed::Job.enqueue(::Refinery::Addons::Zendesk::CreateCommentJob.new(comment.id))
      end

    end
  end
end
