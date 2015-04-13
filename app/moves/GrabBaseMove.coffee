# The base grab move that handles breaking out of grabs
Move = require("moves/Move")
module.exports = class GrabBaseMove extends Move
  constructor: (@fighter, options)->
    super
    for box in @hitBoxes
      box.position.copy(@fighter.grabPoint.position)

  update: (deltaTime)->
    super
    if @fighter.grabbing is null or @fighter.grabbing.grabbedBy isnt @fighter
      @request("idle", 100)
