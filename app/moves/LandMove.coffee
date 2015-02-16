GroundMove = require("moves/GroundMove")
module.exports = class LandMove extends GroundMove
  constructor: (@fighter, options)->
    super
    @triggerableMoves = []
    @duration = 8
    @blendFrames = 3
    @nextMove = "idle"