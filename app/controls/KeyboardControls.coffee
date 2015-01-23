# Controls for keyboard
Controls = require("controls/Controls")
KeyboardControls = module.exports = (keymap = {})->
  Controls.call(this)
  
  @keysDown = []
  @justJumped = false

  @upKey = keymap.upKey or 38
  @downKey = keymap.downKey or 40
  @leftKey = keymap.leftKey or 37
  @rightKey = keymap.rightKey or 39
  @attackKey = keymap.attackKey or 16
  @specialKey = keymap.specialKey or 17

  handleKeyDown = (event)=>
    # Add if it's not in the array already
    if not (event.keyCode in @keysDown)
      @keysDown.push(event.keyCode)
      # console.log(event.keyCode)
  
  handleKeyUp = (event)=>
    # Remove if it's in the array already
    if event.keyCode in @keysDown
      @keysDown.splice(@keysDown.indexOf(event.keyCode),1)

  window.addEventListener("keydown", handleKeyDown, false)
  window.addEventListener("keyup", handleKeyUp, false)

KeyboardControls:: = Object.create(Controls::)
KeyboardControls::constructor = KeyboardControls


KeyboardControls::update = ()->
  # TODO: Clean up jump, move into Controls
  # Joystick
  @jump = false
  @joystick.set(0, 0)
  if @upKey in @keysDown
    @joystick.y++
    if not @justJumped
      @jump = true
      @justJumped = true
  else
    @justJumped = false
  if @downKey in @keysDown
    @joystick.y--
  if @leftKey in @keysDown
    @joystick.x--
  if @rightKey in @keysDown
    @joystick.x++
  @joystick.normalize()
  
  @attack = if @attackKey in @keysDown then 1 else 0
  @special = if @specialKey in @keysDown then 1 else 0
  Controls::update.call(this)
