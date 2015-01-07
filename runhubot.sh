#!/bin/bash

#Set up the environment
#export HUBOT_IRC_ROOMS="#wikimedia-services"
export HUBOT_IRC_ROOMS="#botwar"
export HUBOT_IRC_SERVER="irc.freenode.net"
export HUBOT_IRC_NICK="services_bot"
export HUBOT_IRC_UNFLOOD="true"

# Start hubot in the background
cd /opt/services_bot
bin/hubot -a irc
