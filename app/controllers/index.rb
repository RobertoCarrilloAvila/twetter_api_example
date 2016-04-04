get '/' do
  erb :index
end

post '/add' do
	user = params[:name]
	u = User.create(name: user)
	if u.valid?
		CLIENT.user_timeline(u.name).each { |t| u.twetts << Twett.create(description: t.text) }
		#puts "*"*30
		#puts "valido"
	end
	
	redirect to "/#{u.name}"
end



get '/tweet' do
    erb :new_tweet
end


post '/tweet' do
	text = params[:texto]
    #begin
    	puts "*"*40
    	puts text
    	CLIENT.update(text)
    	erb "Twett publicado exitosamente", layout: false
    #rescue
    #	erb "Error al publicar el Twett", layout: false
    #end
end


get '/:user' do
	@name = params[:user]
	@twetts = User.find_by(name: @name).twetts
	erb :twetts	
end
