require 'bundler'
Bundler.require

# ENV['GITHUB_CLIENT_ID']
# ENV['GITHUB_CLIENT_SECRET']

get '/' do
  erb :index
end

get '/login-via-github' do

end
