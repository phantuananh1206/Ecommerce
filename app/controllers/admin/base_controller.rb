class Admin::BaseController < ApplicationController
  layout 'layouts/admin'

  before_action :authenticate_user!

  def home; end
end
