# Description:
#   In which Hubot gives you bugzilla information
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot bug <number> - Shows bug summary
#
# Author:
#   greenb, dhwang

bugs = require './lib/bugs'

distinctBugs = (candidates) ->
  distinct = []
  notDistinct = {}
  for candidate in candidates
    bug = candidate.substr candidate.search /\d/
    if notDistinct[bug]
      continue
    else
      notDistinct[bug] = true
      distinct.push bug
  return distinct

module.exports = (robot) ->
  robot.hear bugs._checkRegex, (msg) ->
    for bug in distinctBugs msg.match
      bugs.getTitle(bug)
        .then(
          (title) -> msg.send "#{title} #{bugs.getLink bug}"
          (err) -> msg.send err
        )
