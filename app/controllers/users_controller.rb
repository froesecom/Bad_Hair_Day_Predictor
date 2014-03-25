class UsersController < ApplicationController
  before_filter :check_if_logged_in, :except => [:create, :new]
  before_filter :check_if_admin, :only => [:index]
  before_filter :check_owner, :only => [:show]
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

  private
  def check_if_logged_in
    redirect_to(root_path) if @current_user.nil?
  end

  def check_if_admin
    redirect_to(root_path) if @current_user.nil? || @current_user.admin == false
  end

  def check_owner
    redirect_to(root_path) if params[:id] != @current_user.id.to_s 
  end
end
