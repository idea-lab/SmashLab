# Dodge!
Move = require("moves/Move")
Event = require("Event")
DodgeMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @movement = Move.NO_MOVEMENT
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
