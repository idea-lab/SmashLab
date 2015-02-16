Controller = require("controller/Controller")
GroundMove = require("moves/GroundMove")
module.exports = class CrawlMove extends GroundMove
  constructor: (@fighter, options)->
    super
    @triggerableMoves = @triggerableMoves.concat [
      "walk"
      "crouch"
    ]

  update: (deltaTime)->
    # Do the crawl
    super
    if (@fighter.controller.move & Controller.ANY_DIRECTION)
      if (@fighter.controller.move & Controller.DOWN)
        if @fighter.controller.joystick.x is 0
          @request("crouch", 50)
      else if (@fighter.controller.move & (Controller.LEFT | Controller.RIGHT))
        @request("walk", 50)
      else
        @request("idle", 50)
    else
      @request("idle", 50)