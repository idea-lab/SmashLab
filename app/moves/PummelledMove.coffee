HeldMove = require("moves/HeldMove")
module.exports = class PummelledMove extends HeldMove
  constructor: (@fighter, options)->
    super
    @duration = 40
    @nextMove = "held"
