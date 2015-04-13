Move = require("moves/Move")
Event = require("Event")
module.exports = class ThrowMove extends Move
  constructor: (@fighter, options)->
    super
    @duration = 40
    @nextMove = "idle"
    # DRY up this code, found in PummelMove
    @eventSequence = @eventSequence.concat [
      new Event(
        start: ()=>
          if @fighter.grabbing
            @hitBoxes[0].updateMatrixWorld()
            @fighter.grabbing.takeDamage(@hitBoxes[0], @fighter)
        startTime:@eventSequence[0].startTime
      )
    ]

  trigger: ()->
    super
    if @fighter.grabbing
      @fighter.grabbing.frozen = @duration

