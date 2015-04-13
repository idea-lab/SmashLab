# Controller for keyboard
Controller = require("controller/Controller")
module.exports = class KeyboardController extends Controller
  constructor: (options = {})->
    super
    @upKey = options.upKey or 38
    @downKey = options.downKey or 40
    @leftKey = options.leftKey or 37
    @rightKey = options.rightKey or 39
    @attackKey = options.attackKey or 16
    @specialKey = options.specialKey or 18
    @shieldKey = options.shieldKey or 17
    @grabKey = options.grabKey or 0

  update: ()->
    # TODO: Clean up jump, move into Controller
    # Joystick
    @joystick.set(0, 0)
    if @upKey in KeyboardController.keysDown
      @joystick.y++
      @jump = 1
    else
      @jump = 0
    if @downKey in KeyboardController.keysDown
      @joystick.y--
    if @leftKey in KeyboardController.keysDown
      @joystick.x--
    if @rightKey in KeyboardController.keysDown
      @joystick.x++
    @joystick.normalize()
    
    @attack = if @attackKey in KeyboardController.keysDown then 1 else 0
    @special = if @specialKey in KeyboardController.keysDown then 1 else 0
    @shield = if @shieldKey in KeyboardController.keysDown then 1 else 0
    @grab = if @grabKey in KeyboardController.keysDown then 1 else 0
    super

  @keysDown: []
  @handleKeyDown: (event)=>
    # Add if it's not in the array already
    #console.log(event.keyCode)
    if not (event.keyCode in KeyboardController.keysDown)
      KeyboardController.keysDown.push(event.keyCode)
    return
  
  @handleKeyUp: (event)=>
    # Remove if it's in the array already
    if event.keyCode in KeyboardController.keysDown
      KeyboardController.keysDown.splice(KeyboardController.keysDown.indexOf(event.keyCode),1)
    return

window.addEventListener("keydown", KeyboardController.handleKeyDown, false)
window.addEventListener("keyup", KeyboardController.handleKeyUp, false)
