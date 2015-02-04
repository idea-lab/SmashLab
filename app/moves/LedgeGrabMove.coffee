# Ledge grab and hang all in one move
Move = require("moves/Move")
Event = require("Event")
LedgeGrabMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 10
  @movement = Move.NO_MOVEMENT
  @triggerableMoves = @triggerableMoves.concat [
    "neutralaerial"
    "downaerial"
    "upaerial"
    "forwardaerial"
    "backaerial"
    "jump"
    "fall"
  ]
  @triggerableMovesBackup = @triggerableMoves
  @eventSequence = [
    new Event({
      start: @fighter.makeInvulnerable, startTime: 0,
      end: @fighter.makeVulnerable, endTime: 20
    })
    # Disable event triggerring while invincible
    new Event({
      start: ()=>
        @triggerableMoves = []
      , startTime: 0,
      end: ()=>
        @triggerableMoves = @triggerableMovesBackup
      , endTime: 20
    })
  ]
  @nextMove = null
  return

LedgeGrabMove:: = Object.create(Move::)
LedgeGrabMove::constructor = LedgeGrabMove
LedgeGrabMove::update = ()->
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

