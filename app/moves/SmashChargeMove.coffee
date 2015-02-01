GroundAttackMove = require("moves/GroundAttackMove")
Utils = require("Utils")
SmashChargeMove = module.exports = (@fighter, options)->
  GroundAttackMove.apply(this, arguments)
  @nextMove = options.name[0..-7] # Remove that charge
  return

SmashChargeMove:: = Object.create(GroundAttackMove::)
SmashChargeMove::constructor = SmashChargeMove
SmashChargeMove::update = (deltaTime)->
  smashCharge = (@currentTime-1)/(@duration-1)
  GroundAttackMove::update.apply(this, arguments)
  # TODO: Make more efficient
  @fighter.smashCharge = smashCharge
  if not @fighter.controller.attack
    # Released the attack button, so smash now
    @triggerMove(@nextMove, 50)
