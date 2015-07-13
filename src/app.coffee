# app.coffee
mongoose = require 'mongoose'
harvester = require './harvester'
watcher = require './watcher'
config = require '../config'

logPath = config.logPath
dbUrl = config.harvesterUrl

mongoose.connect dbUrl

coolFarmer = new harvester.Harvester(logPath)
lazyLandlord = new watcher.FileWatcher(logPath)


# On log path setup, farmer is ready and start to harvest
coolFarmer.on 'ready', -> coolFarmer.harvest()

# When leftover log harvest done, farmer emit 'finish' and land lord start to watch.
# When file change is found, land lord emit 'change' and stops watching.
coolFarmer.on 'finish', -> lazyLandlord.watch()

# Only when 'change' is received, farmer will start to harvest.
lazyLandlord.on 'change', -> coolFarmer.harvest()
