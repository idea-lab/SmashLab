GroundMove = require("moves/GroundMove")
LandMove = module.exports = (@fighter, options)->
  GroundMove.apply(this, arguments)
  @triggerableMoves = []
  @duration = 8
  @blendFrames = 3
  @nextMove = "idle"
  return

LandMove:: = Object.create(GroundMove::)
LandMove::constructor = LandMove
LandMove::update = (deltaTime)->
  GroundMove::update.apply(this, arguments)
