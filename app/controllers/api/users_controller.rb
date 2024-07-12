class Api::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update , :destroy]
  before_action :unauthenticate_user
  before_action :current_user

  def index
    @users = User.all
    render json: @users

  end

  def show
    # @user = User.find(params[:id])
    # @user = User.includes(:posts).find(params[:id])

    render json: @user,include: 'posts',status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end

  end

  def update
    if current_user.id == params[:id].to_i
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: {
        message: "You don't have permission to modify this route",

      }
    end
  end

  def destroy
    if current_user.id == params[:id]
      @user.destroy
      head :no_content
    else
      render json: {
        message: "You don't have permission to modify this route"
      }
    end
  end




  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
