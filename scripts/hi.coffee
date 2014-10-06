# Description:
#   In which Hubot says hi
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
#   greenb

moment = require 'moment'

module.exports = (robot) ->
  robot.hear /^(hi|hello),?\s+hubot$/i, (msg) ->
    msg.send "Hello, #{msg.envelope.user.name}";
