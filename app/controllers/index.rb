
enable :sessions

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
  puts "*"*40
  pp @access_token
  # puts params[:oauth_token]
  # puts params[:oauth_token_secret]

  # Aquí es donde deberás crear la cuenta del usuario y guardar usando el 'acces_token' lo siguiente:
  # nombre, oauth_token y oauth_token_secret
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
