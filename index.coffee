Fs   = require 'fs'
Path = require 'path'

module.exports = (robot) ->
  path = Path.resolve __dirname, 'scripts'
  for file in Fs.readdirSync(path)
    if file.match /(.js|.coffee)$/
      console.log "Loading #{path}/#{file}"
      robot.loadFile path, file
