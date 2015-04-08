require 'sinatra'
require 'sinatra/sequel'
require 'pry'
require 'sqlite3'
Dir[File.dirname(__FILE__) + '/lib/*/*.rb'].each {|file| require_relative file }
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require_relative file }
Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require_relative file }
Dir[File.dirname(__FILE__) + '/controllers/*/*.rb'].each {|file| require_relative file }

set :port, 3000
set :sessions, true
set :logging, true

Repos::User.migrate!

get '/' do
  user_session = UserSession.new(session)
  if user_session.logged_in?
    @user = user_session.user
    erb :form
  else
    @user = user_session
    erb :form
  end
end

enable :session

post '/' do
  session["params"] = params
  log_in = UserSession.new(session)
  if log_in.log_in(params)
    @success_log_in = "Hi,#{params["username"]}"
    erb :success_log_in
  else
    redirect to('/?message=incorect_username_or_password')
  end
end


get '/register' do
  @user = User.new(params)
  erb :register
end

post '/register' do
  user = User.new(params)
  if user.save
    redirect to ('/?message=REGISTER_SUCCESS')
  else
    session[:errors] = user.errors
    query = params.map{|key, value| "#{key}=#{value}"}.join("&")
    redirect to ("/register?#{query}")
  end
end

before '/edit_user' do
  logged_in?
end

get '/edit_user' do
  logged_in?
  erb :edit_user
end

post '/edit_user' do
  if current_user = Controllers::User.logged_in?(session)
    params["session_id"] = session["session_id"]
    user = Controllers::UserController.new(params)
    current_user.update(user)
    redirect to('/?message=accont_is_saved')
  end
end
get '/log_out' do
  session["username"] = nil
  erb :form
end

post '/user' do
  user = Controllers::User.new(params)
  if user.destroy
    @delete_message = "User is deleted!"
    erb :form
  else
    erb :success_log_in
  end
end