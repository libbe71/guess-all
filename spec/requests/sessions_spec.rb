require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "POST /sessions" do
    it "authenticates a user and returns a token if the request is JSON" do
      # Add your setup here, such as creating a user to authenticate with

      post '/sessions', params: { email: 'user@example.com', password: 'password' }, as: :json

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to have_key('token')
    end

    it "sets a session for the user if the request is HTML" do
      # Add your setup here, such as creating a user to authenticate with

      post '/sessions', params: { email: 'user@example.com', password: 'password' }

      expect(response).to redirect_to(user_path(User.last))
      expect(session[:user_id]).to eq(User.last.id)
    end

    it "returns an error message if credentials are invalid for JSON requests" do
      post '/sessions', params: { email: 'invalid@example.com', password: 'invalid' }, as: :json

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to have_key('error')
    end

    it "redirects to login page with an error message if credentials are invalid for HTML requests" do
      post '/sessions', params: { email: 'invalid@example.com', password: 'invalid' }

      expect(response).to redirect_to(login_path)
      expect(flash[:error]).to be_present
    end
  end
end
