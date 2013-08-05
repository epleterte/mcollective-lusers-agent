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
      elsif ARGV.size > 1
        raise 'Please specify only one action'
      else
        configuration[:action] = ARGV.shift
      end
    end

    # no configuration validation as of yet
    #def validate_configuration(configuration)
    #end

    def main
      # XXX: action is currently ignored
      #action = configuration[:action]

      mc = rpcclient('lusers', :options => options)

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

      printrpcstats
    end
  end
end

