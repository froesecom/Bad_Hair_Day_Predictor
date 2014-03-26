class UsersController < ApplicationController
  before_filter :check_if_logged_in, :except => [:create, :new]
  before_filter :check_if_admin, :only => [:index]
  before_filter :check_owner, :only => [:show]

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

 

  def show
    
    @name = @current_user.name
    @hairstyles = @current_user.hairstyles

  end
  def custom_results
    weather = Hairstyle.weather(@current_user.country.gsub(" ", "_"), @current_user.city.gsub(" ", "_"))
    @city = weather[:city]
    @country = weather[:country]
    @humidity = weather[:humidity]
    @temp = weather[:temp]
    @wind = weather[:wind]
    @pop = weather[:pop]
    @weather_icon = weather[:weather_icon]
    @wunderground_logo = weather[:wunderground_logo]
    
    # Now for the prediction....
    
    current_hair = Hairstyle.find(params[:hairstyle])
    mods = current_hair.modifications.split("-")
    prediction_results = Hairstyle.prediction(current_hair.length, current_hair.curliness, current_hair.hygiene, @humidity, @wind, @pop, mods, @current_user.humidity_susceptibility, @current_user.thickness_susceptibility)
    @bad_hair_prediction = prediction_results[:prediction].first
    @message = prediction_results[:prediction][1]
    @div_id = prediction_results[:prediction][2]
    @background_url = prediction_results[:prediction][3]
    @reasons = prediction_results[:reasons]
  end

  def edit
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
