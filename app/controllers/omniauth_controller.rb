class OmniauthController < ApplicationController
  def new
    render :new
  end

  def create
    user_info = request&.env['omniauth.auth']
    birthDate = ""
    if user_info&.extra&.raw_info&.birthday
      birthDate = Date.strptime(user_info&.extra&.raw_info&.birthday, "%m/%d/%Y")
    elsif user_info&.info&.birthday
      birthDate = Date.strptime(user_info&.extra&.raw_info&.birthday, "%m/%d/%Y")
    end 

    if user_info && user_info&.info&.email
      user = User.find_by(email_address: user_info&.info&.email)
      if user
        session[:user_id] = user.id
        redirect_to "/users/#{user.id}"
      else
        @username = user_info&.info&.nickname || user_info&.info&.name || ""
        @name = user_info&.info&.first_name || user_info&.info&.given_name || user_info&.info&.name || ""
        @surname = user_info&.info&.last_name || user_info&.info&.family_name || ""
        @gender = user_info&.info&.gender || user_info&.extra&.raw_info&.gender || "not specified"
        @birthdate =  birthDate
        @phone_number = "" # Facebook does not provide phone number directly
        @email_address = user_info&.info&.email || ""
      end
    elsif user_info
      redirect_to '/auth'
    else
      redirect_to '/auth'
    end
  end
end


=begin
  <div class="field">
    <%= form&.label :username %>
    <%= form&.text_field :username, name: 'user[username]' %>
  </div>

  <div class="field">
    <%= form&.label :name %>
    <%= form&.text_field :name, name: 'user[name]' %>
  </div>

  <div class="field">
    <%= form&.label :surname %>
    <%= form&.text_field :surname, name: 'user[surname]' %>
  </div>

  <div class="field">
    <%= form&.label :birthdate %>
    <%= form&.date_field :birthdate, name: 'user[birthdate]' %>
  </div>

  <div class="field">
    <%= form&.label :phone_number %>
    <%= form&.text_field :phone_number, name: 'user[phone_number]' %>
  </div>

  <div class="field">
    <%= form&.label :email_address %>
    <%= form&.text_field :email_address, name: 'user[email_address]' %>
  </div>

  <div class="field">
    <%= form&.label :password %>
    <%= form&.password_field :password, name: 'user[password]' %>
  </div>

  <div class="field">
    <%= form&.label :state %>
    <%= form&.text_field :state, name: 'user[state]' %>
  </div>

  <div class="field">
    <%= form&.label :city %>
    <%= form&.text_field :city, name: 'user[city]' %>
  </div>

  <div class="field">
    <%= form&.label :address %>
    <%= form&.text_field :address, name: 'user[address]' %>
  </div>

  <div class="actions">
    <%= form&.submit "Register" %>
  </div>
=end