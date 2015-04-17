# Description:
#   Hubot tells you bugs information from bugzilla
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

# [123] = distinctBugs ['bug #123', 'bug 123']
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

fetchBug = (msg, bug) ->
  bugs.getTitle(bug)
    .then(
      (title) -> msg.send "#{title} #{bugs.getLink bug}"
      (err) -> msg.send err
    )

module.exports = (robot) ->
  robot.hear bugs.checkRegex, (msg) ->
    for bug in distinctBugs msg.match
      fetchBug msg, bug