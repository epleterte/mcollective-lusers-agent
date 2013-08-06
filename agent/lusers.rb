# checkachecka logged in users
# XXX: Optional input: User name pattern to query for
# XXX: Is it possible to not display empty results?
# XXX: ability to check for presence of user on a system (getent 'user')
module MCollective
  module Agent
    class Lusers<RPC::Agent
      def parse_who(data, filter='')
        lusers = []
        data.each do |l|
          # we rely heavily on having that environment variable (LC_ALL => en_US.UTF-8) set
          user = l.strip.split{/ */}
          if not filter == '' and not filter == user[0]
            next
          end

          # XXX: this if bit does not work I thing
          if not user.include?(4)
            user[4] = "local"
          end
          lusers << { "user" => user[0], "tty" => user[1], "login_date" => user[2], "login_time" => user[3], "from" => user[4] }
        end
        return lusers
      end
      
      action "who" do
        if request.include(:user)
          validate :user, String
        else
          # set empty filter ...
          user = ''
        end

        data = ""
        # XXX: use w instead of who? Slower, but shows idle time etc, which is of great interest.
        reply[:status] = run("who", :stdout => data, :stderr => :err, :chomp => false, :environment => {"LC_ALL" => "en_US.UTF-8"})
        reply[:msg] = parse_who(data, user)
      end
      action "wall" do
        validate :msg, String
        reply[:msg] = run("wall #{request[:msg]}", :stdout => :out, :stderr => :err, :chomp => false)
      end
      action "has_user" do
        # XXX: list?
        validate :user, String
        reply[:msg] = run("getent passwd #{request[:user]}", :stdout => :out, :stderr => :err, :chomp => true)
      end
      action "has_group" do
        # XXX: list?
        validate :group, String
        reply[:msg] = run("getent group #{request[:group]}", :stdout => :out, :stderr => :err, :chomp => true)
      end

    end
  end
end
