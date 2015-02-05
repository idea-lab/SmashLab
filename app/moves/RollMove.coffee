# Rolling!
Move = require("moves/Move")
Fighter = require("Fighter")
Event = require("Event")
RollMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @movement = Move.NO_MOVEMENT
  @eventSequence = [
    new Event({
      start: @fighter.makeInvulnerable, startTime: 2,
      end: @fighter.makeVulnerable, endTime: 18
    })
  ]
  @nextMove = "idle"
  return

RollMove:: = Object.create(Move::)
RollMove::constructor = RollMove
RollMove::update = ()->
  if @currentTime < 10
    @fighter.velocity.x = (if @fighter.facingRight then -1 else 1) * Fighter.ROLL_VELOCITY
  Move::update.apply(this, arguments)

