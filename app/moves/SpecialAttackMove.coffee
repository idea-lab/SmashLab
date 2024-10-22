# A move for when the fighter is doing a special attack. Quite special.
Move = require("moves/Move")
module.exports = class SpecialAttackMove extends Move
  constructor: (@fighter, options)->
    super
    @triggerableMoves = ["ledgegrab"]
    @nextMove = "fall"

  update: (deltaTime)->
    super
    @fighter.velocity.y = Math.max(@fighter.velocity.y, -0.002*@currentTime)
