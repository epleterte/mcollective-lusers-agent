# checkachecka logged in users
# XXX: Optional input: User name pattern to query for
# XXX: Is it possible to not display empty results?
# XXX: ability to check for presence of user on a system (getent 'user')
module MCollective
  module Agent
    class Lusers<RPC::Agent
      def who
        out = ""
        # XXX: use w instead of who? Slower, but shows idle time etc, which is of great interest.
        reply[:status] = run("who", :stdout => out, :stderr => :err, :chomp => false, :environment => {"LC_ALL" => "en_US.UTF-8"})
        lusers = []
        out.each do |l|
          # we rely heavily on having that environment variable set
          user = l.strip.split{/ */}
          # XXX: this if bit does not work I thing
          if not user.include?(4)
            user[4] = "local"
          end
          lusers << { "user" => user[0], "tty" => user[1], "login_date" => user[2], "login_time" => user[3], "from" => user[4] }
        end
        return lusers
      end
      
      def wall
      end


      action "who" do
        # XXX: error handling in case who fails
        reply[:msg] = who()
      end
      action "wall" do
        validate :msg, String
        reply[:msg] = run("wall #{request[:msg]}", :stdout => :out, :stderr => :err, :chomp => false)
      end
      action "has_user" do
        # XXX: list?
        validate :user, String
        reply[:msg] = run("getent passwd #{request[:user]}", :stdout => :out, :stderr => :err, :chomp => false)
      end
      action "has_group" do
        # XXX: list?
        validate :user, String
        reply[:msg] = run("getent passwd #{request[:user]}", :stdout => :out, :stderr => :err, :chomp => false)
      end

    end
  end
end
