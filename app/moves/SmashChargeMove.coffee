Utils = require("Utils")
GroundAttackMove = require("moves/GroundAttackMove")
module.exports = class SmashChargeMove extends GroundAttackMove
  constructor: (@fighter, options)->
    super
    @duration = 60
    @nextMove = options.name[0..-7] # Remove that charge

  update: ()->
    smashCharge = (@currentTime-1)/(@duration-1)
    super
    # TODO: Make more efficient
    @fighter.smashCharge = smashCharge
    if not @fighter.controller.attack
      # Released the attack button, so smash now
      @request(@nextMove, 50)
