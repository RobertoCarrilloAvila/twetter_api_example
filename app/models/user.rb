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

end
