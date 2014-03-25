class HairstylesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
  end

  def create
    @hairstyle = Hairstyle.new params[:user]

    if @hairstyle.save
      session[:hairstyle_id] = @hairstyle.id
      redirect_to user_path
    else
      render :new
    end
  end

  def new
    @hairstyle = Hairstyle.new 
    @length = Hairstyle.length
    @curliness = Hairstyle.curliness
    @hygiene = Hairstyle.hygiene

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
