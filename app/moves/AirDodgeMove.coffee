# Air Dodge!
Move = require("moves/Move")
Event = require("Event")
AirDodgeMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @movement = Move.DI_MOVEMENT
  @eventSequence = [
    new Event({
      start: @fighter.makeInvulnerable, startTime: 2,
      end: @fighter.makeVulnerable, endTime: 18
    })
  ]
  @nextMove = "fall"
  return

AirDodgeMove:: = Object.create(Move::)
AirDodgeMove::constructor = AirDodgeMove

AirDodgeMove::update = (deltaTime)->
  Move::update.apply(this, arguments)
  if @fighter.touchingGround
    @request("land", 100) # Higher priority land

