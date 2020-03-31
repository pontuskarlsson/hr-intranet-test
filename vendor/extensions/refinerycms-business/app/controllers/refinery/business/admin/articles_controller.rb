module Refinery
  module Business
    module Admin
      class ArticlesController < ::Refinery::AdminController

        crudify :'refinery/business/article',
                :title_attribute => 'code',
                order: 'code ASC'

        def article_params
          params.require(:article).permit(
              :account_id, :item_id, :code, :name, :description, :is_sold, :is_purchased, :is_public, :company_id,
              :company_label, :is_managed, :managed_status, :updated_date_utc, :archived_at, :is_voucher, :is_discount,
              :voucher_constraint_applicable_articles
          )
        end

      end
    end
  end
end
