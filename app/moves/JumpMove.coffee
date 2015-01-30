AerialMove = require("moves/AerialMove")
JumpMove = module.exports = (@fighter, options)->
  AerialMove.apply(this, arguments)
  @nextMove = "fall"
  return

JumpMove:: = Object.create(AerialMove::)
JumpMove::constructor = JumpMove
JumpMove::update = (deltaTime)->
  AerialMove::update.apply(this, arguments)
