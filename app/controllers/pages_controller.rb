class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @hairstyle_attributes = Hairstyle.current_attributes
  end

  def results
    weather = Hairstyle.weather(params[:user][:country].gsub(" ", "_"), params[:city].gsub(" ", "_"))
    @city = weather[:city]
    @country = weather[:country]
    @humidity = weather[:humidity]
    @temp = weather[:temp]
    @wind = weather[:wind]
    @pop = weather[:pop]
    @weather_icon = weather[:weather_icon]
    @wunderground_logo = weather[:wunderground_logo]
    prediction_results = Hairstyle.prediction(params[:length], params[:curliness], params[:hygiene], @humidity, @wind, @pop, params[:modifications])
    @bad_hair_prediction = prediction_results[:prediction]
    @reasons = prediction_results[:reasons]
    
  end

  def contact
  end
end
