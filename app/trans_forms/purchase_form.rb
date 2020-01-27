class PurchaseForm < ApplicationTransForm
  include Portal::Wizard::ActiveRecord

  attribute :article_code,                String
  attribute :qty,                         Integer


  attribute :company_id,                  String
  attribute :country,                     String
  attribute :full_name,                   String

  attribute :stripe_session_id,           String

  delegate :name, :description, :sales_unit_price, to: :article, prefix: true, allow_nil: true

  def sub_total
    if article.present?
      qty * article_sales_unit_price
    else
      0.0
    end
  end

  def total_discount
    if qty >= 10
      - sub_total * 0.02
    elsif qty >= 5
      - sub_total * 0.02
    else
      0.0
    end
  end

  def total
    sub_total + total_discount
  end

  validate do
    errors.add(:article_code, :missing) unless article_code.present?
    errors.add(:qty, :invalid) unless qty.is_a?(Integer) && qty > 0
  end

  transaction do

  end

  private

  def article
    @article ||= Refinery::Business::Article.find_by code: article_code
  end

end
