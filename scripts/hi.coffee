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

module.exports = (robot) ->
  robot.hear /^(hi|hello),?\s+hubot$/i, (msg) ->
    msg.send "Hello, #{msg.envelope.user.name}.";
