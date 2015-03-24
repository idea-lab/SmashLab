# Controller for a gamepad
Controller = require("controller/Controller")
GamepadController = module.exports = (options = {})->
  Controller.call(this, options)
  @doubleTiltAnalog = options.doubleTiltAnalog or true
  @gamepadIndex = options.gamepadIndex

  @horizontalAxis = options.horizontalAxis or 0
  @verticalAxis = options.verticalAxis or 1

  @attackButton = options.attackButton or 0
  @specialButton = options.specialButton or 1
  @shieldButton = options.shieldButton or 5

  @jumpButton = options.jumpButton or 2
  @jumpButton2 = options.jumpButton2 or 3

GamepadController:: = Object.create(Controller::)
GamepadController::constructor = GamepadController

GamepadController::update = ()->
  if @gamepadIndex?
    gamepad = navigator.getGamepads()[@gamepadIndex]
    if gamepad?
      # TODO: This is empty!
      @attack = gamepad.buttons[@attackButton]?.value or 0
      @special = gamepad.buttons[@specialButton]?.value or 0
      @shield = gamepad.buttons[@shieldButton]?.value or 0
      @jump = gamepad.buttons[@jumpButton]?.value or gamepad.buttons[@jumpButton2]?.value or 0
      @joystick.x = deadZone(gamepad.axes[@horizontalAxis] or 0)
      @joystick.y = deadZone(-gamepad.axes[@verticalAxis] or 0)

  # console.log ("#{i}:#{button.value}" for button,i in @gamepad.buttons).join(", ")

  Controller::update.apply(this, arguments)

deadZone = (value)->
  if Math.abs(value) < 0.2
    return 0
  else
    return value