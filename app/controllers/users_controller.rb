class UsersController < ApplicationController
  def index
    if params.key?(:query)
      params.require(:query)
      @users = UserSearchQuery.new(params[:query]).call
    end
    @users ||= User.all
    render json: { users: @users.map { |user| UserSerializer.new(user) } }, status: :ok
  end

  def create
    @user = RegisterUserForm.new(user_params)
    if @user.save
      UpdateUserAccountKeyJob.perform_later(@user.user.id)
      render json: @user.user, serializer: UserSerializer, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :full_name, :phone_number, :metadata)
  end
end
