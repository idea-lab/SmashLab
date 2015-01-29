Move = require("moves/Move")
LandMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 3
  @triggerableMoves = []
  @movement = Move.FULL_MOVEMENT
  @nextMove = "idle"
  return

LandMove:: = Object.create(Move::)
LandMove::constructor = LandMove
LandMove::update = (deltaTime)->
  return Move::update.apply(this, arguments)
