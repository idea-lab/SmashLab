GroundMove = require("moves/GroundMove")
LandMove = module.exports = (@fighter, options)->
  GroundMove.apply(this, arguments)
  # Perhaps you can't shield upon landing?
  # Be sure to slice to create a new array
  @triggerableMoves = []
  @duration = 8
  @blendFrames = 3
  @nextMove = "idle"
  return

LandMove:: = Object.create(GroundMove::)
LandMove::constructor = LandMove
LandMove::update = (deltaTime)->
  GroundMove::update.apply(this, arguments)
