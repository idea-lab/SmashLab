GrabBaseMove = require("moves/GrabBaseMove")
Controller = require("controller/Controller")
Event = require("Event")
module.exports = class PummelMove extends GrabBaseMove
  constructor: (@fighter, options)->
    super
    @blendFrames = 10
    @duration = 20
    @nextMove = "hold"
    @eventSequence = @eventSequence.concat [
      new Event(
        start: ()=>
          if @fighter.grabbing
            @fighter.grabbing.takeDamage(@hitBoxes[0], @fighter)
        startTime:@eventSequence[0].startTime
      )
    ]


  update: (deltaTime)->
    if @fighter.controller.move & (Controller.ATTACK | Controller.GRAB)
      # Retrigger again
      @nextMove = @name
    super
    
  trigger: ()->
    super
    # Reset the next move
    @nextMove = "hold"
