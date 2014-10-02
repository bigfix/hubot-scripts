# Description:
#   In which Hubot will search wiki.sfolab.ibm.com for you
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot search wiki for <query>
#
# Author:
#   mottum

req     = require 'request'
Q       = require 'q'
url     = require 'url'
_       = require 'underscore'
gist    = require './lib/gist'

request = (opts) ->
  deferred = Q.defer()
  req opts, (err, resp, body) ->
    if err? or (resp.statusCode != 200 and resp.statusCode != 201)
      deferred.reject 'HTTP error: (' +
        (if typeof opts == 'string' then 'GET ' + opts else (if opts.method? then opts.method else 'GET') + ' ' + url.format(if opts.uri? then opts.uri else opts.url)) + ') ' +
        (if resp? then resp.statusCode + ': ' else '') +
        (if err? then err + ': ' else '') +
        (if body? then JSON.stringify body else '')
    else
      deferred.resolve {response: resp, body: body}

  deferred.promise

formatGist = (query, hits) ->
  hrefList = ("1. [#{h.fields.title}](#{h.fields.link})" for h in hits).join '\n'
  "Wiki search results for query: #{query}\n----\n#{hrefList}"

module.exports = (robot) ->

  robot.respond /(?:search .*\bwiki|wiki search)(?: for)? (.*)/i, (msg) ->
    searchQuery = msg.match[1]

    request(
      uri: url.parse('http://platdev.sfolab.ibm.com:9200/wiki/page/_search?pretty=true'),
      method: 'GET',
      json:
        fields: ['title', 'link']
        query:
          multi_match:
            query:                searchQuery
            type:                 'best_fields'
            fields:               ['title', 'text']
            tie_breaker:          0.3
            minimum_should_match: '30%'
    )
    .then( (r) ->
      msg.reply h.fields.link for h in r.body.hits.hits.slice 0, 1
      if r.body.hits.hits.length > 0
        gist.create('Markdown', formatGist(searchQuery, r.body.hits.hits))
          .then (gistLink) -> msg.reply "More results: #{gistLink}"
      else
        msg.reply 'No results found'
    )
    .fail( (e) ->
      msg.reply "Error searching for #{searchQuery}: #{e}"
    )
    .done()
