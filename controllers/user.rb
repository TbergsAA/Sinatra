module Controllers

  class User

    attr_reader :errors, :user, :user_repo
    attr_accessor :session_id
    
    def initialize(params)
      @user = User.new(params)
      @user_repo = UsersRepo.new
      @errors = {}
    end

    def destroy
      @user_repo.delete(user)
    end
  end
end