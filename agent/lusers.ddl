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
action "wall", :description => "write to logged in users using 'wall'" do
   display :always

   output :msg,
          :description => "wall execution results",
          :display_as  => "result"
end
action "has_user", :description => "check which systems has the given user" do
   display :always

   output :msg,
          :description => "Check if user exists on system",
          :display_as  => "has_user"
end
action "has_group", :description => "check which systems has the given group" do
   display :always

   output :msg,
          :description => "Check if group exists on system",
          :display_as  => "has_group"
end
