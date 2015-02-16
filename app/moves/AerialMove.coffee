# A move for when the fighter is in the air and ready to attack
Move = require("moves/Move")
module.exports = class AerialMove extends Move
  constructor: (@fighter, options)->
    super
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

  update: ()->
    super
    if @fighter.touchingGround
      @request("land", 100) # Higher priority fall
