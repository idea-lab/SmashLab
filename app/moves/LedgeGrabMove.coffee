# Ledge grab and hang all in one move
Event = require("Event")
Move = require("moves/Move")
module.exports = class LedgeGrabMove extends Move
  constructor: (@fighter, options)->
    super
    @blendFrames = 10
    @movement = Move.NO_MOVEMENT
    @triggerableMoves = @triggerableMoves.concat [
      "jump"
      "fall"
    ]
    @triggerableMovesBackup = @triggerableMoves
    @eventSequence = [
      new Event({
        start: @fighter.makeInvulnerable, startTime: 0,
        end: @fighter.makeVulnerable, endTime: 60
      })
      # Disable event triggerring while invincible
      new Event({
        start: ()=>
          @triggerableMoves = []
        , startTime: 0,
        end: ()=>
          @triggerableMoves = @triggerableMovesBackup
        , endTime: 15
      })
    ]
    @duration = 300
    @nextMove = "fall"

  update: ()->
    @fighter.jumpRemaining = true
    @fighter.touchingGround = true
    super
    # Detect ledge steals
    if @fighter.ledge?
      if @fighter.ledge.fighter isnt @fighter
        @fighter.ledge = null
        @request("fall", 100)
    else
      @request("fall", 100)

  trigger: (ledge)->
    super
    @fighter.ledge = ledge
    @fighter.ledge.fighter = @fighter

