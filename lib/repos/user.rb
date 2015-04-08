module Repos

  class User

    attr_reader :db

    def initialize
      @db = SQLite3::Database.open "users.db"
      @db.results_as_hash = true
    end

    class << self
      def migrate!
        new.migrate!
      end
    end

    def migrate!
     begin
        db.execute "CREATE TABLE IF NOT EXISTS users(Id INTEGER PRIMARY KEY AUTOINCREMENT, first_name TEXT,
          last_name TEXT, username TEXT, email TEXT, password TEXT, bday DATE)"
      rescue SQLite3::Exception => e 
        puts "Exception occurred"
        puts e
      end
    end

    def all
      prepare_db = db.prepare "SELECT * FROM users"
      prepare_db.execute 
    end

    def persist!(user)
      if user.id == nil
        db.execute "INSERT INTO users (first_name, last_name, username, email, password, bday) VALUES 
                  ('#{user.first_name}', '#{user.last_name}', '#{user.username}', '#{user.email}', 
                    '#{user.password}', '#{user.bday}')"
      else
        db.execute "UPDATE users SET First_name = '#{user.first_name}', Last_name = '#{user.last_name}',
                    Username = '#{user.username}', Email = '#{user.email}', Password = '#{user.password}',
                    Birthday = '#{user.bday}' WHERE Users.Id = #{user.id}"
      end
      puts user.inspect
    end

    def delete(user)
      db.execute "DELETE FROM users WHERE Id = '#{user.id}'"
    end
  end
end