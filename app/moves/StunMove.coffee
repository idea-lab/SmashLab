# A move for when the fighter is on the ground and ready to attack
Move = require("moves/Move")
module.exports = class StunMove extends Move
  constructor: (@fighter, options)->
    super
    @duration = 600
    @blendFrames = 0
    @movement = Move.NO_MOVEMENT
    @nextMove = "idle"
