#The Bad Hair Day Predictor.
Hey all. This is my first web app, a project for General Assembly.

##the concept
I was trying to build an app that would take current weather conditions in the user's city, as well as the user's hair attributes, to predict whether or not they're going to have a bad hair day.

The concept is a bit of fun, but I wanted the app to make a legit prediction based on the assumptions I've made in the algorithm. I think I've done that. 

In terms of weather, tha app uses humidity, wind, and probability of precipitation. These things multipliy in different ways against the user's hair qualities. For example, humidity multiplies on all hair attributes, but more so on curliness. Wind multiplies on all attributes, but more so on length. Logged-in user's can change their susceptibility to humidity and wind. I also take into account hygiene and modifications, like haircuts.

##data
I originally started out with has_and_belongs_to_many relationship between users and hairstyles, but near the end of the project it became apparent that I actually didn't want more than one user to have the same hairstyle... so I nuked the join table, and changed the association so that hairstyle had a user_id. Users can view their own hairstyles, but no one else's. Customised hairstyles can be saved to later generate custom predictions.

##API
I'm using the Weather Underground API to get the current weather. It was great in that it has a lot of data, but the fact that it didn't use standard country iso codes was a pain. Because of this, the country_select helper wasn't as accurate as it should be, becuase I had to return country names (not iso codes) and then .gsub the country strings. The api didn't like some of the returned strings. 

The best thing to do, if continuing with this API, would be to translate the ISO codes to wunderground's codes, which wouldn't be difficult, but I didn't do because I ran out of time before the deadline for this project.

Thanks to Joel for helping me with the following thank-you message:

"I, Erik Froese, would like to thank Joel Turnbull and Mathilda Thompson for being the greatest teachers in the history of the General Assembly. Any future wealth and fame I acrue will be due to their expert tutelage."

In all seriousness, the guidance of those two was crucial. Thanks also to my classmates. A great crew... even if most of them don't go by their real names.
