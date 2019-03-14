module Refinery
  module Calendar
    class Calendar < Refinery::Core::BaseModel
      belongs_to :user,           class_name: '::Refinery::Authentication::Devise::User'
      has_many :user_calendars,   dependent: :destroy
      has_many :users,            through: :user_calendars
      has_many :events,           dependent: :destroy

      attr_accessor :activate_on_create

      #attr_accessible :default_rgb_code, :private, :activate_on_create, :user_id, :function, :title, :position

      validates :title, presence: true, uniqueness: { scope: [:user_id] }
      validates :function,  uniqueness: true, allow_blank: true

      before_save do
        self.default_rgb_code = '%06x' % (rand * 0xffffff) if default_rgb_code.blank?
      end

      after_create do
        if activate_on_create
          unless private
            ::Refinery::Authentication::Devise::User.find_each do |user|
              self.users << user
            end
          end
        end
      end

      after_save do
        if changes[:id].nil? # Only perform on update, not create
          if changes[:default_rgb_code].present?
            # Update all user_calendars that still have the same rgb_code as
            # the previous default_rgb_code (meaning the user never manually updated).
            #
            #   changes[:default_rgb_code] index 0 => old value
            #   changes[:default_rgb_code] index 1 => new value
            user_calendars.update_all({ rgb_code: changes[:default_rgb_code][1] }, { rgb_code: changes[:default_rgb_code][0] })
          end
        end
      end

      def uniq_name
        if user.present?
          "#{title} (#{ user.username })"
        else
          title
        end

      end

      def text_color
        cr = default_rgb_code[0..1].to_i(16)
        cg = default_rgb_code[2..3].to_i(16)
        cb = default_rgb_code[4..5].to_i(16)
        (0.2126*cr + 0.7152*cg + 0.0722*cb) > 127 ? '000000' : 'ffffff'
      end

      def allows_event_update_by?(user)
        user.present? && function.blank? && user_id == user.id
      end


      class << self
        def active_for_user(user)
          joins(:user_calendars).where(refinery_calendar_user_calendars: { user_id: user.id, inactive: false })
        end

        def visible_for_user(user)
          where('refinery_calendar_calendars.private = ? OR refinery_calendar_calendars.user_id = ?', false, user.id)
        end
      end

    end
  end
end
