request = require 'request'
cheerio = require 'cheerio'
Q = require 'q'

module.exports.domain = domain = 'http://bugs.sfolab.ibm.com'

module.exports.getLink = getLink = (bug) -> "#{domain}/bugzilla/show_bug.cgi?id=#{bug}"

module.exports.getTitle = (bug) ->
  defer = Q.defer()
  link = getLink bug
  request.post {url: link, form: {id: bug}}, (err, res, body) ->
    if err
      defer.reject "Failed to query bug status. #{err}"
    else if res.statusCode != 200
      defer.reject "Failed to query bug status. Got status #{res.statuscode}"
    else
      $ = cheerio.load body
      title = $('title').text()

      if title != 'Invalid Bug ID'
        defer.resolve title
      else
        defer.reject 'Invalid bug ID.'
  return defer.promise

module.exports._checkRegex = _checkRegex = /bug #?(\d+)/ig
