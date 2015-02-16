Controller = require("controller/Controller")
GroundMove = require("moves/GroundMove")
module.exports = class CrouchMove extends GroundMove
  constructor: (@fighter, options)->
    super
    @triggerableMoves = @triggerableMoves.concat [
      "walk"
      "crawl"
    ]

  update: ()->
    # Do the CrouchMove
    super
    if (@fighter.controller.move & Controller.ANY_DIRECTION)
      if (@fighter.controller.move & Controller.DOWN)
        if @fighter.controller.joystick.x isnt 0
          @request("crawl", 50)
      else if (@fighter.controller.move & (Controller.LEFT | Controller.RIGHT))
        @request("walk", 50)
      else
        @request("idle", 50)
    else
      @request("idle", 50)
