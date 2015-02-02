# Ledge grab and hang all in one move
Move = require("moves/Move")
LedgeGrabMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 10
  @movement = Move.NO_MOVEMENT
  @triggerableMoves = @triggerableMoves.concat [
    "neutralaerial",
    "downaerial",
    "upaerial",
    "forwardaerial",
    "backaerial",
    "jump",
    "fall"
  ]
  @nextMove = null
  return

LedgeGrabMove:: = Object.create(Move::)
LedgeGrabMove::constructor = LedgeGrabMove
LedgeGrabMove::update = (deltaTime)->
  @fighter.jumpRemaining = true
  @fighter.touchingGround = true
  Move::update.apply(this, arguments)
  # Detect ledge steals
  if @fighter.ledge?
    if @fighter.ledge.fighter isnt @fighter
      @fighter.ledge = null
      @triggerMove("fall", 100)
  else
    @triggerMove("fall", 100)
LedgeGrabMove::trigger = (ledge)->
  Move::trigger.apply(this, arguments)
  @fighter.ledge = ledge
  @fighter.ledge.fighter = @fighter

