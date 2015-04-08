class UserSession
  attr_reader  :session, :user_repo, :user

  def initialize(session)
    @session = session
    @user_repo = Repos::User.new

    @user = find_user(session)
  end

  def find_user(params)
    username = params.fetch("username")
    password = params.fetch("password")

    @user_repo.all.each do |k|
      if k["Username"] == username && k["Password"] == password
        return user
      end
    end
  end

  def logged_in?
    user_repo.all.each { |u| u["username"] == session["username"] }
  end

  def log_in(params)
    logged_in = false
    user = find_user(params)
    if user
      session["username"] == user.username
      true
    else
      false
    end
  end
end