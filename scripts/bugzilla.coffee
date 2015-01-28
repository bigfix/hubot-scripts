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
#   greenb

QS      = require 'querystring'
Cheerio = require 'cheerio'

module.exports = (robot) ->

  domain = 'http://bugs.sfolab.ibm.com'
  makePath = (bug) ->
    '/bugzilla/show_bug.cgi?id=' + bug

  fetchBug = (msg, bug) ->
    params =
      id: bug

    msg.http(domain)
      .path(makePath(bug))
      .header('Content-Type', 'application/x-www-form-urlencoded')
      .post(QS.stringify(params)) (err, res, body) ->
        if err
          msg.send 'Failed to query bug status. ' + err
          return

        if res.statusCode != 200
          msg.send 'Failed to query bug status. Got status ' + res.statusCode
          return

        $ = Cheerio.load body
        title = $('title').text()

        if title != 'Invalid Bug ID'
          msg.send "#{title} #{domain}#{makePath(bug)}"

  robot.hear /bug #?(\d+)/ig, (msg) ->
    notUniq = {}
    for b in msg.match
      bug = b.substr b.search /\d/
      if notUniq[bug]
        continue
      notUniq[bug] = true

      fetchBug msg, bug
