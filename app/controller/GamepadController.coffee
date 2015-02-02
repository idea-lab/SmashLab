# Controller for a gamepad
Controller = require("controller/Controller")
GamepadController = module.exports = (options = {})->
  Controller.call(this, options)
  @gamepad = options.gamepad

GamepadController:: = Object.create(Controller::)
GamepadController::constructor = GamepadController

GamepadController::update = ()->
  # TODO: This is empty!
  Controller::update.call(this)
