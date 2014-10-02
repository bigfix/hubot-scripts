# Description:
#   Hubot tells you information about builds, versions, and releases
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot which release was {version}? - Tells you the codename and patch level for a given version string.
#   hubot which version was {codename + patch}? - Tells you the version number for a given codename and patch level.
#   hubot what were all the {codename} releases? - Tells you all of the patch releases for a given codename.
#   hubot what is the latest {codename or version} release? - Tells you the most recent release for a given codename or version.
#
# Author:
#   mottum

request = require("request")
cheerio = require("cheerio")

baseHref = "http://builds.sfolab.ibm.com"

forEachBuild = (success, error) ->
  request baseHref + "/Releases/", (err, resp, body) ->
    if err
      error err
    else
      $ = cheerio.load(body)
      $("a").each ->
        match = /([0-9\.]+)\s*-\s*(.*)/.exec($(this).text())
        if match
          success match[1], match[2], baseHref + $(this).attr("href")

codename = (build) ->
  result = build.match /^(\S+)/
  return result[1].toUpperCase()

patchNumber = (build) ->
  result = build.match /patch +#? *(\d+)/i
  return if result then result[1] else null

latestRelease = (msg, query) ->
  responded = false
  forEachBuild ((version, name, link) ->
    if !responded && (codename(name) == codename(query) || version.match(new RegExp("^" + query)))
      msg.send name + " - " + version + " : " + link
      responded = true
  ), (err) ->
    msg.send "Sorry, something went wrong. " + err

module.exports = (robot) ->
  robot.respond /(?:which|what) (?:release|patch|version|build) (?:is|was) ([^\?]+)\??/i, (msg) ->
    query = msg.match[1]
    forEachBuild ((version, name, link) ->
      if version.match new RegExp("^" + query)
        msg.send version + " was " + name + " : " + link
      else if codename(query) == codename(name) && patchNumber(query) == patchNumber(name)
        msg.send name + " was " + version + " : " + link
    ), (err) ->
      msg.send "Sorry, something went wrong. " + err

  robot.respond /(?:which|what) (?:were|are) all the ([a-z]+) (?:releases|builds|versions|patches)\??/i, (msg) ->
    desiredBuild = msg.match[1]
    forEachBuild ((version, name, link) ->
      if codename(name) == codename(desiredBuild)
        msg.send name + " - " + version + " : " + link
    ), (err) ->
      msg.send "Sorry, something went wrong. " + err

  robot.respond /(?:which|what) is the (?:latest|most recent) (?:release|patch|version|build) of ([^\?]+)\??/i, (msg) ->
    latestRelease msg, msg.match[1]

  robot.respond /(?:which|what) is the (?:latest|most recent) (.*) (?:release|patch|version|build)\??/i, (msg) ->
    latestRelease msg, msg.match[1]
