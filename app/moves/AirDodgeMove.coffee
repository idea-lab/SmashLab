# Air Dodge!
Event = require("Event")
Move = require("moves/Move")
module.exports = class AirDodgeMove extends Move
  constructor: (@fighter, options)->
    super
    @movement = Move.DI_MOVEMENT
    @eventSequence = [
      new Event({
        start: @fighter.makeInvulnerable, startTime: 2,
        end: @fighter.makeVulnerable, endTime: 18
      })
    ]
    @nextMove = "fall"

  update: (deltaTime)->
    super
    if @fighter.touchingGround
      @request("land", 100) # Higher priority land

