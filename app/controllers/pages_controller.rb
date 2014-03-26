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
    # This monster passes things into the prediction algorithem. It needs to be refactored.
    # The two ones at the end are defaul humidty and hair thickness multipliers, which I used for logged in users.
    prediction_results = Hairstyle.prediction(params[:length], params[:curliness], params[:hygiene], @humidity, @wind, @pop, params[:modifications], 1, 1)
    @bad_hair_prediction = prediction_results[:prediction].first
    @message = prediction_results[:prediction][1]
    @div_id = prediction_results[:prediction][2]
    @background_url = prediction_results[:prediction][3]
    @reasons = prediction_results[:reasons]
    
  end

  def contact
  end
end
