Move = require("moves/Move")
Utils = require("Utils")
SmashChargeMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 0
  @triggerableMoves = []
  @movement = Move.NO_MOVEMENT
  @nextMove = options.name[0..-7] # Remove that charge
  return

SmashChargeMove:: = Object.create(Move::)
SmashChargeMove::constructor = SmashChargeMove
SmashChargeMove::update = (deltaTime)->
  smashCharge = (@currentTime-1)/(@duration-1)
  nextMove = Move::update.apply(this, arguments)
  # TODO: Make more efficient
  Utils.findObjectByName(@fighter.moveset,@nextMove).smashCharge = smashCharge
  if not @fighter.controller.attack
    # Released the attack button, so smash now
    return @nextMove
  return nextMove
