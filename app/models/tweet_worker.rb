class TweetWorker

	include Sidekiq::Worker

	def perform(tweet_id)
		puts "************************** perform"
    	p tweet = Twett.find(tweet_id)# Encuentra el tweet basado en el 'tweet_id' pasado como argumento
    	p user  = tweet.user # Utilizando relaciones deberás encontrar al usuario relacionado con dicho tweet

    	# Manda a llamar el método del usuario que crea un tweet (user.tweet)
    	user.connection.update!(tweet.description)
	end

end
