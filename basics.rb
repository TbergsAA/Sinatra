require 'sinatra'

# get '/more/*' do
#   params[:splat]
# end

get '/' do
  erb :form
end

post '/' do
  "Hi, you are loged in!"
end

# get '/secret' do
#   erb :secret
# end

# post '/secret' do
#   params[:secret].reverse
# end

# get '/decrypt/:secret' do
#   params[:secret].reverse
# end

# not_found do
#   halt 404, 'page not found'
# end