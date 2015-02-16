# Dodge!
Event = require("Event")
Move = require("moves/Move")
module.exports = class DodgeMove extends Move
  constructor: (@fighter, options)->
    super
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

  update: ()->
    super
    if not @fighter.touchingGround
      @request("fall", 100) # Higher priority fall
#Mayank position was here, but what was his momentum?