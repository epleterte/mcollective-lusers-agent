metadata :name        => "lusers",
         :description => "Check logged in users with MCollective",
         :author      => "Christian Bryn",
         :license     => "GPLv2",
         :version     => "0.1",
         :url         => "https://github.com/epleterte/mcollective-lusers-agent",
         :timeout     => 60

action "who", :description => "Query logged in users" do
   display :always

   output :msg,
          :description => "Logged in users",
          :display_as  => "Users"
end
