GroundAttackMove = require("moves/GroundAttackMove")
module.exports = class DashAttackMove extends GroundAttackMove
  constructor: (@fighter, options)->
    super
    @blendFrames = 10
    @allowAnimatedMovement = true
    @preventFall = true
