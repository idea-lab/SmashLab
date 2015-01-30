Move = require("moves/Move")
HurtMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 0
  @triggerableMoves = []
  @movement = Move.DI_MOVEMENT
  @nextMove = "fall"
  return

HurtMove:: = Object.create(Move::)
HurtMove::constructor = HurtMove
HurtMove::update = (deltaTime)->
  Move::update.apply(this, arguments)
