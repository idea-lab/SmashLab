# Controller for keyboard
Controller = require("controller/Controller")
KeyboardController = module.exports = (options = {})->
  Controller.call(this, options)

  @keysDown = []

  @upKey = options.upKey or 38
  @downKey = options.downKey or 40
  @leftKey = options.leftKey or 37
  @rightKey = options.rightKey or 39
  @attackKey = options.attackKey or 16
  @shieldKey = options.shieldKey or 17

  @handleKeys = [@upKey, @downKey, @leftKey, @rightKey, @attackKey, @shieldKey]

  handleKeyDown = (event)=>
    # Add if it's not in the array already
    # console.log(event.keyCode)
    if event.keyCode in @handleKeys
      @active = true
      if not (event.keyCode in @keysDown)
        @keysDown.push(event.keyCode)
  
  handleKeyUp = (event)=>
    # Remove if it's in the array already
    if event.keyCode in @handleKeys
      if event.keyCode in @keysDown
        @keysDown.splice(@keysDown.indexOf(event.keyCode),1)

  window.addEventListener("keydown", handleKeyDown, false)
  window.addEventListener("keyup", handleKeyUp, false)

KeyboardController:: = Object.create(Controller::)
KeyboardController::constructor = KeyboardController


KeyboardController::update = ()->
  # TODO: Clean up jump, move into Controller
  # Joystick
  @joystick.set(0, 0)
  if @upKey in @keysDown
    @joystick.y++
    @jump = true
  else
    @jump = false
  if @downKey in @keysDown
    @joystick.y--
  if @leftKey in @keysDown
    @joystick.x--
  if @rightKey in @keysDown
    @joystick.x++
  @joystick.normalize()
  
  @attack = if @attackKey in @keysDown then 1 else 0
  @shield = if @shieldKey in @keysDown then 1 else 0
  Controller::update.call(this)
