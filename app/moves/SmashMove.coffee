Move = require("moves/Move")
SmashMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 10
  @triggerableMoves = []
  @movement = Move.NO_MOVEMENT
  @nextMove = "idle"
  # 0 if smash is not charged, 1 if smash is fully charged
  @smashCharge = 0
  return

SmashMove:: = Object.create(Move::)
SmashMove::constructor = SmashMove
SmashMove::update = (deltaTime)->
  for box in @activeBoxes
    box.smashCharge = @smashCharge
  return Move::update.apply(this, arguments)

