Move = require("moves/Move")
HurtMove = module.exports = (@fighter, options)->
  Move.apply(this, arguments)
  @blendFrames = 0
  @triggerableMoves = []
  @movement = Move.DI_MOVEMENT
  @nextMove = "fall"
  return

HurtMove:: = Object.create(Move::)
HurtMove::constructor = HurtMove
HurtMove::update = ()->
  # Can't move until last 40 frames
  if @duration - @currentTime < 40
    @movement = Move.DI_MOVEMENT
  else
    @movement = Move.NO_MOVEMENT
  Move::update.apply(this, arguments)
HurtMove::trigger = (launchSpeed)->
  @duration = launchSpeed * 200
  @movement = Move.NO_MOVEMENT
  Move::trigger.apply(this, arguments)
