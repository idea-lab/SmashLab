# A rapid-fire-able neutral.
Controller = require("controller/Controller")
GroundAttackMove = require("moves/GroundAttackMove")
NeutralMove = module.exports = (@fighter, options)->
  GroundAttackMove.apply(this, arguments)
  return

NeutralMove:: = Object.create(GroundAttackMove::)
NeutralMove::constructor = NeutralMove
NeutralMove::update = (deltaTime)->
  GroundAttackMove::update.apply(this, arguments)
  if @fighter.controller.move & Controller.ATTACK
    # Retrigger again if spamming attack
    @nextMove = @name

NeutralMove::trigger = ()->
  GroundAttackMove::trigger.apply(this, arguments)  
  # Reset the next move
  @nextMove = "idle"
