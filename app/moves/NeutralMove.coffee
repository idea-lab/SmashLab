# A rapid-fire-able neutral.
Controller = require("controller/Controller")
GroundAttackMove = require("moves/GroundAttackMove")
module.exports = class NeutralMove extends GroundAttackMove
  update: ()->
    super
    if @fighter.controller.move & Controller.ATTACK
      # Retrigger again if spamming attack
      @nextMove = @name

  trigger: ()->
    super
    # Reset the next move
    @nextMove = "idle"
