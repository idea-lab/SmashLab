# A move for when the fighter is in the air during an attack
Move = require("moves/Move")
module.exports = class AerialAttackMove extends Move
  constructor: (@fighter, options)->
    super
    @blendFrames = 0
    @triggerableMoves = ["ledgegrab"]
    @movement = Move.DI_MOVEMENT
    @nextMove = "fall"

  update: (deltaTime)->
    super
    if @fighter.touchingGround
      @request("land", 100) # Higher priority land
