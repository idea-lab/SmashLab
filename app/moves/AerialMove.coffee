# A move for when the fighter is in the air and ready to attack
Move = require("moves/Move")
AerialMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 10
  @triggerableMoves = @triggerableMoves.concat [
    "neutralaerial", 
    "downaerial",
    "jump"
  ]
  @movement = Move.FULL_MOVEMENT
  @nextMove = null
  return

AerialMove:: = Object.create(Move::)
AerialMove::constructor = AerialMove
AerialMove::update = (deltaTime)->
  Move::update.apply(this, arguments)
  if @fighter.touchingGround
    @triggerMove("land", 100) # Higher priority fall