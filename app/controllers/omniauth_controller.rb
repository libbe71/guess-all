class OmniauthController < ApplicationController
  def new
    render :new
  end

  def create
    user_info = request.env['omniauth.auth']
  end
end
