Move = require("moves/Move")
FallMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 10
  @triggerableMoves = ["jump", "neutral"]
  @movement = Move.FULL_MOVEMENT
  @nextMove = null
  return

FallMove:: = Object.create(Move::)
FallMove::constructor = FallMove
FallMove::update = (deltaTime)->
  nextMove = Move::update.apply(this, arguments)
  if @fighter.touchingGround
    return "land"
  return nextMove
  # Fast falling goes here