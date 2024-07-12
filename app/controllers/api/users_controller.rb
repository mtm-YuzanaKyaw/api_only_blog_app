class Api::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update , :destroy]
  before_action :unauthenticate_user
  before_action :current_user

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
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

  def current_user
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split.last,
                              "123456789").first

      current_user = User.find(jwt_payload['sub'])

      # render json: {jwt_payload: jwt_payload, id: params[:id]}

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
