# Dodge!
Move = require("moves/Move")
Event = require("Event")
DodgeMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @movement = Move.NO_MOVEMENT
  @triggerableMoves = [
    "fall"
  ]
  @duration = 20
  @eventSequence = [
    new Event({
      start: @fighter.makeInvulnerable, startTime: 2,
      end: @fighter.makeVulnerable, endTime: 18
    })
  ]
  @nextMove = "idle"
  return

DodgeMove:: = Object.create(Move::)
DodgeMove::constructor = DodgeMove

DodgeMove::update = ()->
  Move::update.apply(this, arguments)
  if not @fighter.touchingGround
    @request("fall", 100) # Higher priority fall
