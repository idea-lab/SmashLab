Move = require("moves/Move")
module.exports = class HurtMove extends Move
  constructor: (@fighter, options)->
    super
    @blendFrames = 0
    @triggerableMoves = []
    @movement = Move.DI_MOVEMENT
    @nextMove = "fall"

  update: ()->
    # Can't move until last 40 frames
    if @duration - @currentTime < 40
      @movement = Move.DI_MOVEMENT
    else
      @movement = Move.NO_MOVEMENT
    super

  trigger: (@duration)->
    @movement = Move.NO_MOVEMENT
    super
