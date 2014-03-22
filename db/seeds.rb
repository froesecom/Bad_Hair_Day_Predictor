Hairstyle.destroy_all
User.destroy_all


default_user = User.create(:name => "default", :email => "froesecom@gmail.com", :gender => "male", :country => "Australia", :city => "Melbourne")

h1 = Hairstyle.create(:style_name => 'The Dude', :length => 'short', :curliness => "straight", :hygiene => "today", :modifications => 'recent haircut')
h2 = Hairstyle.create(:style_name => 'The Surfer', :length => 'shoulder-length', :curliness => "wavy", :hygiene => "days ago", :modifications => 'highlights')


default_user.hairstyles = [h1, h2]

