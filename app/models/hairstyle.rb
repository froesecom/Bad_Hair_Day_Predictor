# == Schema Information
#
# Table name: hairstyles
#
#  id            :integer          not null, primary key
#  style_name    :string(255)
#  length        :string(255)
#  curliness     :string(255)
#  hygiene       :string(255)
#  modifications :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Hairstyle < ActiveRecord::Base
  attr_accessible :style_name, :length, :curliness, :hygiene, :modifications
  has_and_belongs_to_many :users

  def self.current_attributes
    {
      :length_attributes => {'no hair' => 0.0, 'very short' => 1.0, 'short' => 2.0, 'jaw-length' => 3.0, 'shoulder-length' => 4.0, 'back-length+' => 5.0},
      :curliness_attributes => {'straight'=> 2.5, 'wavy' => 4.0, 'curly' => 5.0, 'afro' => 2.0},
      :hygiene_attributes => {'today' => 1, 'yesterday' => 2.0, 'days ago' => 5.0, 'can’t remember' => 10.0},
      :modification_attributes => {'recent haircut' => -2.5, 'hair product' => -1.0, 'perm' => 1.0,  'dye'=> 1.0, 'highlights' => 1.0} 
    }
  end

  def self.weather(country, city)
    url = "http://api.wunderground.com/api/f1860d746ba9953d/geolookup/conditions/forecast/q/#{country}/#{city}.json"
    response = HTTParty.get(url)
    json_string = JSON(response)
    parsed_json = JSON.parse(json_string)
    {
    :city => parsed_json['location']['city'],
    :country => parsed_json['location']['country_name'],
    :humidity => parsed_json["forecast"]["simpleforecast"]["forecastday"].first['avehumidity'],
    :temp => parsed_json["forecast"]["simpleforecast"]["forecastday"].first['high']['celsius'],
    :wind => @humidity = parsed_json["forecast"]["simpleforecast"]["forecastday"].first['avewind']['kph'],
    :pop => parsed_json["forecast"]["simpleforecast"]["forecastday"].first['pop'],
    :weather_icon => parsed_json["forecast"]["simpleforecast"]["forecastday"].first['icon_url'],
    :wunderground_logo => parsed_json['current_observation']['image']['url']
  }
  
  end

  def self.prediction(length_params, curliness_params, hygiene_params, humidity_params, wind_params, pop_params)
    hairstyle = Hairstyle.current_attributes
    humidity = humidity_params.to_f/100.0

    if hairstyle[:length_attributes][length_params] == 0.0
      bad_hair_prediction = "You have no hair. What kind of a prediction did you expect?"

    else
    # <-------The following section calculates a humidity score. --------------------------------->
    # Optimum humidity is defined as 0.30. Equal to or over 0.30, users incure a humidity multiplier. Under 0.30, users incure a static electricity mutliplier.
    # Hair curliness incures 50% more humidity risk than other hair elements.
    # the multipliers 10 and 5 exist to normalize humidity risk to wind and pop risk.
    # if statement == humidity multiplier
    # else statement == static electricity multiplier.

      if humidity >= 0.30
        humidity_curl_risk = ((humidity - 0.30 ) * 10)
        humidity_other_risk = ( @humidity - 0.30 ) * 5
      else
        humidity_curl_risk = ((0.30 - humidity) * 10)
        humidity_other_risk = (0.30 - humidity) * 5 
      end
      
      
      hum_curl_score = @curliness_attributes[params["curliness"]]  * (humidity_curl_risk) 
      hum_other_score =  (@length_attributes[params["length"]] + @hygiene_attributes[params["hygiene"]]) * humidity_other_risk
      puts "Your humidity-curliness score is #{hum_curl_score}"
      puts "Your humidity-other score is #{hum_other_score}"

    # <-------The following section calculates a wind score  --------------------------------->
    # Optimum wind is defined as 0.0kph. For each increment above 0.0, users incure a wind multiplier.
    # The wind divisor (@wind/10) normalises the risk score to humidity and pop.
    # Hair length incures 50% more wind risk than other hair elements.
      
      wind_length_risk = @wind/10
      wind_other_risk = (@wind/10)/2
      
      wind_length_score = @length_attributes[params["length"]]  * wind_length_risk 
      wind_other_score = (@curliness_attributes[params["curliness"]] + @hygiene_attributes[params["hygiene"]]) * wind_other_risk
      
      puts "Your wind-length score is #{wind_length_score}"
      puts "Your wind-other score is #{wind_other_score}"
      
      
    # <-------The following section calculates a P.O.P. score.  ------------------>
    # P.O.P. multiplies equaly across all hair qualities 
    # The pop divisor (@pop/50) normalises the pop risk to humidity and length risks.
    # If pop is >= 80, bad hair day multiplier doubles.
      
      if @pop >= 80.0
        pop_score = (@curliness_attributes[params["curliness"]] + @hygiene_attributes[params["hygiene"]] + @length_attributes[params["length"]]) * (@pop/25)
      else
        pop_score = (@curliness_attributes[params["curliness"]] + @hygiene_attributes[params["hygiene"]] + @length_attributes[params["length"]]) * (@pop/50)
      end
      puts "Your P.O.P. score is #{pop_score}"

    # ------ the following figures out the modifications scores 

    # <-------The following section calculates overall bad hair day risk score  --------------------------------->
      # user_badhair_score = hum_curl + hum_else + wind_length + length_else + percip + params[:modifications]
      user_badhair_score = hum_curl_score + hum_other_score + wind_length_score + wind_other_score + pop_score
      
      puts "Your bad hair day score is #{user_badhair_score}"


    # <-------Bad hair day prediction below  --------------------------------->
      if @wind < 5.0 && @humidity > 0.275 && @humidity < 0.325 && @hygiene =='can’t remember' && @pop == 0.0
        bad_hair_prediction = "Today the weather is perfect for hair... If you wash your hair, you'll have a great hair day. Otherwise, you'll have a good, greasy hair day."
      elsif @wind < 5.0 && @humidity > 0.275 && @humidity < 0.325 && @pop == 0.0
        bad_hair_prediction = "Today the weather is perfect for hair. Go get 'em champ!"
      elsif user_badhair_score > 150.0
        bad_hair_prediction = "Worst day for hair in the history of the universe."
      else
        case user_badhair_score
        when 0.0..15.0
          bad_hair_prediction = "Perfect day for hair"
        when 15.0..30.0
          bad_hair_prediction = "Amazing day for hair"
        when 30.0..45.0
          bad_hair_prediction = "Great day for hair"
        when 45.0..60.0
          bad_hair_prediction = "Good day for hair"
        when 60.0..75.0
          bad_hair_prediction = "Average day for hair"
        when 75.0..90.0
          bad_hair_prediction = "Below-average day for hair"
        when 90.0..105.0
          bad_hair_prediction = "Bad day for hair"
        when 105.0..120.0
          bad_hair_prediction = "Terrible day for hair"
        when 120.0..135.0
          bad_hair_prediction = "Horrendous day for hair"
        when 135.0..150.0
          bad_hair_prediction = "Catestrophic day for hair"
        end
      end
    end

    bad_hair_prediction
  end
end
