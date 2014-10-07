# Description:
#   In which Hubot imitates hodor
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   corrigat

module.exports = (robot) ->
  robot.hear /(hodor)/i, (msg) ->
    msg.send "Hodor"
