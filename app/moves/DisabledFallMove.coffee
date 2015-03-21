# A move for when the fighter is on the ground and ready to attack
Move = require("moves/Move")
module.exports = class DisabledFallMove extends Move
  constructor: (@fighter, options)->
    super
    @blendFrames = 10
    @triggerableMoves = @triggerableMoves.concat [
      "ledgegrab"
    ]
    @movement = Move.DI_MOVEMENT
    @nextMove = null

  update: ()->
    super
    if @fighter.touchingGround
      @request("idle", 100)
