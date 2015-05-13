# Description:
#   Hubot tells you work item information from rtc
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot rtc <number> - Shows rtc summary
#
# Author:
#   greenb

getWorkItem = require './lib/rtc'

user = process.env.RTC_USER
pass = process.env.RTC_PASS
repo = process.env.RTC_REPO

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

fetchSummary = (msg, number) ->
  url = repo + 'resource/itemName/com.ibm.team.workitem.WorkItem/' + number

  getWorkItem(number, user, pass, repo)
    .then(
      (summary) ->
        msg.send "#{summary} #{url}"
      (err) ->
        msg.send err
    )

module.exports = (robot) ->
  robot.hear /rtc #?(\d+)/ig, (msg) ->
    for bug in distinctBugs msg.match
      fetchSummary msg, bug
