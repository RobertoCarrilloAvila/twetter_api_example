class User < ActiveRecord::Base

	has_many :twetts
	validates :name, uniqueness: true

	def connection
		Twitter::REST::Client.new do |config|
			#consumer aplicacion
			#acces usuario
			config.consumer_key        = ENV['TWITTER_KEY']
			config.consumer_secret     = ENV['TWITTER_SECRET']
			config.access_token        = self.token
			config.access_token_secret = self.token_secret
		end
	end


	def tweet_later(text)
    	tweet = Twett.create(user_id: self.id, description: text) # Crea un tweet relacionado con este usuario en la tabla de tweets
    	# Este es un método de Sidekiq con el cual se agrega a la cola una tarea para ser
    	# 
    	TweetWorker.perform_in(30.seconds, tweet.id)
    	#La última linea debe de regresar un sidekiq job id
    end

end
