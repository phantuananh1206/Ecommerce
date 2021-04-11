class Admin::ExportOrdersController < ApplicationController
  def index
    @orders = Order._created_at_desc
    respond_to do |format|
	    format.xls { send_data @orders.to_xls }
	  end
  end
end
