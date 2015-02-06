Controller = require("controller/Controller")
GroundMove = require("moves/GroundMove")
CrouchMove = module.exports = (@fighter, options)->
  GroundMove.apply(this, arguments)
  @triggerableMoves = @triggerableMoves.concat [
    "walk"
    "crawl"
  ]
  return

CrouchMove:: = Object.create(GroundMove::)
CrouchMove::constructor = CrouchMove

CrouchMove::update = ()->
  # Do the CrouchMove
  GroundMove::update.apply(this, arguments)
  if (@fighter.controller.move & Controller.ANY_DIRECTION)
    if (@fighter.controller.move & Controller.DOWN)
      if @fighter.controller.joystick.x isnt 0
        @request("crawl", 50)
    else if (@fighter.controller.move & (Controller.LEFT | Controller.RIGHT))
      @request("walk", 50)
    else
      @request("idle", 50)
  else
    @request("idle", 50)
