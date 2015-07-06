require 'bundler'
Bundler.require
Dotenv.load

enable :sessions
set :session_secret, '9a103qhdkb03nht9dy2jig9js'

# require 'active_support'
# require 'active_support/core_ext/object/to_query'

# ENV['GITHUB_CLIENT_ID']
# ENV['GITHUB_CLIENT_SECRET']

helpers do
  def github_client
    @github_client ||= OAuth2::Client.new(
      ENV['GITHUB_CLIENT_ID'],
      ENV['GITHUB_CLIENT_SECRET'],
      site: 'https://github.com/login'
    )
  end

  def get_github_user_info
    github_user_info = HTTParty.get(
      'https://api.github.com/user',
      query: { access_token: session[:github_access_token] }
    )
      # equivalent: https://api.github.com/user?access_token=...
      # headers: {
      #   "Authorization" => "token #{access_token}",
      #   "User-Agent" => "OAuth_Practice"
      # })

    return github_user_info.parsed_response
  end

  def user_info
    session[:github_user_info]
  end

  def logged_in?
    !!session[:github_user_info]
  end
end

get '/' do
  erb :index
end

get '/login-via-github' do
  authorize_url = github_client.auth_code.authorize_url(
    redirect_uri: 'http://localhost:9393/oauth/callback'
  )

  authorize_url = URI.parse(authorize_url)
  authorize_url.path = '/login/oauth/authorize'
  authorize_url = authorize_url.to_s

  redirect authorize_url

  # THIS ALSO WORKS
  # base_url = 'https://github.com/login/oauth/authorize'
  # authorize_url = base_url + "?client_id=#{ENV['GITHUB_CLIENT_ID']}"
  # ^^^ could form the above with active_support's #to_query

  # redirect authorize_url

end

get '/oauth/callback' do
  code = params[:code]
  # token = github_client.auth_code.get_token(
  #   code,
  # )

  response = HTTParty.post('https://github.com/login/oauth/access_token', query: {
      client_id: ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_CLIENT_SECRET'],
      code: code
    })

  p response
  binding.pry

  response = Rack::Utils.parse_query(response.body)
  access_token = response["access_token"]

  # this holds the user's access token
  session[:github_access_token] = access_token
  # this holds the user's github profile info
  # jarred calls this session[:current_user]
  session[:github_user_info] = get_github_user_info

  redirect '/'
end

get '/logout' do
  session.clear
  # session.delete(:github_access_token)
  # session.delete(:github_user_info)
  redirect '/'
end

