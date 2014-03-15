mcollective-lusers-agent
========================

MCollective agent for querying logged in users.

Please post feature requests and issues on the issue tracker!
The plugin is not currently very pretty, but it works.

Usage
-----

The plugin client application takes some actions - *who*, *wall*, *has_user*, *has_group*. If no action is given the default action is _who_.

    who        - queries the environment for logged in users.
                 takes a user name as an optional filter.
    wall       - write a message to all users with wall.
                 takes one string as an argument, i.e. "hello lusers"
    has_user   - ask the environment if a given user exists (getent passwd <user>).
                 takes one or more users as a string.
    has_group  - ask the environment if a given group exists (getent group <group>).
                 takes one or more groups as a string.

Examples
--------

    root@mco1 # mco lusers who
    login.example.domain                    : john,jane,jane,root
    web2.example.domain                     : jane
    web1.example.domain                     : john,jane,jane,root
    git.example.domain                      : root


    Finished processing 18 / 18 hosts in 124.84 ms

    root@mco1 # mco lusers has_user chbry
    icinga.example.domain                   : chbry:x:1000:1000:chbry:/home/chbry:/bin/bash
    git.example.domain                      : chbry:x:1000:1000:chbry:/home/chbry:/bin/bash
    puppet.example.domain                   : chbry:x:1000:1000:chbry:/home/chbry:/bin/bash
    web1.example.domain                     : chbry:x:1000:1000:chbry:/home/chbry:/bin/bash
    login.example.domain                    : chbry:x:1000:1000:chbry:/home/chbry:/bin/bash


    Finished processing 17 / 17 hosts in 135.51 ms
    
    root@mco1 # mco lusers wall "hello lusers"


    Finished processing 23 / 23 hosts in 135.51 ms

Building (RPM) packages
-----------------------
  
When building on CentOS/RHEL you need rpmbuild:

    yum install rpmdevtools
  
Now proceed with building the RPMs:

    git clone https://github.com/epleterte/mcollective-lusers-agent.git && \
    cd mcollective-lusers-agent && \
    mco plugin package

Upload the rpms produced to your local repo and be happy.

Todo
----

* ~~who should take a user as a filter (to check if a given user is logged in)~~
* make code prettier
* modify/add/remove users and groups? this can already be done with the puppetral functionality (which could be used internally here).
* ability to kick (kill) users? would be cool
  - an extension to this would be modifying shell to _nologin_
