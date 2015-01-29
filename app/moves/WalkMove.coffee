Move = require("moves/Move")
WalkMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 10
  @triggerableMoves = ["sidesmashcharge", "neutral", "jump"]
  @movement = Move.FULL_MOVEMENT
  return

WalkMove:: = Object.create(Move::)
WalkMove::constructor = WalkMove
WalkMove::update = (deltaTime)->
  nextMove = Move::update.apply(this, arguments)
  # Do the walk
  if @fighter.controller.joystick.x is 0
    return "idle"
  else
    return nextMove