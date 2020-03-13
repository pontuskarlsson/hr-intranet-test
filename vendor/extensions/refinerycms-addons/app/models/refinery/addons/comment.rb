module Refinery
  module Addons
    class Comment < Refinery::Core::BaseModel
      self.table_name = 'refinery_addons_comments'

      belongs_to :commentable,  polymorphic: true
      belongs_to :comment_by,   polymorphic: true, optional: true

      delegate :is_internal?, to: :comment_by, prefix: true, allow_nil: true

      validates :body,          presence: true

      before_save do
        self.commented_at ||= created_at || DateTime.now
        self.comment_by_email = comment_by.email if comment_by.present?
        self.comment_by_full_name = comment_by.full_name if comment_by.present?
      end

      def comment_date
        commented_at.to_date
      end

      def comment_by_initials
        if comment_by.present?
          comment_by.initials
        elsif comment_by_full_name.present?
          comment_by_full_name.split(' ').reject(&:blank?)[0..1].map(&:first).join ''
        else
          'N/A'
        end
      end

    end
  end
end
