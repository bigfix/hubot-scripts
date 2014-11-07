# Description:
#   In which Hubot tells you who is more liked
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot like score - Asks hubot the like score
#
# Author:
#   greenb

Q = require 'q'
request = require 'request'

getLikes = (user) ->
  options = {
    url: "https://forum.bigfix.com/users/#{user}.json"
    strictSSL: false,
  }

  returnLikes = (res, body) ->
    for stat in JSON.parse(body).user.stats
      if stat.action_type == 2
        return stat.count

    throw new Error('no like count in forum response')

  return Q.nfcall(request, options).spread(returnLikes);

module.exports = (robot) ->

  robot.respond /like score/i, (msg) ->
    respond = (dhwang, dexdexdex) ->
      msg.send "dexdexdex: #{dexdexdex}, dhwang: #{dhwang}"

    onError = (err) ->
      msg.send "Failed to get likes: #{err.toString()}"

    Q.all(['dhwang', 'dexdexdex'].map(getLikes))
      .spread(respond)
      .fail(onError)
      .done();
