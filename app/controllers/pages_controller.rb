class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @hairstyle = Hairstyle.current_attributes
  end
  def results
    url = "http://api.wunderground.com/api/f1860d746ba9953d/geolookup/conditions/forecast/q/#{params[:country]}/#{params[:city]}.json"
    response = HTTParty.get(url)
    json_string = JSON(response)
    parsed_json = JSON.parse(json_string)
    @city = parsed_json['location']['city']
    @country = parsed_json['location']['country_name']
    @humidity = parsed_json["forecast"]["simpleforecast"]["forecastday"].first['avehumidity']
    @temp = parsed_json["forecast"]["simpleforecast"]["forecastday"].first['high']['celsius']
    @wind = @humidity = parsed_json["forecast"]["simpleforecast"]["forecastday"].first['avewind']['kph']
    @pop = parsed_json["forecast"]["simpleforecast"]["forecastday"].first['pop']
    @weather_icon = parsed_json["forecast"]["simpleforecast"]["forecastday"].first['icon_url']
    @wunderground_logo = parsed_json['current_observation']['image']['url']
    
    
  end
  def contact
  end
end
