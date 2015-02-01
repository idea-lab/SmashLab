GroundAttackMove = require("moves/GroundAttackMove")
SmashMove = module.exports = (@fighter, options)->
  GroundAttackMove.apply(this, arguments)
  @blendFrames = 5
  return

SmashMove:: = Object.create(GroundAttackMove::)
SmashMove::constructor = SmashMove
SmashMove::update = (deltaTime)->
  GroundAttackMove::update.apply(this, arguments)


