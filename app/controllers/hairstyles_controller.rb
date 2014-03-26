class HairstylesController < ApplicationController
  before_filter :check_if_logged_in
 
  def index
  end

  def create
    @hairstyle = @current_user.hairstyles.new params[:hairstyle]
    if @hairstyle.save
      
      session[:hairstyle_id] = @hairstyle.id
      redirect_to user_path(@current_user.id)
    else
      render :new
    end
  end

  def new
    @hairstyle = Hairstyle.new 
    @length = Hairstyle.length
    @curliness = Hairstyle.curliness
    @hygiene = Hairstyle.hygiene
    @modification = Hairstyle.modification

  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
    
    hairstyle = Hairstyle.find params[:id]
    hairstyle.destroy
    redirect_to user_path(@current_user.id)
  end
  def check_if_logged_in
    redirect_to(root_path) if @current_user.nil?
  end
end
