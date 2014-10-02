# Description:
#   Hubot tells you where to eat
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot where should we eat - Tells you where to eat
#
# Author:
#   greenb

phrases = [
  'Let\'s go to {place}!',
  'How about {place}?',
  'It\'s been forever since we\'ve been to {place}.',
  '{place}, obviously.',
  'They love us at {place}.',
  'I\'d kill for some {place}.',
  'First {place} then McNuggets.'
]

places = [
  'Bay Street',
  'Berkeley Bowl',
  'Chile Jalapeño',
  'Doyle Street Cafe',
  'Farley\'s',
  'In-n-out',
  'Public Market',
  'Rubys',
  'Rudys',
  'Smokehouse',
  'The Vault',
  'Triple Rock'
]

module.exports = (robot) ->
  robot.respond /where should we eat\??/i, (msg) ->
    phrase = msg.random phrases
    place = msg.random places
    msg.send phrase.replace('{place}', place)
