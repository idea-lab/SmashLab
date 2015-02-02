# A general controller object to hold controller for a character
Controller = module.exports = ()->
  # The main stick, with directions.
  @joystick = new THREE.Vector2()
  @joystickPrevious = new THREE.Vector2()
  
  # Why not go analog with the buttons?
  @attack = 0
  @attackPrevious = 0
  @special = 0
  @specialPrevious = 0

  @jump = 0
  @jumpPrevious = 0

  # The detected move the player wants to make
  @move = 0

  @suspendedMove = 0
  @suspendCounter = 0

  @active = false


Controller.LEFT = 1
Controller.RIGHT = 2
Controller.UP = 4
Controller.DOWN = 8
Controller.ANY_DIRECTION = Controller.LEFT | Controller.RIGHT | Controller.UP | Controller.DOWN
Controller.TILT = 16
Controller.JUMP = 32
Controller.ATTACK = 64
Controller.SPECIAL = 128
Controller.ANY_BUTTON = Controller.ATTACK | Controller.SPECIAL

# Frames to suspend a move while looking for combos
Controller.SUSPEND_FRAMES = 3

Controller.TILT_DISTANCE_NEEDED = 0.8

# Call this at the end of update() in child classes
Controller::update = ()->
  move = @getJoystickDirection()

  # Detect tilts  
  if @joystick.length() > Controller.TILT_DISTANCE_NEEDED and not @joystickPrevious.length()>Controller.TILT_DISTANCE_NEEDED
    move |= Controller.TILT
  if @jump and not @jumpPrevious
    move |= Controller.JUMP
  if @attack and not @attackPrevious
    move |= Controller.ATTACK
  if @special and not @specialPrevious
    move |= Controller.SPECIAL

  if @suspendCounter > 0
    @move = 0
    @suspendCounter--
    # Update suspended direction, save everything else
    @suspendedMove = (@suspendedMove & ~Controller.ANY_DIRECTION) | move
    if @suspendCounter is 0
      # Trigger the suspended move
      @move = @suspendedMove
  else
    @suspendedMove = 0
    @move = move

  # Copy values to previous variables
  @joystickPrevious.copy(@joystick)
  @attackPrevious = @attack
  @specialPrevious = @special
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