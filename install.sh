#!/bin/bash

set -e
set -x

apt-get -qq update > /dev/null

# Install nodesource prerequisite
apt-get -qq install curl > /dev/null

# Install hubot prerequisites
curl -sL https://deb.nodesource.com/setup | bash - > /dev/null
apt-get -qq install nodejs redis-server > /dev/null

# Install hubot
npm install --silent -g hubot@2.8.3 coffee-script > /dev/null
cd /home/vagrant
hubot --create hubot
cd hubot
npm install --silent > /dev/null

# Set default scripts
echo '["redis-brain.coffee", "shipit.coffee"]' \
  > /home/vagrant/hubot/hubot-scripts.json

# Add the BigFix module as an external script
echo '["/vagrant"]' > /home/vagrant/hubot/external-scripts.json

# Make vagrant the owner of the hubot directory
chown -R vagrant:vagrant /home/vagrant/hubot
