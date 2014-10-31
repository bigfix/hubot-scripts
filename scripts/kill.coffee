# Description:
#   In which you tell Hubot to kill
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot kill - Tells hubot to kill
#
# Author:
#   greenb

phrases = [
  'I was only programmed to love.'
]

module.exports = (robot) ->
  robot.respond /kill/i, (msg) ->
    msg.send msg.random(phrases)

  robot.respond /love/i, (msg) ->
    msg.send 'I was only programmed to KILL.'
 