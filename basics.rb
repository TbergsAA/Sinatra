require 'sinatra'
require 'pry'
  USERS = []

  get '/' do  
    erb :form
  end

  post '/' do
    log_in = UserLogIn.new(params)
    if log_in.authorization
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

  attr_reader :first_name, :last_name, :username, :email, :password, :bday, :password_con
  
  def initialize(params)
    @first_name = params.fetch("fname", nil)
    @last_name = params.fetch("lname", nil)
    @username = params.fetch("uname", nil)
    @email = params.fetch("email", nil)
    @password = params.fetch("password", nil)
    @password_con = params.fetch("password_con", nil)
    @bday = params.fetch("bday", nil)
  end

  def save
    if password == password_con
      USERS << self
      "true"
    else
      "Wrong_password"
    end
  end
end

class UserLogIn
  attr_reader :username, :password

  def initialize(params)
    @username = params.fetch("username", nil)
    @password = params.fetch("password", nil)
  end

  def authorization
    valid = false
    USERS.each do |n|
      if n.username == username && n.password == password
        valid = true
        break
      end
    end
    valid
  end
end