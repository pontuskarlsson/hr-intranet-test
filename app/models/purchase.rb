class Purchase < ApplicationRecord

  store :meta, accessors: [:article_code, :qty]

  delegate :name, :description, :sales_unit_price, to: :article, prefix: true, allow_nil: true

  belongs_to :user,     class_name: 'Refinery::Authentication::Devise::User'
  belongs_to :company,  class_name: 'Refinery::Business::Company'

  validates :user_id, presence: true
  validates :company_id, presence: true
  validates :status,  inclusion: %w(created paid failed)
  validates :stripe_checkout_session_id, uniqueness: true, allow_blank: true
  validates :stripe_payment_intent_id, uniqueness: true, allow_blank: true
  validates :stripe_event_id, uniqueness: true, allow_blank: true
  validates :sub_total_cost, numericality: { greater_than: 0 }
  validates :total_discount, numericality: { less_than_or_equal_to: 0 }
  validates :total_cost, numericality: { greater_than_or_equal_to: 0 }
  validates :qty, numericality: { greater_than: 0, only_integer: true }

  before_validation do
    self.status ||= 'created'
    calculate_cost

    if user.present?
      self.company_id = user.companies.first.id if user.companies.count == 1
    end
  end

  validate do
    errors.add(:discount_code, :invalid) if discount_code.present? && discount_code.downcase != 'ss20promo'
    errors.add(:article_code, :invalid) unless article&.is_voucher
  end

  after_create do
    session = Stripe::Checkout::Session.create({
        success_url: "#{PortalSubdomain.protocol_domain}/purchases/success",
        cancel_url: "#{PortalSubdomain.protocol_domain}/purchases/cancel",
        payment_method_types: ['card'],
        mode: 'payment',
        customer_email: user.email,
        client_reference_id: happy_rabbit_reference_id,
        line_items: [
            {
                name: article_name,
                description: article_description,
                amount: (total_cost / qty.to_i * 100).to_i,
                currency: 'usd',
                quantity: qty.to_i,
            },
        ],
    })

    self.stripe_checkout_session_id = session.id
    throw :abort unless save
  end

  def article
    @article ||= Refinery::Business::Article.find_by code: article_code
  end

  def calculate_cost
    quantity = (self.qty.presence.to_i || 0)

    self.sub_total_cost = article.present? ? quantity * article_sales_unit_price : 0.0

    if quantity >= 10
      self.total_discount = sub_total_cost * -0.04
    elsif quantity >= 5
      self.total_discount = sub_total_cost * -0.02
    else
      0.0
    end

    self.total_cost = sub_total_cost + total_discount
  end

  def happy_rabbit_reference_id
    "hr_stripe_#{id}" if persisted?
  end

  def self.find_by_happy_rabbit_reference_id!(ref_id)
    find ref_id.gsub('hr_stripe_', '')
  end

  def discount_double?
    discount_code&.downcase == 'ss20promo'
  end

  def no_of_credits
    if discount_double?
      qty.to_i + [qty.to_i, 10].min
    else
      qty.to_i
    end
  end

end
