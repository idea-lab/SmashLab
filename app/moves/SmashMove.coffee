GroundAttackMove = require("moves/GroundAttackMove")
module.exports = class SmashMove extends GroundAttackMove
  constructor: (@fighter, options)->
    super
    @blendFrames = 5
