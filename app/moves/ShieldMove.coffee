# A move for when the fighter is on the ground and ready to attack
Event = require("Event")
Move = require("moves/Move")
module.exports = class ShieldMove extends Move
  constructor: (@fighter, options)->
    super
    @blendFrames = 10
    @triggerableMoves = @triggerableMoves.concat [
      "idle"
      "dodge"
      "roll"
      "fall"
      "jump"
    ]
    @eventSequence = [
      new Event({
        start: @fighter.activateShield
        startTime: 0
        end: @fighter.deactivateShield
        endTime: Infinity
      })
    ]
    @movement = Move.NO_MOVEMENT
    @nextMove = null

  update: ()->
    super
    if @fighter.controller.shield is 0 and @fighter.controller.grab is 0
      @request("idle", 50)
    if not @fighter.touchingGround
      @request("fall", 100) # Higher priority fall
