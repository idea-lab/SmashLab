# A move for when the fighter is on the ground and ready to attack
Move = require("moves/Move")
GroundMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @duration = 600
  @blendFrames = 0
  @movement = Move.NO_MOVEMENT
  @nextMove = "idle"
  return

GroundMove:: = Object.create(Move::)
GroundMove::constructor = GroundMove