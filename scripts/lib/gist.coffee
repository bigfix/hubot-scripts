# This module creates a new gist on http://gist.sfolab.ibm.com
# It exports a promises interface.
#
# Usage:
# gist = require('gist')
# gist.create(language, contents).then( (url)->
#   // use the returned url
# ).done()

request = require('request')
cheerio = require('cheerio')
Q = require('q')

module.exports = {
  create : (language, contents) ->
    deferred = Q.defer()
    url = 'http://gist.sfolab.ibm.com'
    options = {
      uri    : url + '/create',
      method : 'POST',
      json   : {language: language, contents: contents}
    }
    request options, (err, resp, body) ->
      if err
        deferred.reject err
      else if resp.statusCode != 200
        $ = cheerio.load body
        $('h2').each ->
          deferred.reject $(this).text()
      else
        deferred.resolve url + '/' + body

    return deferred.promise;
}
