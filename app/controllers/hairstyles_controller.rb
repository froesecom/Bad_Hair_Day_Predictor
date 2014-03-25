class HairstylesController < ApplicationController
  before_filter :check_if_logged_in, :except => [:create, :new]
  before_filter :check_if_admin, :only => [:index]
  def index
  end

  def create
    @hairstyle = Hairstyle.new params[:user]
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
  end
end
