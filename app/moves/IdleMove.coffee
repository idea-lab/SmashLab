Move = require("moves/Move")
IdleMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 10
  @triggerableMoves = ["sidesmashcharge", "neutral", "jump"]
  @movement = Move.FULL_MOVEMENT
  return

IdleMove:: = Object.create(Move::)
IdleMove::constructor = IdleMove

IdleMove::update = (deltaTime)->
  nextMove = Move::update.apply(this, arguments)
  # Do the walk
  if @fighter.controller.joystick.x isnt 0
    return "walk"
  else
    return nextMove