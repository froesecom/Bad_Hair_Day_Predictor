# == Schema Information
#
# Table name: hairstyles
#
#  id            :integer          not null, primary key
#  style_name    :string(255)
#  length        :string(255)
#  curliness     :string(255)
#  hygiene       :string(255)
#  modifications :text
#  created_at    :datetime
#  updated_at    :datetime
#

class Hairstyle < ActiveRecord::Base
  attr_accessible :style_name, :length, :curliness, :hygiene, :modifications
  belongs_to :user
  
  def self.current_attributes
    {
      :length_attributes => {'no hair' => 0.0, 'very short' => 1.0, 'short' => 2.0, 'jaw-length' => 3.0, 'shoulder-length' => 4.0, 'back-length+' => 5.0},
      :curliness_attributes => {'straight'=> 2.5, 'wavy' => 4.0, 'curly' => 5.0, 'afro' => 2.0},
      :hygiene_attributes => {'today' => 1, 'yesterday' => 2.0, 'days ago' => 5.0, 'can’t remember' => 10.0},
      :modification_attributes => {'recent haircut' => -2.5, 'hair product' => -1.0, 'perm' => 1.0,  'dye'=> 1.0, 'highlights' => 1.0} 
    }
  end

  def self.mod_a_to_s(mod_array) 
    mods = ""
    if mod_array
      mod_array.each do |mod|
         mods << (mod + "-")
      end
    end
    mods
  end

  def self.mod_s_to_a(hairstyle)
    if hairstyle.modifications != nil
      mods_string = hairstyle.modifications
      mods_string.split("-")
    end
  end

  def self.length
    length_keys = []
    Hairstyle.current_attributes[:length_attributes].each do |length, value|
      length_keys.push(length)
    end
    length_keys
  end
  
  def self.curliness
    curliness_keys = []
    Hairstyle.current_attributes[:curliness_attributes].each do |curliness, value|
      curliness_keys.push(curliness)
    end
    curliness_keys
  end

  def self.hygiene
    hygiene_keys = []
    Hairstyle.current_attributes[:hygiene_attributes].each do |hygiene, value|
      hygiene_keys.push(hygiene)
    end
    hygiene_keys
  end

   def self.modification
    modification_keys = []
    Hairstyle.current_attributes[:modification_attributes].each do |modification, value|
      modification_keys.push(modification)
    end
    modification_keys
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

  def self.prediction(length_params, curliness_params, hygiene_params, humidity_params, wind_params, pop_params, modification_params, hum_sus, thickness_sus)
    hairstyle = Hairstyle.current_attributes
    reasons = []
    # The variables below are set to the score of each attribute
    length_score = hairstyle[:length_attributes][length_params]
    curliness_score = hairstyle[:curliness_attributes][curliness_params]
    hygiene_score = hairstyle[:hygiene_attributes][hygiene_params]

    # The reasons.push lines found throughout the code give users feedback on their bad hair day prediction.
    if length_score <= 2.0
      reasons.push "Shorter hair is less likely to be affected by bad weather, especially wind. "
    end
    if hygiene_score >= 5.0
      reasons.push "Greasy hair increases the risk of a bad hair day. Wash your hair!"
    end
