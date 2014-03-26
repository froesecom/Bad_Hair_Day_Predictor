class HairstylesController < ApplicationController
  before_filter :check_if_logged_in
 
  def index
  end

  def create
    # The following creates an array of modifications and converts them to a string so they can be saved in the database
    mods = Hairstyle.mod_a_to_s(params[:modifications])
    params_w_mods = params[:hairstyle].merge("modifications" => mods)
    
#Now we create a new hairstyle
    @hairstyle = @current_user.hairstyles.new(params_w_mods)
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
    @hairstyle = Hairstyle.find params[:id]
    @length = Hairstyle.length
    @curliness = Hairstyle.curliness
    @hygiene = Hairstyle.hygiene
    @modification = Hairstyle.modification
    
    # This maginificent piece of crap took me hours to figure out.
    # It allows for pre-checking the modification check boxes in the form
    if Hairstyle.mod_s_to_a(@hairstyle) != nil
      @user_modification = Hairstyle.mod_s_to_a(@hairstyle)
    else
      @user_modification = ""
    end
    
  
  end

  def show
  end

  def update
  
    mods = Hairstyle.mod_a_to_s(params[:modifications])
    params_w_mods = params[:hairstyle].merge("modifications" => mods)
    hairstyle = Hairstyle.find params[:id]
    hairstyle.update_attributes(params_w_mods)
    redirect_to user_path(@current_user.id)
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
