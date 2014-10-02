# Description:
#   Hubot tells you if it's quittin' time
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot is it quittin' time - Tells you if it's quittin' time
#
# Author:
#   mottum

responses = [
  "winners never quit and quitters never win",
  "it's five o'clock somewhere!",
  "let me check my watch...yup, it's beer o'clock",
  "ask your manager",
  "yeah! let's head to Prizefighter!"
]

module.exports = (robot) ->
  robot.respond /.* is it quittin[g']? time\??/i, (msg) ->
    msg.reply msg.random responses
