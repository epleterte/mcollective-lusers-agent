module MCollective
  class Application::Lusers < Application
    description 'Check logged in users'

    usage <<-EOF
mco lusers [OPTIONS] [FILTERS] <action>

Default action is 'who'.
Other actions include

  wall      - message users with 'wall'
  has_user  - check for user with 'getent passwd'
  has_group - check for group with 'getent group'

EOF
    option :user,
           :arguments   => ["--user", "-u"],
           :description => "User name to query for",
           :type        => :string

    option :group,
           :arguments   => ["--group", "-g"],
           :description => "Group to query for",
           :type        => :string

    def handle_message(action, message, *args)
      messages = {1 => "Please specify action",
                  2 => "Action has to be one of who, wall, has_user or has_group",
                  3 => "Do you really want to operate on services unfiltered? (y/n): "}

      send(action, messages[message] % args)
    end

    def post_option_parser(configuration)
      # XXX: we should take user name(s) as an argument
      if ARGV.size == 0
        #raise "You must pass an action!"
        configuration[:action] = 'who'
      else
        valid_actions = ["who", "wall", "has_user", "has_group"]
        configuration[:action] = ARGV.shift
        if not valid_actions.include?(configuration[:action])
          handle_message(:raise, 2)
        end
          
        if ARGV.size != 0
          configuration[:user] = ARGV.to_s
        end
      end
    end

    # no configuration validation as of yet
    #def validate_configuration(configuration)
    #end

    def main
      # XXX: action is currently ignored
      action = configuration[:action]

      mc = rpcclient('lusers', :options => options)

      case action
      when "who"
        ## XXX: ...
        #if ARGV.to_s != ''
        #  user = ARGV.to_s
        #else
        #  user = ''
        #end
        #mc.who(user) do |r|
        mc.who() do |r|
          begin
              lusers = []
              r[:body][:data][:msg].each do |l|
                lusers << l['user']
              end
              unless lusers.empty?
                printf("%-40s: %s\n", r[:senderid], lusers.join(','))
              end
          rescue RPCError => e
              puts "The RPC agent returned an error: #{e}"
          end
        end
      when "wall"
        # XXX: sanitize .. ? probably 8)
        mc.wall(:msg => ARGV.to_s) do |r|
          printf("%-40s: OK\n", r[:senderid]) if r[:body][:data][:msg] == 0
        end
      when "has_user"
        mc.has_user(:user => ARGV.to_s ) do |r|
          # XXX: argv can be a string of several users, i.e. "john jane"
          #printf("%-40s: %s\n", r[:senderid], r[:body][:data][:out]) if r[:body][:data][:msg] == 0
          # this will give an entry for each user, i.e.:
          #   host.name          : john
          #   host.name          : jane
          #   other.host.name    : john
          #
          # ...which is easy to parse. Could do
          #   host.name          : john
          #                      : jane
          #
          # which would be easier to 'parse' for human eyes, visually separating hosts/data better
          r[:body][:data][:out].split(' ').each do |u|
            printf("%-40s: %s\n", r[:senderid], u)
          end
        end
      when "has_group"
        mc.has_group(:group => ARGV.to_s ) do |r|
          #printf("%-40s: %s\n", r[:senderid], r[:body][:data][:out]) if r[:body][:data][:msg] == 0
          # doing the same as in has_user:
          r[:body][:data][:out].split(' ').each do |u|
            printf("%-40s: %s\n", r[:senderid], u)
          end
        end
      end

      printrpcstats
    end
  end
end

