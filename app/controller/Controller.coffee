# A general controller object to hold controller for a character
Controller = module.exports = (options = {})->
  # The main stick, with directions.
  @joystick = new THREE.Vector2()
  @joystickPrevious = new THREE.Vector2()

  # Why not go analog with the buttons?
  @attack = 0
  @attackPrevious = 0
  @shield = 0
  @shieldPrevious = 0

  @tapJump = options.tapJump or true
  @jump = 0
  @jumpPrevious = 0

  # The detected move the player wants to make
  @move = 0

  @suspendedMove = 0
  @suspendCounter = 0

  @active = false

  # True to interpret double tilt as a "fast" tilt on an analog stick,
  # otherwise, a double tilt can only be made by two tilts.
  @doubleTiltAnalog = options.doubleTiltAnalog or false

  # Counts down frames since last double tilt
  @doubleTiltCounter = 0
  @doubleTiltDirection = 0

# Call this at the end of update() in child classes
Controller::update = (deltaTime)->
  length = @joystick.length()
  @joystick.normalize().multiplyScalar(Math.min(1, length))

  move = @getJoystickDirection()

  if @doubleTiltAnalog
    if @joystick.length() and not @joystickPrevious.length()
      @doubleTiltCounter = Controller.DOUBLE_TILT_ANALOG_FRAMES
      @doubleTiltDirection = (move & Controller.ANY_DIRECTION)
    else if not @joystick.length()
      @doubleTiltCounter = 0

  if @tapJump and @joystick.y > Controller.JUMP_DISTANCE_NEEDED
    @jump = 1
  # Detect tilts  
  if @joystick.length() > Controller.TILT_DISTANCE_NEEDED and not(@joystickPrevious.length() > Controller.TILT_DISTANCE_NEEDED)
    if @doubleTiltCounter > 0 and @doubleTiltDirection is (move & Controller.ANY_DIRECTION)
      move |= Controller.DOUBLE_TILT
    move |= Controller.TILT
    @doubleTiltCounter = Controller.DOUBLE_TILT_FRAMES
    @doubleTiltDirection = (move & Controller.ANY_DIRECTION)
  if @jump and not @jumpPrevious
    move |= Controller.JUMP
  if @attack and not @attackPrevious
    move |= Controller.ATTACK
  if @shield and not @shieldPrevious
    move |= Controller.SHIELD

  if @doubleTiltCounter > 0 
    @doubleTiltCounter = Math.max(0, @doubleTiltCounter - deltaTime)
  else
    @doubleTiltDirection = 0

  if @suspendCounter > 0
    @move = 0
    @suspendCounter = Math.max(0, @suspendCounter - deltaTime)
    # Update suspended direction, save everything else
    @suspendedMove = (@suspendedMove & ~Controller.ANY_DIRECTION) | move
    if @suspendCounter is 0
      # Trigger the suspended move
      @move = @suspendedMove
  else
    @suspendedMove = 0
    @move = move

  if @attack isnt 0 or @shield isnt 0 or @jump isnt 0 or @joystick.x isnt 0 or @joystick.y isnt 0
    @active = true

  # Copy values to previous variables
  @joystickPrevious.copy(@joystick)
  @attackPrevious = @attack
  @shieldPrevious = @shield
  @jumpPrevious = @jump

Controller::getJoystickDirection = ()->
  # Include dead zone when the time comes
  if @joystick.x == @joystick.y == 0
    return 0
  else if @joystick.x>Math.abs(@joystick.y)
    return Controller.RIGHT
  else if @joystick.x<-Math.abs(@joystick.y)
    return Controller.LEFT
  else if @joystick.y>=Math.abs(@joystick.x)
    return Controller.UP
  else if @joystick.y<=-Math.abs(@joystick.x)
    return Controller.DOWN
  return 0

# Suspends a move so that easier combos can be made (smashing especially)
Controller::suspendMove = (move)->
  if not @suspendedMove
    @suspendedMove = move
    @move = 0
    @suspendCounter = Controller.SUSPEND_FRAMES

Controller.LEFT = 1
Controller.RIGHT = 2
Controller.UP = 4
Controller.DOWN = 8
Controller.ANY_DIRECTION = Controller.LEFT | Controller.RIGHT | Controller.UP | Controller.DOWN
Controller.TILT = 16
Controller.DOUBLE_TILT = 32
Controller.JUMP = 64
Controller.ATTACK = 128
Controller.SHIELD = 256
Controller.ANY_BUTTON = Controller.ATTACK | Controller.SHIELD

# Frames to suspend a move while looking for combos
# 3 for keyboard
Controller.SUSPEND_FRAMES = 5

Controller.TILT_DISTANCE_NEEDED = 0.8
Controller.JUMP_DISTANCE_NEEDED = 0.5

# Time to register two tilts
Controller.DOUBLE_TILT_FRAMES = 15
# Time to register a "strong" tilt
Controller.DOUBLE_TILT_ANALOG_FRAMES = 5
