Move = require("moves/Move")
module.exports = class ThrowMove extends Move
  constructor: (@fighter, options)->
    super
    @triggerableMoves = @triggerableMoves.concat [
    ]
    @nextMove = "idle"

  update: (deltaTime)->
    # Find collisions between grabBox and others
