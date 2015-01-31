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
#   hubot review <number> - Shows the review information and bug information (if it exists)
#
# Author:
#   dhwang

Q = require 'q'
swarm = require './lib/swarm'
bugs = require './lib/bugs'

# result = distinctRequest ['review #321', 'change 123', 'changelist #123']
# result = { 'changes': [123], 'reviews': [321] }
distinctRequest = (msg, candidates) ->
  distinct = {
    changes: []
    reviews: []
  }
  notDistinct = {}
  for candidate in candidates
    request = candidate.split /[\ #]+/

    task = request[0]
    id = request[1]

    if notDistinct[id]
      continue
    else
      notDistinct[id] = true
      if task is 'change' or task is 'changelist'
        distinct.changes.push id
      else if task is 'review'
        distinct.reviews.push id
  return distinct

module.exports = (robot) ->
  robot.hear /(changelist|change|review) #?(\d+)/ig, (msg) ->
    requests = distinctRequest msg, msg.match
    for change in requests.changes
      swarm.isValid(swarm.getChangeLink change)
        .then(
          (valid) -> msg.send swarm.getChangeLink(change)
          (err) -> msg.send err
      )
    for review in requests.reviews
      link = swarm.getReviewLink review
      Q.all([swarm.isValid(link), swarm.getBug(review)])
        .spread(
          (valid, bug) ->
            if valid
              msg.send link
              bugs.getTitle(bug).then(
                (title) -> msg.send "#{title} #{bugs.getLink bug}"
              )
          (err) -> msg.send err
        )
        .done()
