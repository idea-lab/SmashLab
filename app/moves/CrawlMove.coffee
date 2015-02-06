Controller = require("controller/Controller")
GroundMove = require("moves/GroundMove")
CrawlMove = module.exports = (@fighter, options)->
  GroundMove.apply(this, arguments)
  @triggerableMoves = @triggerableMoves.concat [
    "walk"
    "crouch"
  ]
  return

CrawlMove:: = Object.create(GroundMove::)
CrawlMove::constructor = CrawlMove
CrawlMove::update = (deltaTime)->
  # Do the crawl
  GroundMove::update.apply(this, arguments)
  if (@fighter.controller.move & Controller.ANY_DIRECTION)
    if (@fighter.controller.move & Controller.DOWN)
      if @fighter.controller.joystick.x is 0
        @request("crouch", 50)
    else if (@fighter.controller.move & (Controller.LEFT | Controller.RIGHT))
      @request("walk", 50)
    else
      @request("idle", 50)
  else
    @request("idle", 50)