class UsersController < ApplicationController

    before_action :authenticate_user_from_token!, only: [:update, :destroy]
    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }


    def index
        render json: @users = User.all
    end

    def show
        @user = User.find(params[:id])
        if @user
            render json: @user, status: :ok
        else
            format.json { render json: { errors: @user.errors.full_messages }, status: :not_found }
        end

        rescue => e
        respond_to do |format|
            format.html { redirect_to login_or_register_path, alert: "An error occurred: #{e.message}" }
            format.json { render json: { error: "An error occurred: #{e.message}" }, status: :unprocessable_entity }
        end
    end

    def create
        @user = User.new(user_params)

    respond_to do |format|
        if @user.save
        format.json { render json: @user, status: :created }
        format.html { redirect_to login_or_register_path, notice: 'User was successfully created.' }

        else
        format.html { render :new }
        format.json { render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity }
        end
    end
    rescue => e
    respond_to do |format|
        format.html { redirect_to login_or_register_path, alert: "An error occurred: #{e.message}" }
        format.json { render json: { error: "An error occurred: #{e.message}" }, status: :unprocessable_entity }
    end
    end


    def update
        @user = User.find(params[:id])

        if @user.update(user_params)
        render json: @user, status: :ok
        else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @user = User.find(params[:id])

        if @user
            @user.destroy
            render json: @user, status: :ok
        else
            render json: { errors: ['User not found'] }, status: :unprocessable_entity
        end
    end
    private

    # Only allow a list of trusted parameters through.
    def user_params
        params.require(:user).permit(:username, :name, :surname, :birthdate, :phone_number, :email_address, :password, :state, :city, :address)
    end

    # Token-based authentication for API endpoints
    def authenticate_user_from_token!
       
        token = request.headers['Authorization'].to_s.split(' ').last
        user = User.find_by(authentication_token: token)

        if user
        sign_in user, store: false # Assuming you're using Devise for authentication
        else
        render json: { error: 'Invalid token' }, status: :unauthorized
        end
    end

end
