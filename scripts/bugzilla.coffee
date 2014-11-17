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

  robot.hear /hubot bug #?(\d+)/i, (msg) ->
    bug = msg.match[1]

    params =
      Bugzilla_login: process.env.BUGZILLA_USER
      Bugzilla_password: process.env.BUGZILLA_PASS
      id: bug
      GoAheadAndLogIn: 'Log in'

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

        msg.send title
        msg.send domain + makePath(bug) unless title == 'Invalid Bug ID'
