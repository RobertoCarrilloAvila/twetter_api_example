
enable :sessions

before '/' do
	redirect to '/welcome' if session[:user]==nil
end

get '/welcome' do
	erb :welcome
end

get '/' do
	erb :index
end



post '/add' do
	user = params[:name]
	u = User.create(name: user)
	if u.valid?
		puts "/"*40
		p session[:user]
		p session[:user].connection.user_timeline(u.name).each { |t| u.twetts << Twett.create(description: t.text) }
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
    #t = session[:user].connection.update(text)
    #session[:user].twetts << Twett.create(description: t.text)
    id = session[:user].tweet_later(text)
    #redirect to "/status/#{id}"
    erb "#{id}", layout: false
    #rescue
    #	erb "Error al publicar el Twett", layout: false
    #end
end

get '/status/:job_id' do
  # regresa el status de un job a una petición AJAX
  erb "#{job_is_complete(params[:job_id])}", layout: false
end


get '/sign_in' do
  # El método `request_token` es uno de los helpers
  # Esto lleva al usuario a una página de twitter donde sera atentificado con sus credenciales
  redirect request_token.authorize_url(:oauth_callback => "http://#{host_and_port}/auth")
  # Cuando el usuario otorga sus credenciales es redirigido a la callback_url 
  # Dentro de params twitter regresa un 'request_token' llamado 'oauth_verifier'
end

get '/auth' do
  # Volvemos a mandar a twitter el 'request_token' a cambio de un 'acces_token' 
  # Este 'acces_token' lo utilizaremos para futuras comunicaciones.   
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # Despues de utilizar el 'request token' ya podemos borrarlo, porque no vuelve a servir. 
  session.delete(:request_token)
  # puts "*"*40
  # pp @access_token
  # puts params[:oauth_token]
  # puts params[:oauth_token_secret]

  # Aquí es donde deberás crear la cuenta del usuario y guardar usando el 'acces_token' lo siguiente:
  # nombre, oauth_token y oauth_token_secret
  nombre = @access_token.params[:screen_name]
  token = @access_token.token
  token_secret = @access_token.secret

  #find_or_create_by
   u = User.find_or_create_by(name: nombre)
   puts "*"*40
   p u
   u.update(token: token, token_secret: token_secret)

  #puts "/"*40
  # p @access_token.params[:screen_name]
  # p @access_token.token
  # p @access_token.secret
  
  session[:user] = u

  redirect to '/'

  # CLIENT = Twitter::REST::Client.new do |config|
  # 	config.consumer_key        = ENV['CONSUMER_KEY']
  # 	config.consumer_secret     = ENV['CONSUMER_SECRET']
  # 	config.access_token        = ENV["ACCESS_TOKEN"]
  # 	config.access_token_secret = ENV["ACCESS_SECRET"]
  # end

  # No olvides crear su sesión 
end

get '/sign_out' do
  	# Para el signout no olvides borrar el hash de session
  	session.clear
  	redirect to '/'
  end

  get '/:user' do
  	@name = params[:user]
  	@twetts = User.find_by(name: @name).twetts
  	erb :twetts	
  end
