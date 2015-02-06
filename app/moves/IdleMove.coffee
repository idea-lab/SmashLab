Controller = require("controller/Controller")
GroundMove = require("moves/GroundMove")
IdleMove = module.exports = (@fighter, options)->
  GroundMove.apply(this, arguments)
  @triggerableMoves = @triggerableMoves.concat [
    "upsmashcharge"
    "downsmashcharge"
    "sidesmashcharge"
    "walk"
    "crouch"
  ]
  return

IdleMove:: = Object.create(GroundMove::)
IdleMove::constructor = IdleMove

# NOTICE: Move triggerring is deferred
