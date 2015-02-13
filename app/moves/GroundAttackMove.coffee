# A move for when the fighter is on the ground during an attack
Move = require("moves/Move")
GroundAttackMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 0
  @triggerableMoves = [
    "fall"
  ]
  @movement = Move.NO_MOVEMENT
  @nextMove = "idle"
  return

GroundAttackMove:: = Object.create(Move::)
GroundAttackMove::constructor = GroundAttackMove
GroundAttackMove::update = (deltaTime)->
  Move::update.apply(this, arguments)
  # I don't think we'll even get here:
  if not @fighter.touchingGround
    @request("fall", 100) # Higher priority fall
