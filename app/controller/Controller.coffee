# A general controller object to hold controller for a character
module.exports = class Controller
  constructor: (options = {})->
    # The main stick, with directions.
    @joystick = new THREE.Vector2()
    @joystickPrevious = new THREE.Vector2()

    # Why not go analog with the buttons?
    @attack = 0
    @attackPrevious = 0

    @special = 0
    @specialPrevious = 0

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
  update: (deltaTime)->
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
    if @special and not @specialPrevious
      move |= Controller.SPECIAL
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

    if move isnt 0
      @active = true

    # Copy values to previous variables
    @joystickPrevious.copy(@joystick)
    @attackPrevious = @attack
    @specialPrevious = @special
    @shieldPrevious = @shield
    @jumpPrevious = @jump

  getJoystickDirection: ()->
    # Include dead zone when the time comes
    if @joystick.x == @joystick.y == 0
      return 0
    else if @joystick.y>=Math.abs(@joystick.x)*0.99
      return Controller.UP
    else if @joystick.y<=-Math.abs(@joystick.x)*0.99
      return Controller.DOWN
    else if @joystick.x>0
      return Controller.RIGHT
    else if @joystick.x<0
      return Controller.LEFT
    return 0

  # Suspends a move so that easier combos can be made (smashing especially)
  suspendMove: (move)->
    if not @suspendedMove
      @suspendedMove = move
      @move = 0
      @suspendCounter = Controller.SUSPEND_FRAMES

  @LEFT : 1
  @RIGHT : 2
  @UP : 4
  @DOWN : 8
  @ANY_DIRECTION : @LEFT | @RIGHT | @UP | @DOWN
  @TILT : 16
  @DOUBLE_TILT : 32
  @JUMP : 64
  @ATTACK : 128
  @SPECIAL : 256
  @SHIELD : 512
  @ANY_BUTTON : @ATTACK | @SPECIAL | @SHIELD

  # Frames to suspend a move while looking for combos
  # 3 for keyboard
  @SUSPEND_FRAMES : 5

  @TILT_DISTANCE_NEEDED : 0.8
  @JUMP_DISTANCE_NEEDED : 0.5

  # Time to register two tilts
  @DOUBLE_TILT_FRAMES : 15
  # Time to register a "strong" tilt
  @DOUBLE_TILT_ANALOG_FRAMES : 5
