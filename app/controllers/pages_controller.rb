class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @hairstyle = Hairstyle.current_attributes
  end

  def results
    weather = Hairstyle.weather(params[:country], params[:city])
    @city = weather[:city]
    @country = weather[:country]
    @humidity = weather[:humidity]
    @temp = weather[:temp]
    @wind = weather[:wind]
    @pop = weather[:pop]
    @weather_icon = weather[:weather_icon]
    @wunderground_logo = weather[:wunderground_logo]
    @bad_hair_prediction = Hairstyle.prediction(params[:length], params[:curliness], params[:hygiene], @humidity, @wind, @pop)

    
  end

  def contact
  end
end
