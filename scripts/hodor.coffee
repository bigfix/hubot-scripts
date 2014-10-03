module.exports = (robot) ->
  robot.hear /(hodor)/i, (msg) ->
    msg.send "Hodor"
