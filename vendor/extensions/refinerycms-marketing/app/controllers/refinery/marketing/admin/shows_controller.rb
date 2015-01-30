require 'eventmachine'
require 'amqp'

module Refinery
  module Marketing
    module Admin
      class ShowsController < ::Refinery::AdminController
        skip_before_filter :verify_authenticity_token, only: [:sync]

        crudify :'refinery/marketing/show',
                :title_attribute => 'name',
                :xhr_paging => true,
                order: 'name ASC'

        prepend_before_filter :find_show, only: [:sync, :update, :destroy, :edit, :show]

        def sync
          @show.crawl_web_messages.create(message: @show.msg_json_struct, queue: 'crawl_web')

          redirect_to redirect_url
        end

      end
    end
  end
end
