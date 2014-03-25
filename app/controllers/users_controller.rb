class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
  end

  def create
     @user = User.new params[:user]

    if @user.save
      session[:user_id] = @user.id
      redirect_to new_hairstyle_path
    else
      render :new
    end

  end

  def new
    @user = User.new
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end
end
