AerialMove = require("moves/AerialMove")
FallMove = module.exports = (@fighter, options)->
  AerialMove.apply(this, arguments)
  @triggerableMoves = @triggerableMoves.concat [
    "jump"
    "ledgegrab"
  ]
  return

FallMove:: = Object.create(AerialMove::)
FallMove::constructor = FallMove
FallMove::update = (deltaTime)->
  AerialMove::update.apply(this, arguments)
  # Fast falling goes here