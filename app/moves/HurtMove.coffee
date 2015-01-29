Move = require("moves/Move")
HurtMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 0
  @triggerableMoves = []
  @movement = Move.DI_MOVEMENT
  @nextMove = "idle"
  return

HurtMove:: = Object.create(Move::)
HurtMove::constructor = HurtMove
HurtMove::update = (deltaTime)->
  return Move::update.apply(this, arguments)
