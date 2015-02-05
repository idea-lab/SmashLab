GroundMove = require("moves/GroundMove")
WalkMove = module.exports = (@fighter, options)->
  GroundMove.apply(this, arguments)
  return

WalkMove:: = Object.create(GroundMove::)
WalkMove::constructor = WalkMove
WalkMove::update = (deltaTime)->
  # Do the walk
  GroundMove::update.apply(this, arguments)
  if @fighter.controller.joystick.x is 0
    @request("idle", 50)