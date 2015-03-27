# Rolling!
Event = require("Event")
Fighter = require("Fighter")
Move = require("moves/Move")
module.exports = class RollMove extends Move
  constructor: (@fighter, options)->
    super
    @movement = Move.NO_MOVEMENT
    @allowAnimatedMovement = true
    @eventSequence = [
      new Event({
        start: @fighter.startDodge, startTime: 2,
        end: @fighter.endDodge, endTime: 18
      })
    ]
    @nextMove = "idle"
    @preventFall = true
