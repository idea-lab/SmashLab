# Controller for a gamepad
Controller = require("controller/Controller")
module.exports = class GamepadController extends Controller
  constructor: (options = {})->
    super
    @doubleTiltAnalog = options.doubleTiltAnalog or true
    @gamepadIndex = options.gamepadIndex

    @horizontalAxis = options.horizontalAxis or 0
    @verticalAxis = options.verticalAxis or 1

    @attackButton = options.attackButton or 0
    @specialButton = options.specialButton or 1
    @shieldButton = options.shieldButton or 5

    @jumpButton = options.jumpButton or 2
    @jumpButton2 = options.jumpButton2 or 3

  update: ()->
    if @gamepadIndex?
      gamepad = navigator.getGamepads()[@gamepadIndex]
      if gamepad?
        if gamepad.id is "USB GamePad (Vendor: 1a34 Product: f705)"
          #Override for my wonky adapter
          @attackButton = 1
          @specialButton = 2
          @jumpButton = 0
          @jumpButton2 = 3
        # TODO: This is empty!
        @attack = gamepad.buttons[@attackButton]?.value or 0
        @special = gamepad.buttons[@specialButton]?.value or 0
        @shield = gamepad.buttons[@shieldButton]?.value or 0
        @jump = gamepad.buttons[@jumpButton]?.value or gamepad.buttons[@jumpButton2]?.value or 0
        @joystick.x = GamepadController.deadZone(gamepad.axes[@horizontalAxis] or 0)
        @joystick.y = GamepadController.deadZone(-gamepad.axes[@verticalAxis] or 0)

    # console.log ("#{i}:#{button.value}" for button,i in @gamepad.buttons).join(", ")

    Controller::update.apply(this, arguments)

  @deadZone: (value)->
    if Math.abs(value) < 0.2
      return 0
    else
      return value