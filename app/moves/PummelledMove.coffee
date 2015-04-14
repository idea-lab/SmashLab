HeldMove = require("moves/HeldMove")
module.exports = class PummelledMove extends HeldMove
  constructor: (@fighter, options)->
    super
    @duration = 10
    @blendFrames = 0
    @nextMove = "held"
