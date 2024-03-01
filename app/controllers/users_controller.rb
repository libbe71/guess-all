class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :destroy]

    def index
        render json: @users = User.all
    end

    def show
        @user = User.find(params[:id])
        render json: @user, status: :ok
    end

    def create
        @user = User.new(user_params)

        if @user.save
        render json: @user, status: :created
        else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
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

    def user_params
        params.require(:user).permit(:username, :name, :surname, :birthdate, :phone_number, :email_address, :password_digest, :state, :city, :address)
    end
end
