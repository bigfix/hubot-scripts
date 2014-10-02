# Description:
#   Hubot tells you the saddest thing
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot what is saddest thing - Tells you the saddest thing
#
# Author:
#   greenb

saddest_things = [

  ['The saddest thing is a retarded man who is crying and promising a broken ' +
   'egg that it will still be a chicken someday.',
   'And that they\'ll play together in a field when it gets better.',
   'http://achewood.com/index.php?date=11052001'],

  ['The saddest thing is a little girl who is told by her own mother and ' +
   'father that she will never be pretty.',
   'And then they open the front door, and on the porch is a little white ' +
   'suitcase, with all of her things in it.',
   'http://achewood.com/index.php?date=06022003'],

  ['The saddest thing is an old bag lady, freezing to death in the snow on ' +
   'Christmas Eve, and the last thing she sees is a family in a nice warm ' +
   'diner getting beheaded by the Taliban',
   'http://achewood.com/index.php?date=09052006'],

  ['The saddest thing is when the toilet from an abandoned space station ' +
   'falls back to earth, lands upside-down on a child who was playing alone ' +
   'in the backyard, and smooshes them into the shape of half a hard-boiled ' +
   'egg.',
   '...And when they lift the toilet off the child, two lips at the top of ' +
   'bloody mound say, on their dying breath, "I love you, mommy."',
   'http://achewood.com/index.php?date=07302007']
]

module.exports = (robot) ->
  robot.respond /what is saddest thing/i, (msg) ->
    for line in msg.random saddest_things
      msg.send line
