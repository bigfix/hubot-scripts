request = require 'request'
Q = require 'q'
bugs = require './bugs'

module.exports.domain = domain = 'http://swarm.sfolab.ibm.com'

module.exports.getChangeLink = getChangeLink = (change) -> "#{domain}/changes/#{change}"
module.exports.getReviewLink = getReviewLink = (change) -> "#{domain}/reviews/#{change}"
module.exports.getReviewAPILink = getReviewAPILink = (change) -> "#{domain}/api/v1/reviews/#{change}"

module.exports.isValid = (link) ->
  defer = Q.defer()
  request.get link, (err, res, body) ->
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
  request.get getReviewAPILink(change), (err, res, body) ->
    if res.statusCode == 200
      parsed = JSON.parse(body)
      description = parsed.review.description
      candidates = description.match bugs.checkRegex
      bug = candidates[0].substr candidates[0].search /\d/
      defer.resolve bug
  return defer.promise

module.exports.checkRegex = checkRegex = /(changelist|change|review) #?(\d+)/ig
