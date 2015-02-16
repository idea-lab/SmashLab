# A move for when the fighter is on the ground during an attack
Move = require("moves/Move")
module.exports = class GroundAttackMove extends Move
  constructor: (@fighter, options)->
    super
    @blendFrames = 0
    @triggerableMoves = [
      "fall"
    ]
    @movement = Move.NO_MOVEMENT
    @nextMove = "idle"

  update: (deltaTime)->
    super
    # I don't think we'll even get here:
    if not @fighter.touchingGround
      @request("fall", 100) # Higher priority fall
