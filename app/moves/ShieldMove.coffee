# A move for when the fighter is on the ground and ready to attack
Event = require("Event")
Move = require("moves/Move")
ShieldMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 10
  @triggerableMoves = @triggerableMoves.concat [
    "idle"
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
  return

ShieldMove:: = Object.create(Move::)
ShieldMove::constructor = ShieldMove
ShieldMove::update = ()->
  Move::update.apply(this, arguments)
  if @fighter.controller.shield is 0
    @request("idle", 50)