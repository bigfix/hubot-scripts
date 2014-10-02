module.exports =
  respond: (pattern, callback) ->
    result = process.argv.join(' ').match pattern
    if result
      callback
        match: result
        
        send: (text) ->
          console.log text

        reply: (text) ->
          console.log 'Human:', text

        emote: (text) ->
          console.log '/hubot', text
