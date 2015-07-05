require 'bundler'
Bundler.require
Dotenv.load

# ENV['GITHUB_CLIENT_ID']
# ENV['GITHUB_CLIENT_SECRET']

get '/' do
  erb :index
end

get '/lala' do
  "<h1>Weeeee!</h1>"
end

get '/login-via-github' do
  # client = OAuth2::Client.new(
  #   ENV['GITHUB_CLIENT_ID'],
  #   ENV['GITHUB_CLIENT_SECRET'],
  #   site: 'https://github.com/login'
  # )


  # authorize_url = client.auth_code.authorize_url(
  #   redirect_uri: 'http://localhost:9393/oauth/callback'
  # )


  # authorize_url = URI.parse(authorize_url)
  # authorize_url.path = '/login/oauth/authorize'
  # authorize_url = authorize_url.to_s

  # redirect authorize_url

  base_url = 'https://github.com/login/oauth/authorize'
  authorize_url = base_url + "?client_id=#{ENV['GITHUB_CLIENT_ID']}
                              &state=applecadabra"

  redirect authorize_url

end

get '/oauth/callback' do
  code = params[:code]
end
