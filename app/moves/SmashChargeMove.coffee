GroundAttackMove = require("moves/GroundAttackMove")
Utils = require("Utils")
SmashChargeMove = module.exports = (@fighter, options)->
  GroundAttackMove.apply(this, arguments)
  @duration = 60
  @nextMove = options.name[0..-7] # Remove that charge
  return

SmashChargeMove:: = Object.create(GroundAttackMove::)
SmashChargeMove::constructor = SmashChargeMove
SmashChargeMove::update = ()->
  smashCharge = (@currentTime-1)/(@duration-1)
  GroundAttackMove::update.apply(this, arguments)
  # TODO: Make more efficient
  @fighter.smashCharge = smashCharge
  if not @fighter.controller.attack
    # Released the attack button, so smash now
    @request(@nextMove, 50)
