module Refinery
  module Addons
    class CommentCreator < ApplicationTransForm

      COMMENTABLE_TYPES = %w(Refinery::Business::Request Refinery::QualityAssurance::Job)

      ATTR = %w(commentable_id commentable_type body)

      set_main_model :comment, class_name: '::Refinery::Addons::Comment', proxy: { attributes: ATTR }

      attribute :new_ticket,  Boolean, default: false
      attribute :subject,     String

      validates :subject,           presence: true, if: :new_ticket
      validates :body,              presence: true
      validates :commentable_type,  inclusion: COMMENTABLE_TYPES

      def model=(model)
        if model.is_a? Comment
          self.commentable_id = model.commentable_id
          self.commentable_type = model.commentable_type
          self.comment = model
        else
          self.commentable_id = model.id
          self.commentable_type = model.class.name
          self.comment = Comment.new(commentable: model)
          model
        end
      end

      transaction do
        if new_ticket
          commentable.meta_zendesk = { 'subject' => subject, 'description' => body }
          commentable.save!
        end

        comment.commentable = commentable
        comment.body = body

        comment.save!

        push_to_zendesk unless Rails.env.test?
      end

      private

      def commentable
        @commentable ||= commentable_type.constantize.for_user_roles(current_user).find commentable_id
      end

      def push_to_zendesk
        if new_ticket
          Delayed::Job.enqueue(::Refinery::Addons::Zendesk::CreateTicketJob.new(
              commentable_id,
              commentable_type,
              comment.id
          ))
        else
          Delayed::Job.enqueue(::Refinery::Addons::Zendesk::CreateCommentJob.new(comment.id))
        end
      end

    end
  end
end
