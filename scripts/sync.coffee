# Description:
#   Sync hubot-scripts from github
#
# Dependencies:
#   None
#
# Commands:
#   hubot sync - Sync with github
#
# Author:
#   greenb

Child = require 'child_process'

options =
  cwd: process.env.HUBOT_SCRIPTS

module.exports = (robot) ->
  robot.respond /sync/i, (msg) ->

    pull = ->
      msg.send 'Pulling from github'
      Child.exec 'git pull origin master', options, (err) ->
        if err
          msg.send err.message.trim()
          msg.send 'git pull failed'
          return

        install()
    
    install = ->
      msg.send 'Running npm install'
      Child.exec 'npm install', options, (err) ->
        if err
          msg.send err.message.trim()
          msg.send 'npm install failed'
          return

        msg.send 'Sync successful. I regret nothing!'
        setTimeout die, 1000
    
    die = ->
      process.exit 0

    pull()
