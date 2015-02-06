GroundMove = require("moves/GroundMove")
DashMove = module.exports = (@fighter, options)->
  GroundMove.apply(this, arguments)
  @triggerableMoves = [
    "dashattack"
    "jump"
    "shield"
  ]
  return

DashMove:: = Object.create(GroundMove::)
DashMove::constructor = DashMove
DashMove::update = (deltaTime)->
  # Do the walk
  GroundMove::update.apply(this, arguments)
  if @fighter.controller.joystick.x is 0
    @request("idle", 50)