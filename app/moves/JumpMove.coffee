Move = require("moves/Move")
JumpMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 10
  @triggerableMoves = ["jump", "neutral"]
  @movement = Move.FULL_MOVEMENT
  @nextMove = "fall"
  return

JumpMove:: = Object.create(Move::)
JumpMove::constructor = JumpMove
JumpMove::update = (deltaTime)->
  return Move::update.apply(this, arguments)
