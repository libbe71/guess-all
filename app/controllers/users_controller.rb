class UsersController < ApplicationController

    before_action :authenticate_user_from_token!, only: [:update, :destroy, :self_update, :self_destroy]
    skip_before_action :verify_authenticity_token, if: -> { request.format.json?}


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
            format.json { render json: { error: "An error occurred: #{e.message}" }, status: :not_found }
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
        format.json { render json: { errors: @user.errors.full_messages }, status: :bad }
        end
    end
    rescue => e
    respond_to do |format|
        format.html { redirect_to login_or_register_path, alert: "An error occurred: #{e.message}" }
        format.json { render json: { error: "An error occurred: #{e.message}" }, status: :bad_request }
    end
    end


    def update
        @user = User.find(params[:id])

        if @user.update(user_params)
            render json: @user, status: :ok
        else
            render json: { errors: @user.errors.full_messages }, status: :not_found
        end
    end

    def destroy
        @user = User.find(params[:id])

        if @user
            @user.destroy
            render json: @user, status: :ok
        else
            render json: { errors: ['User not found'] }, status: :not_found
        end
    end

    def self_update
        token = request.headers['Authorization'].to_s.split(' ').last
        if token
            decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
            user_id = decoded_token.first['user_id']
            @user = User.find(user_id)
            if @user.update(user_params)
                render json: @user, status: :ok
            else
                render json: { errors: @user.errors.full_messages }, status: :not_found
            end
        else
            render json: { errors: ['User not found'] }, status: :not_found
        end
    end

    def self_destroy
        token = request.headers['Authorization'].to_s.split(' ').last
        if token
            decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
            user_id = decoded_token.first['user_id']
            @user = User.find(user_id)

            if @user
                @user.destroy
                render json: @user, status: :ok
            else
                render json: { errors: ['User not found'] }, status: :not_found
            end
        else
            render json: { errors: ['User not found'] }, status: :not_found
        end
    end
    
    private

    # Only allow a list of trusted parameters through.
    def user_params
        params.require(:user).permit(:username, :name, :surname, :birthdate, :phone_number, :email_address, :password, :state, :city, :address)
    end

    # Token-based authentication for API endpoints using JWT
    def authenticate_user_from_token!
        token = request.headers['Authorization'].to_s.split(' ').last
        if token.present?
            begin
                decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')

                if(Time.current.to_i < decoded_token.first["exp"])
                    user_id = decoded_token.first['user_id']
                    user = User.find(user_id)
                    if user
                        return true
                    else 
                        render json: { error: 'User not found' }, status: :unauthorized
                    end
                else
                    render json: { error: 'Token expired' }, status: :unauthorized
                end
            rescue JWT::DecodeError
                render json: { error: 'Invalid token' }, status: :unauthorized
            rescue ActiveRecord::RecordNotFound
                render json: { error: 'User not found' }, status: :unauthorized
            end
        else
            render json: { error: 'Token is missing' }, status: :unauthorized
        end
    end

end
