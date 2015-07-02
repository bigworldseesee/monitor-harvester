# watcher.coffee
fs = require 'fs'
events = require 'events'

class FileWatcher extends events.EventEmitter
  constructor: (@filePath, @close_on_change=true)->
  watch: ->   
    watcher = fs.watch @filePath, (event, filename) =>
      if event is 'change'
        watcher.close()
        @emit 'change'

module.exports.FileWatcher = FileWatcher
