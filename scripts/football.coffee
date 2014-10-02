# Description:
#   In which Hubot gives you football related information
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot how many days until football?
#   hubot what's the best football team?
#   hubot cheer for the packers
#   
#
# Author:
#   mottum

moment = require 'moment'

module.exports = (robot) ->

  robot.respond /how many ([^ ]+) until football/i, (msg) ->
    openingDay = moment '2014-09-04T19:00:00-0500'
    time = openingDay.diff moment(), msg.match[1]
    if time > -1
      msg.send "#{time} #{msg.match[1]} until football!"
    else
      msg.send "Football is here! Go Pack go!"

  robot.respond /(?:what's|who's|who is|what is) the best .*\bfootball team/i, (msg) ->
    msg.send "Ummm...that would be the Packers."

  robot.respond /cheer for the packers/i, (msg) ->
    msg.send "Go Pack go! Go Pack go!"
