class Gateway::SalesController < ApplicationController
  def new
    #TODO: List payment ways
    render :new, layout: "application_without_sidebar.haml"
  end
end
