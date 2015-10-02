request = require 'request'
Q = require 'q'
bugs = require './bugs'

module.exports.domain = domain = 'https://swarm.sfolab.ibm.com'

module.exports.getChangeLink = getChangeLink = (change) -> "#{domain}/changes/#{change}"
module.exports.getReviewLink = getReviewLink = (change) -> "#{domain}/reviews/#{change}"
module.exports.getReviewAPILink = getReviewAPILink = (change) -> "#{domain}/api/v1/reviews/#{change}"

module.exports.isValid = (link) ->
  defer = Q.defer()
  
  options = {
    url: link,
    auth: {
      user: process.env.SWARM_USER,
      pass: process.env.SWARM_PASS
    }
  }

  request.get options, (err, res, body) ->
    if err
      defer.reject "Failed to query changelist information. #{err}"
    else if res.statusCode == 404
      defer.reject "Invalid changelist ID."      
    else if res.statusCode != 200
      defer.reject "Failed to query changelist information. Got status #{res.statusCode}"
    else
      defer.resolve true
  return defer.promise

# only works for reviews
module.exports.getBug = (change) ->
  defer = Q.defer()

  options = {
    url: getReviewAPILink(change),
    auth: {
      user: process.env.SWARM_USER,
      pass: process.env.SWARM_PASS
    }
  }
  
  request.get options, (err, res, body) ->
    bug = 0
    if res.statusCode == 200
      parsed = JSON.parse(body)
      description = parsed.review.description
      candidates = description.match bugs.checkRegex
      if candidates
        bug = candidates[0].substr candidates[0].search /\d/
    defer.resolve bug
  return defer.promise

module.exports.checkRegex = checkRegex = /(changelist|change|review) #?(\d+)/ig
