# Controller for a gamepad
Controller = require("controller/Controller")
GamepadController = module.exports = (options = {})->
  Controller.call(this, options)
  @doubleTiltAnalog = options.doubleTiltAnalog or true
  @gamepad = options.gamepad

  @horizontalAxis = options.horizontalAxis or 0
  @verticalAxis = options.verticalAxis or 1

  @attackButton = options.attackButton or 1
  @shieldButton = options.shieldButton or 5

  @jumpButton = options.jumpButton or 0

GamepadController:: = Object.create(Controller::)
GamepadController::constructor = GamepadController

GamepadController::update = ()->
  # TODO: This is empty!
  @attack = @gamepad.buttons[@attackButton]?.value or 0
  @shield = @gamepad.buttons[@shieldButton]?.value or 0
  @jump = @gamepad.buttons[@jumpButton]?.value or 0
  @joystick.x = deadZone(@gamepad.axes[@horizontalAxis] or 0)
  @joystick.y = deadZone(-@gamepad.axes[@verticalAxis] or 0)

  # console.log ("#{i}:#{button.value}" for button,i in @gamepad.buttons).join(", ")

  Controller::update.apply(this, arguments)

deadZone = (value)->
  if Math.abs(value) < 0.1
    return 0
  else
    return value