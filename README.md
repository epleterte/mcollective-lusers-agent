mcollective-lusers-agent
========================

MCollective agent for querying logged in users.

Please post feature requests and issues on the issue tracker!
The plugin is not currently very pretty, but it works.

Usage
-----

The plugin client application takes some actions - _who_, _wall_, _has_user_, _has_group_. If no action is given the default action is _who_.

  who      - queries the environment for logged in users. takes no arguments.
  wall     - write a message to all users with wall. takes one string as an argument, i.e. "hello lusers"
  has_user  - ask the environment if a given user exists (with _getent passwd_). takes one or more users as a string.
  has_group  - ask the environment if a given group exists (with _getent group). takes one or more groups as a string.


Building (RPM) packages
-----------------------
  
When building on CentOS/RHEL you need rpmbuild:

  yum install rpmdevtools
  
Now proceed with building the RPMs:

  git clone https://github.com/epleterte/mcollective-lusers-agent.git && \
  cd mcollective-lusers-agent && \
  mco plugin package

Upload the rpms produced to your local repo and be happy.


