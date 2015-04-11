Move = require("moves/Move")
Fighter = require("Fighter")
module.exports = class GrabMove extends Move
  constructor: (@fighter, options)->
    super
    @duration = 50
    @triggerableMoves = @triggerableMoves.concat [
      "holdingmove"
    ]
    @nextMove = "idle"

  update: (deltaTime)->
    console.log "IT WORKS"
    # Find collisions between grabBox and others
