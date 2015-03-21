# A move for when the fighter is doing a special attack. Quite special.
Move = require("moves/Move")
module.exports = class SpecialAttackMove extends Move
  constructor: (@fighter, options)->
    super
    @blendFrames = 0
    @triggerableMoves = ["ledgegrab"]
    @movement = Move.NO_MOVEMENT
    @nextMove = "fall"

  update: (deltaTime)->
    super
