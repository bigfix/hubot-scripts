# Description:
#   Hubot tells you when the Emery-go-round can pick you up
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot when is the emery-go-round coming? - Tells you when the Emery-go-round bus will be at Hollis and 62nd.
#   hubot remind me to leave for the bus in <n> minutes - Hubot will remind you to leave in time to catch the next available bus.
#
# Author:
#   mottum

request   = require 'request'
xml2js    = require 'xml2js'
pluralize = require 'pluralize'

arrivalString = (arrivals) ->
  arrivals = arrivals.map (a) -> a.minutes
  arrivals = arrivals[0...-1].concat(['and ' + arrivals[arrivals.length - 1]]) unless arrivals.length < 2
  arrivals.join(if arrivals.length > 2 then ', ' else ' ')

fetchPredictions = (callback) ->
  hollisStop = 'http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=emery&stopId=5320'
  request hollisStop, (err, resp, body) ->
    if err
      console.error 'Error fetching from NextBus:', err
    else
      parser = new xml2js.Parser()
      parser.parseString body, (err, result) ->
        if err
          console.error 'Error parsing response XML:', err
        else
          if result.body.predictions[0].direction
            callback result.body.predictions[0].direction[0].prediction.map (p) -> p['$']
          else
            callback []

apology = ->
  "I'm sorry, there don't seem to be any Emery-go-round arrivals coming up. http://www.nextbus.com/#!/emery/Hollis/hollis_inbound/ho64_i"

module.exports = (robot) ->
  robot.respond /(when|what time).*(emery[- ]go[- ]round|bus|next bus).*\?/i, (msg) ->
    fetchPredictions (arrivals) ->
      if arrivals.length == 0
        msg.send apology()
        return
      
      msg.send 'The Emery-go-round bus will arrive at Hollis and 63rd in ' + arrivalString(arrivals) + ' minutes. ' + 'http://www.nextbus.com/#!/emery/Hollis/hollis_inbound/ho64_i'

  robot.respond /remind me to (leave for|catch) the (emery[- ]go[- ]round|bus)( (after|in) (\d+) minutes)?/i, (msg) ->
    walkingMinutes = 10
    delay = if msg.match[3] then parseInt msg.match[5] else 0
    fetchPredictions (predictions) ->
      arrivals = (p for p in predictions when p.minutes > delay + walkingMinutes)

      if arrivals.length == 0
        msg.reply apology()
        return

      nextArrival = arrivals[0]
      msg.reply 'The Emery-go-round bus will arrive in ' + arrivalString(arrivals) + " minutes. I'll remind you to leave in " + pluralize('minute', nextArrival.minutes - walkingMinutes, true) + " so you won't be late."

      setTimeout (->
        msg.reply 'Time to leave to catch the Emery-go-round! You have ' + pluralize('minute', walkingMinutes, true) + ' to get to Hollis and 63rd. Gogogo!!'
      ), (nextArrival.minutes - walkingMinutes) * 60 * 1000
