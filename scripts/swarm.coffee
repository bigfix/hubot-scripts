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
#   hubot changelist <P4 changelist number> - Shows change information
#   hubot change <P4 changelist number> - Shows change information
#   hubot review <swarm changelist number> - Shows the Swarm review information and bug information (if it exists)
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

fetchChange = (msg, change) ->
  swarm.isValid(swarm.getChangeLink change)
    .then(
      (valid) -> msg.send swarm.getChangeLink(change)
      (err) -> msg.send err
  )

fetchBugIfValid = (msg, review) ->
  link = swarm.getReviewLink review
  Q.all([swarm.isValid(link), swarm.getBug(review)])
    .spread(
      (valid, bug) ->
        if valid
          msg.send link
          if bug != 0
            bugs.getTitle(bug).then(
              (title) -> msg.send "#{title} #{bugs.getLink bug}"
            )
      (err) -> msg.send err
    )
    .done()

module.exports = (robot) ->
  robot.hear /(changelist|change|review) #?(\d+)/ig, (msg) ->
    requests = distinctRequest msg, msg.match
    for change in requests.changes
      fetchChange msg, change
    for review in requests.reviews
      fetchBugIfValid msg, review
