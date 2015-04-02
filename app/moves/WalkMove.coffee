Controller = require("controller/Controller")
GroundMove = require("moves/GroundMove")
module.exports = class WalkMove extends GroundMove
  update: (deltaTime)->
    # Do the walk
    super(Math.abs(@fighter.controller.joystick.x) * deltaTime)
    if not (@fighter.controller.move & Controller.ANY_DIRECTION) or @fighter.controller.joystick.x is 0
      @request("idle", 50)