# =========== THE ALGORITHM STARTS HERE!!!!!================================================

    if length_score == 0.0
      bad_hair_prediction = ["You have no hair. What kind of a prediction did you expect?", "I got 99 problems, being bald ain't one.", "no_hair", "/assets/no_hair.jpg"]
    else
    # <-------The following section calculates a humidity score. --------------------------------->
    # Optimum humidity is defined as 30% Equal to or over 30%, users incure a humidity multiplier. Under 30%, users incure a static electricity mutliplier.
    # Hair curliness incures 50% more humidity risk than other hair elements.
    # if statement == humidity multiplier
    # else statement == static electricity multiplier.
      humidity = humidity_params.to_f/10.0

      if humidity >= 3.0
        humidity_curl_risk = (humidity - 3.0 ) 
        humidity_other_risk = (humidity - 3.0 )/2
        #the following provides information to the users about certain high-risk humidity combinations
        if humidity >= 6.0 && curliness_score >= 4.0
          reasons.push "High humidity and wavy or curly hair increases your risk of a bad hair day. "
        elsif humidity > 7.0
          reasons.push "High humidity increases your risk for a bad hair day. "
        elsif humidity > 2.75 && humidity < 3.25
          reasons.push "Around 30% humidity is ideal for hair. "   
        end

        
      else
        humidity_curl_risk = (3.0 - humidity)
        humidity_other_risk = (3.0 - humidity)/2
        if humidity <= 1.5
          reasons.push "Low humidity can cause static electricity, which increases your risk of a bad hair day. "
        end
      end
      hum_curl_score = curliness_score  * (humidity_curl_risk) * hum_sus
      hum_other_score =  (length_score + hygiene_score) * humidity_other_risk * hum_sus

    # <-------The following section calculates a wind score  --------------------------------->
    # Optimum wind is defined as 0.0kph. For each increment above 0.0, users incure a wind multiplier.
    # The wind divisor (@wind/10) normalises the risk score to humidity and pop.
    # Hair length incures 50% more wind risk than other hair elements.
      
      wind_length_risk = wind_params/10
      wind_other_risk = wind_params/20

      wind_length_score = length_score  * wind_length_risk  * thickness_sus
      wind_other_score = (curliness_score + hygiene_score) * wind_other_risk * thickness_sus
      
      if wind_params > 30
        reasons.push "Windy days cause havoc with all types of hair. "
      elsif wind_params >= 20
        reasons.push "Windy days are especially bad for longer hair. "
      elsif wind_params <=10
        reasons.push "A lack of wind is a good omen. "
      end
      
      
    # <-------The following section calculates a P.O.P. score.  ------------------>
    # P.O.P. multiplies equaly across all hair qualities 
    # The pop divisor (@pop/50) normalises the pop risk to humidity and length risks.
    # If pop is >= 80, bad hair day multiplier doubles.
      
      if pop_params >= 80.0
        pop_score = (curliness_score + hygiene_score + length_score) * (pop_params/25)
      else
        pop_score = (curliness_score + hygiene_score + length_score) * (pop_params/50)
      end
      
      if pop_params >= 80
        reasons.push "A high probability of precipitation means trouble for your hair."
      elsif pop_params >= 65
        reasons.push "A relatively high chance of precipitation may cause you grief! "
      elsif pop_params < 20
        reasons.push "A low chance of precipitation bodes well. "
      end

    # ------ the following figures out the modifications scores 
  
    mod_score = 0.0
    if modification_params
      modification_params.each do | modification |
        mod_score +=  hairstyle[:modification_attributes][modification]
      end
    end

    # mod_score now has the sum of the mods
    
    # <-------The following section calculates overall bad hair day risk score  --------------------------------->
      # user_badhair_score = hum_curl + hum_else + wind_length + length_else + percip + params[:modifications]
     
      user_badhair_score = hum_curl_score + hum_other_score + wind_length_score + wind_other_score + pop_score + mod_score

    # <-------Bad hair day prediction below  --------------------------------->
    # bad hair prediction results are an array of this format [prediction, message, div id, backgroun url]
      if wind_params < 5.0 && humidity > 2.75 && humidity < 3.25 && hygiene_params =='can’t remember' && pop_params == 0.0
        bad_hair_prediction = "Today the weather is perfect for hair... If you wash your hair, you'll have a great hair day. Otherwise, you'll have a good, greasy hair day."
      elsif wind_params < 5.0 && humidity > 2.75 && humidity < 3.25 && pop_params == 0.0
        bad_hair_prediction = "Today the weather is perfect for hair. Go get 'em champ!"
      elsif user_badhair_score > 100.0
        bad_hair_prediction = ["Worst day for hair in the history of the universe.", "", "worst", ""]
      else
        case user_badhair_score
        when 0.0..10.0
          bad_hair_prediction = ["Perfect day for hair", "Your hair is perfect. Let's be in love.", "perfect", "/assets/amazing.jpg"]
        when 10.0..20.0
          bad_hair_prediction = ["Amazing day for hair", "Well ain't that something'!", "amazing", "/assets/amazing.jpg"]
        when 20.0..30.0
          bad_hair_prediction = ["Good day for hair", "Hot diggity dog!", "good", "/assets/good.jpg"]
        when 30.0..40.0
          bad_hair_prediction = ["Average day for hair", "Who said average?!", "average", "/assets/average.jpg"]
        when 40.0..50.0
          bad_hair_prediction = ["Below average day for hair", "You have got to be fucking kidding me.", "below_average", "/assets/below_average.jpg"]
        when 50.0..60.0
          bad_hair_prediction = ["Bad day for hair", "Do I look happy?", "bad", "/assets/bad.jpg"]
        when 60.0..70.0
          bad_hair_prediction = ["Crap day for hair", "Well that's crap.", "crap", "/assets/bad.jpg"]
        when 70.0..80.0
          bad_hair_prediction = ["Terrible day for hair", "What now Martha? What now?", "terrible", "/assets/terrible.jpg"]
        when 80.0..90.0
          bad_hair_prediction = ["Horrendous day for hair", "Don get over here. You're not going to believe this shit!", "horrendous", "/assets/horrendous.jpg"]
        when 90.0..100.0
          bad_hair_prediction = ["Catestrophic day for hair", "", "catestrophic", ""]
        end
      end
    end
    

    # --------------The following returns the results of the prediction along with the reasons----------------
    results = {
      :prediction => bad_hair_prediction,
      :reasons => reasons
    }
    results
  end
end
