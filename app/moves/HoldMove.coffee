GrabBaseMove = require("moves/GrabBaseMove")
Controller = require("controller/Controller")
module.exports = class HoldMove extends GrabBaseMove
  constructor: (@fighter, options)->
    super
    @blendFrames = 10
    @triggerableMoves = @triggerableMoves.concat [
      "pummel"
      "upthrow"
      "downthrow"
      "forwardthrow"
      "backthrow"
    ]

  update: (deltaTime)->
    if @fighter.controller.move & (Controller.ATTACK | Controller.GRAB)
      @request("pummel", 100)
    if (@fighter.controller.move & Controller.UP)
      @request("upthrow", 100)
    else if (@fighter.controller.move & Controller.DOWN)
      @request("downthrow", 100)
    else if (@fighter.controller.move & (Controller.RIGHT | Controller.LEFT))
      forward = @fighter.facingRight and (@fighter.controller.move & Controller.RIGHT) or
        not @fighter.facingRight and (@fighter.controller.move & Controller.LEFT)
      if forward
        @request("forwardthrow", 100)
      else
        @request("backthrow", 100)
    super