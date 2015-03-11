require 'sinatra'
require 'pry'
  USERS = []
  set :sessions, true
  set :logging, true

  get '/' do
    if User.logged_in?(session)
      erb :success_log_in
    else
      erb :form
    end
  end

  get '/log_out' do 
    if user = User.logged_in?(session)
      user.session_id = nil
    end
    erb :form
  end

  post '/user' do
    user = User.new(params)
    if user.destroy
      @delete_message = "User is deleted!"
      erb :form
    else
      erb :success_log_in
    end
  end

  get '/edit_user' do
    if @user = User.logged_in?(session)
      erb :edit_user
    end
  end

  post '/edit_user' do
    if current_user = User.logged_in?(session)
      params["session_id"] = session["session_id"]
      user = User.new(params)
      current_user.update(user)
      redirect to('/?message=accont_is_saved')
    end
  end

  post '/' do
    log_in = UserLogIn.new(params)
    if log_in.authorization(session)
      @success_log_in = "Hi,#{params["username"]}"
      erb :success_log_in
    else
      redirect to('/?message=incorect_username_or_password')
    end
  end

  get '/register' do
    erb :register
  end

  post '/register' do
    user = User.new(params)
    response = user.save
    if response == "true"
      redirect to ('/?message=REGISTER_SUCCESS')
    else
      redirect to ("/register?message=#{response}")
    end
  end

class User

  attr_reader :first_name, :last_name, :username, :delete_by_username, :email,
   :password, :bday, :password_con
  attr_accessor :session_id
  
  def initialize(params)
    @first_name = params.fetch("fname", nil)
    @last_name = params.fetch("lname", nil)
    @username = params.fetch("uname", nil)
    @delete_by_username = params.fetch("username", nil)
    @email = params.fetch("email", nil)
    @password = params.fetch("password", nil)
    @password_con = params.fetch("password_con", nil)
    @bday = params.fetch("bday", nil)
    @session_id = params.fetch("session_id", nil)
  end

  def save
    if password == password_con
      USERS << self
      "true"
    else
      "Wrong_password"
    end
  end

  def update(new_user)
    USERS.map! { |x| x == self ? new_user : x }
  end

  def destroy
    USERS.delete_if {|user| user.username == delete_by_username }
  end

  def self.logged_in?(session)
    USERS.each do |u|
      return u if u.session_id == session["session_id"]
    end
    nil
  end
end

class UserLogIn
  attr_reader :username, :password

  def initialize(params)
    @username = params.fetch("username", nil)
    @password = params.fetch("password", nil)
  end

  def authorization(session)
    valid = false
    USERS.each do |n|
      if n.username == username && n.password == password
        n.session_id = session["session_id"]
        valid = true
        break
      end
    end
    valid
  end
end