# Description:
#   sob sob sob
#
# Dependencies:
#   None
#
# Commands:
#   hubot sob - sob sob sob
#
# Author:
#   greenb

module.exports = (robot) ->
  robot.respond /sob/i, (msg) ->
    msg.send 'sob sob sob'
