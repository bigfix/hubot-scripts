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

    run = (cmd, done) ->
      Child.exec cmd, options, (err, stdout) ->
        if err
          msg.send err.message.trim()
          msg.send "'#{cmd}' failed"
          return

        done(stdout);

    pull = ->
      msg.send 'Pulling from github'
      run 'git pull origin master', install
    
    install = ->
      msg.send 'Running npm install'
      run 'npm install', show

    show = ->
      run 'git rev-parse --short HEAD', (stdout) ->
        msg.send "Successfully synced #{stdout.trim()}. I regret nothing!"
        setTimeout die, 1000
    
    die = ->
      process.exit 0

    pull()
