GroundAttackMove = require("moves/GroundAttackMove")
SmashMove = module.exports = (@fighter, options)->
  GroundAttackMove.apply(this, arguments)
  @blendFrames = 10
  @movement = GroundAttackMove.NO_MOVEMENT
  # 0 if smash is not charged, 1 if smash is fully charged
  # This is set by the smash charge move
  @smashCharge = 0
  return

SmashMove:: = Object.create(GroundAttackMove::)
SmashMove::constructor = SmashMove
SmashMove::update = (deltaTime)->
  GroundAttackMove::update.apply(this, arguments)
  # Update boxes with the charge
  for box in @activeBoxes
    box.smashCharge = @smashCharge

