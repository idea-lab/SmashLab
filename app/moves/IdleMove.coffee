Controller = require("controller/Controller")
GroundMove = require("moves/GroundMove")
module.exports = class IdleMove extends GroundMove
  constructor: (@fighter, options)->
    super
    @triggerableMoves = @triggerableMoves.concat [
      "upsmashcharge"
      "downsmashcharge"
      "sidesmashcharge"
      "walk"
      "crouch"
    ]

  # NOTICE: Move triggerring is deferred
