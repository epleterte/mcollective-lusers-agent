module MCollective
  class Application::Lusers < Application
    description 'Check logged in users'

    usage <<-EOF
mco lusers [OPTIONS] [FILTERS] <action>

Default and only action is 'who'
EOF

    def post_option_parser(configuration)
      # XXX: we should take user name(s) as an argument
      if ARGV.size == 0
        #raise "You must pass an action!"
        configuration[:action] = 'who'
      else
        configuration[:action] = ARGV.shift
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
        mc.wall(:msg => ARGV)
      when "has_user"
        mc.has_user(:user => ARGV.to_s ) do |r|
          printf("%-40s: %s\n", r[:senderid], r[:body][:data][:out]) if r[:body][:data][:msg] == 0
        end
      when "has_group"
        mc.has_group(:group => ARGV.to_s ) do |r|
          printf("%-40s: %s\n", r[:senderid], r[:body][:data][:out]) if r[:body][:data][:msg] == 0
        end
      end

      printrpcstats
    end
  end
end

