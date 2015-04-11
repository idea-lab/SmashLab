WalkMove = require("moves/WalkMove")
module.exports = class DashMove extends WalkMove
  constructor: (@fighter, options)->
    super
    @triggerableMoves = [
      "dashattack"
      "sidespecial"
      "jump"
      "shield"
    ]

