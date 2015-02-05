GroundMove = require("moves/GroundMove")
IdleMove = module.exports = (@fighter, options)->
  GroundMove.apply(this, arguments)
  @triggerableMoves = @triggerableMoves.concat [
    "upsmashcharge"
    "downsmashcharge"
    "sidesmashcharge"
    "walk"
  ]
  return

IdleMove:: = Object.create(GroundMove::)
IdleMove::constructor = IdleMove

IdleMove::update = ()->
  # Do the walk
  GroundMove::update.apply(this, arguments)
  if @fighter.controller.joystick.x isnt 0 and @fighter.controller.joystickSmashed is 0
    @request("walk", 50)
