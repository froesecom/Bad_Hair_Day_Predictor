Hairstyle.destroy_all
User.destroy_all


default_user = User.create(:name => "default", :email => "froesecom@gmail.com", :password => 'test1234', :password_confirmation => 'test1234', :gender => "male", :country => "Australia", :city => "Melbourne", :humidity_susceptibility => 1.00, :thickness_susceptibility => 1.00)

h1 = Hairstyle.create(:style_name => 'The Dude', :length => 'short', :curliness => "straight", :hygiene => "today", :modifications => 'recent haircut')
h2 = Hairstyle.create(:style_name => 'The Surfer', :length => 'shoulder-length', :curliness => "wavy", :hygiene => "days ago", :modifications => 'highlights')


default_user.hairstyles << h1 << h2

