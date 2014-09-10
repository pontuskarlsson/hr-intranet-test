class XeroActionsController < ApplicationController



private
  def client
    ::XeroClient.client
  end

end
