# A move for when the fighter is on the ground and ready to attack
Move = require("moves/Move")
module.exports = class GroundMove extends Move
  constructor: (@fighter, options)->
    super
    @blendFrames = 10
    @triggerableMoves = @triggerableMoves.concat [
      "neutral"
      "uptilt"
      "downtilt"
      "sidetilt"
      "shield"
      "roll"
      "dodge"
      "jump"
      "dash"
      "upspecial"
      "downspecial"
      "sidespecial"
      "neutralspecial"
      "grab"
    ]
    @movement = Move.FULL_MOVEMENT
    @nextMove = null

  update: ()->
    super
    if not @fighter.touchingGround
      @request("fall", 100) # Higher priority fall
