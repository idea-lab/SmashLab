AerialMove = require("moves/AerialMove")
module.exports = class JumpMove extends AerialMove
  constructor: (@fighter, options)->
    super
    @nextMove = "fall"
    @canShortHop = false

  trigger: ()->
    super
    # Jump Physics
    @fighter.velocity.y = 4 * @fighter.jumpHeight / @fighter.airTime
    if @fighter.touchingGround
      @canShortHop = true
    else
      @canShortHop = false
      @fighter.jumpRemaining = false
    @fighter.touchingGround = false
  
  update: ()->
    if @canShortHop and @currentTime <= 8 and not @fighter.controller.jump
      # Short hop
      @fighter.velocity.y = 4 * @fighter.shortHopHeight / @fighter.airTime
    super