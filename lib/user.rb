class User
  attr_reader :id, :first_name, :last_name, 
              :username, :delete_by_username, :email,
              :password, :bday, :password_con, :user_repo

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
    @user_repo = Repos::User.new
  end

  def save
    if validate
      user_repo.persist!(self)
      true
    else
      false
    end
  end

  def validate
    @errors = {}
      
    if first_name.length <= 2
      @errors["fname"] = "First name too short"
    end

    if last_name.length <= 2
      @errors["lname"] = "Last name too short"
    end

    if username.length <= 2
      @errors["uname"] = "Username too short"
    end

    if email.length <= 2
      @errors["email"] = "Wrong email"
    end

    if password != password_con
      @errors["password"] = "wrong password"
    end

    if bday.empty?
      @errors["bday"] = "enter your birthday"
    end

    @errors.empty?
  end
end
