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
#   hubot like score - Asks hubot the like score from forum.bigfix.com
#
# Author:
#   greenb

Q = require 'q'
request = require 'request'

getLikes = (user) ->
  options = {
    url: "https://forum.bigfix.com/users/#{user}.json"
  }

  returnLikes = (res, body) ->
    for stat in JSON.parse(body).user.stats
      if stat.action_type == 2
        return {name: user, count: stat.count}

    return {name: user, count: 0}

  return Q.nfcall(request, options).spread(returnLikes);

module.exports = (robot) ->

  robot.respond /like score(?: (\S+) (?:vs )?(\S+))?/i, (msg) ->
    respond = (u1, u2) ->
      msg.send "#{u1.name}: #{u1.count}, #{u2.name}: #{u2.count}"

    onError = (err) ->
      msg.send "Failed to get likes: #{err.toString()}"

    user1 = msg.match[1] or "dhwang"
    user2 = msg.match[2] or "dexdexdex"

    Q.all([user1, user2].map(getLikes))
      .spread(respond)
      .fail(onError)
      .done();
