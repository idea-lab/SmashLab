# A move for when the fighter is on the ground and ready to attack
Move = require("moves/Move")
GroundMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 10
  @triggerableMoves = @triggerableMoves.concat [
    "neutral", 
    "uptilt",
    "downtilt",
    "sidetilt",
    "upsmashcharge", 
    "downsmashcharge", 
    "sidesmashcharge", 
    "jump"
  ]
  @movement = Move.FULL_MOVEMENT
  @nextMove = null
  return

GroundMove:: = Object.create(Move::)
GroundMove::constructor = GroundMove
GroundMove::update = (deltaTime)->
  Move::update.apply(this, arguments)
  if not @fighter.touchingGround
    @triggerMove("fall", 100) # Higher priority fall