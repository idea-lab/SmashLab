AerialMove = require("moves/AerialMove")
Controller = require("controller/Controller")
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
    # Turn during jump
    if (@fighter.controller.joystick.x < -0.5)
      @fighter.facingRight = false
      console.log(false)
    else if (@fighter.controller.joystick.x > 0.5)
      @fighter.facingRight = true
      console.log(true)
  
  update: ()->
    if @canShortHop and @currentTime <= 8 and not @fighter.controller.jump
      # Short hop
      @fighter.velocity.y = 4 * @fighter.shortHopHeight / @fighter.airTime
    super