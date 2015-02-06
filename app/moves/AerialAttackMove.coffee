# A move for when the fighter is in the air during an attack
Move = require("moves/Move")
AerialAttackMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 0
  @triggerableMoves = ["ledgegrab"]
  @movement = Move.DI_MOVEMENT
  @nextMove = "fall"
  return

AerialAttackMove:: = Object.create(Move::)
AerialAttackMove::constructor = AerialAttackMove
AerialAttackMove::update = (deltaTime)->
  Move::update.apply(this, arguments)
  if @fighter.touchingGround
    @request("land", 100) # Higher priority land

