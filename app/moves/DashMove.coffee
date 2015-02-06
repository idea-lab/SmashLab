WalkMove = require("moves/WalkMove")
DashMove = module.exports = (@fighter, options)->
  WalkMove.apply(this, arguments)
  @triggerableMoves = [
    "dashattack"
    "jump"
    "shield"
  ]
  return

DashMove:: = Object.create(WalkMove::)
DashMove::constructor = DashMove
DashMove::update = (deltaTime)->
  # Do the walk
  WalkMove::update.apply(this, arguments)
