AerialMove = require("moves/AerialMove")
JumpMove = module.exports = (@fighter, options)->
  AerialMove.apply(this, arguments)
  @nextMove = "fall"
  @canShortHop = false
  return

JumpMove:: = Object.create(AerialMove::)
JumpMove::constructor = JumpMove
JumpMove::trigger = ()->
  AerialMove::trigger.apply(this, arguments)
  # Jump Physics
  @fighter.velocity.y = 4 * @fighter.jumpHeight / @fighter.airTime
  if @fighter.touchingGround
    @canShortHop = true
  else
    @canShortHop = false
    @fighter.jumpRemaining = false
  @fighter.touchingGround = false

JumpMove::update = ()->
  if @canShortHop and @currentTime <= 6 and not @fighter.controller.jump
    # Short hop
    @fighter.velocity.y = 4 * @fighter.shortHopHeight / @fighter.airTime
  AerialMove::update.apply(this, arguments)
