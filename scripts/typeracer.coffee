# Description:
#   Challenges anyone to typeracers
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
#   dexdexdex

module.exports = (robot) ->
  robot.hear /(typeracer)/i, (msg) ->
    msg.send "http://play.typeracer.com/?rt=trgnawhleinad";

  robot.hear /(time to duel)/i, (msg) ->
    msg.send "http://play.typeracer.com/?rt=trgnawhleinad"
