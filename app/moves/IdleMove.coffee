GroundMove = require("moves/GroundMove")
IdleMove = module.exports = (@fighter, options)->
  GroundMove.apply(this, arguments)
  @triggerableMoves = @triggerableMoves.concat [
    "walk"
  ]
  return

IdleMove:: = Object.create(GroundMove::)
IdleMove::constructor = IdleMove

IdleMove::update = (deltaTime)->
  # Do the walk
  GroundMove::update.apply(this, arguments)
  if @fighter.controller.joystick.x isnt 0
    @triggerMove("walk", 50)
