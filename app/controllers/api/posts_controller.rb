class Api::PostsController < ApplicationController
  before_action :set_post, only: %i[ show update destroy ]
  before_action :unauthenticate_user
  before_action :current_user

  # GET /posts
  def index
    @posts = Post.all

    render json: @posts
  end

  # GET /posts/1
  def show
    render json: @post
  end

  # POST /posts
  def create
    post = post_params
    post['user_id'] = current_user.id

    @post = Post.new(post)

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    current_post = Post.find(params[:id])

    if current_post.user_id == current_user.id
      if @post.update(post_params)
        render json: @post
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    else
      render json: {
        message: "You don't have permistion to modify this route"
      }
    end
  end

  # DELETE /posts/1
  def destroy
    current_post = Post.find(params[:id])
    if current_post.user_id == current_user.id
      @post.destroy!
      render json: {
        message: "Post Delete Successfully!"
      }
    else
      render json: {
        message: "You don't have permission to this route"
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :user_id)
    end
end
