class TweetWorker < ActiveRecord::Base

	include Sidekiq::Worker

	def perform(tweet_id)
    	tweet = Twett.find(tweet)# Encuentra el tweet basado en el 'tweet_id' pasado como argumento
    	user  = User.find(tweet.user_id) # Utilizando relaciones deberás encontrar al usuario relacionado con dicho tweet

    	# Manda a llamar el método del usuario que crea un tweet (user.tweet)
	end

end
