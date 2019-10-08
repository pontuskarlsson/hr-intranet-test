module Refinery
  module Business
    class Order < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_orders'

      PROC_LABEL = proc { |*attr| attr.reject(&:blank?).join ', ' }

      TYPES = %w(PURCHASEORDER)
      STATUSES = %w()
      CURRENCY_CODES = %w(EUR HKD SEK USD)

      belongs_to :buyer,        class_name: 'Company'
      belongs_to :seller,       class_name: 'Company'
      belongs_to :project
      has_many :order_items,    dependent: :destroy

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]
      acts_as_indexed :fields => [:order_number, :reference, :buyer_label, :seller_label, :order_date]

      validates :order_id,      uniqueness: true,           allow_blank: true
      validates :buyer_label,   presence: true
      validates :seller_label,  presence: true
      validates :order_type,    inclusion: TYPES,           allow_blank: true
      validates :status,        inclusion: STATUSES,        allow_blank: true
      validates :currency_code, inclusion: CURRENCY_CODES,  allow_blank: true
      validates :ordered_qty,   numericality: true
      validates :shipped_qty,   numericality: true,         allow_nil: true

      before_validation do
        if buyer.present?
          self.buyer_label = buyer.label
        end
        if seller.present?
          self.seller_label = seller.label
        end
      end

      def label
        PROC_LABEL.call(order_number, reference, order_date)
      end
      
      def buyer_label=(label)
        if buyer_label != label
          company = Company.find_by_label label
          self.buyer = company if company != buyer
        end
        super
      end

      def seller_label=(label)
        if seller_label != label
          company = Company.find_by_label label
          self.seller = company if company != seller
        end
        super
      end

      def project_label
        @project_label ||= project.try(:label)
      end

      def project_label=(label)
        self.project = ::Refinery::Business::Project.find_by_label label
        @project_label = label
      end

      def self.find_by_label(label)
        find_by order_number: label.split(', ').first
      end

      def self.to_source
        order(order_number: :desc).pluck(:order_number, :reference, :order_date).map(&PROC_LABEL).to_json.html_safe
      end

      def qty
        shipped_qty.nil? ? ordered_qty : shipped_qty
      end

      def sum_total_cost!
        update_attributes(total_cost: order_items.sum(:total_cost))
      end

    end
  end
end
