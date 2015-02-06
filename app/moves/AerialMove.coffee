# A move for when the fighter is in the air and ready to attack
Move = require("moves/Move")
AerialMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 10
  @triggerableMoves = @triggerableMoves.concat [
    "neutralaerial"
    "downaerial"
    "upaerial"
    "forwardaerial"
    "backaerial"
    "airdodge"
    "jump"
  ]
  @movement = Move.FULL_MOVEMENT
  @nextMove = null
  return

AerialMove:: = Object.create(Move::)
AerialMove::constructor = AerialMove
AerialMove::update = ()->
  Move::update.apply(this, arguments)
  if @fighter.touchingGround
    @request("land", 100) # Higher priority fall