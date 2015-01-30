# Description:
#   Hubot tells you changelist information from swarm
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot changelist <number> - Shows change information
#   hubot change <number> - Shows change information
#   hubot review <number> - Shows the review information
#
# Author:
#   dhwang

module.exports = (robot) ->

  swarm = 'http://swarm.sfolab.ibm.com'
  makeChangePath = (change) ->
    '/changes/' + change
  makeReviewPath = (change) ->
    '/reviews/' + change

  fetchInfo = (msg, path) ->
    msg.http(swarm)
      .path(path)
      .get() (err, res, body) ->
        if err
          msg.send 'Failed to query swarm information. ' + err
          return

        switch res.statusCode
          when 200 then break
          when 404 then msg.send 'Invalid changelist number.'; return
          else msg.send 'Failed to query swarm information. Got status ' + res.statusCode; return

        msg.send "#{swarm}#{path}"

  robot.hear /(changelist|change|review) #?(\d+)/ig, (msg) ->
    notUniq = {}
    for c in msg.match
      request = c.split /[\ #]+/
      
      task = request[0]
      change = request[1]

      if notUniq[change]
        continue
      notUniq[change] = true

      if task is 'review'
        fetchInfo msg, makeReviewPath change
      else if task is 'change' or task is 'changelist'
        fetchInfo msg, makeChangePath change
