GroundAttackMove = require("moves/GroundAttackMove")
DashAttackMove = module.exports = (@fighter, options)->
  GroundAttackMove.apply(this, arguments)
  @blendFrames = 10
  @allowAnimatedMovement = true
  return

DashAttackMove:: = Object.create(GroundAttackMove::)
DashAttackMove::constructor = DashAttackMove