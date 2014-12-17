#!/bin/bash

set -e
set -x

# Install nodesource prerequisite
apt-get -qq install curl

# Install hubot prerequisites
curl -sL https://deb.nodesource.com/setup | bash - > /dev/null
apt-get -qq install nodejs redis-server

# Install hubot
npm install --silent -g hubot@2.8.3 coffee-script
cd /home/vagrant
hubot --create hubot
cd hubot
npm install --silent

# Set default scripts
echo '["redis-brain.coffee", "shipit.coffee"]' \
  > /home/vagrant/hubot/hubot-scripts.json

# Add the BigFix module as an external script
echo '["/vagrant"]' > /home/vagrant/hubot/external-scripts.json

# Make vagrant the owner of the hubot directory
chown -R vagrant:vagrant /home/vagrant/hubot
