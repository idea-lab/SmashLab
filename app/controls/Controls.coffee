# A general controls object to hold controls for a character
Controls = module.exports = ()->
  # The main stick, with directional controls.
  @joystick = new THREE.Vector2()
  @joystickPrevious = new THREE.Vector2()
  
  # A counter containing down a certain number of frames after a joystick is smashed
  @joystickSmashed = 0

  # Why not go analog with the buttons?
  @attack = 0
  @attackPrevious = 0
  @special = 0
  @specialPrevious = 0

  # Jump is a "button"
  @jump = 0
  @jumpPrevious = 0
  @queueJump = false
  # The detected move the player wants to make
  @move = 0



Controls.LEFT = 1
Controls.RIGHT = 2
Controls.UP = 4
Controls.DOWN = 8
Controls.JUMP = 16
Controls.ATTACK = 32
Controls.SMASH = 64
Controls.SPECIAL = 128

Controls.SMASH_FRAMES = 8
Controls.SMASH_DISTANCE_NEEDED = 0.8

# Call this at the end of update() in child classes
Controls::update = ()->
  @move = 0

  # Detect smashes
  if @joystickSmashed > 0
    @joystickSmashed--
  
  if @joystick.length() > Controls.SMASH_DISTANCE_NEEDED and not @joystickPrevious.length()>Controls.SMASH_DISTANCE_NEEDED
    @joystickSmashed = Controls.SMASH_FRAMES
  
  # Detect moves from buttons presses
  if @jump and not @jumpPrevious
    @jumpQueued = true
  
  if @jumpQueued and not @joystickSmashed
    @jumpQueued = false
    @move = Controls.JUMP
  else if @attack and not @attackPrevious
    @move = Controls.ATTACK | @getJoystickDirection()
    if @joystickSmashed > 0
      @move |= Controls.SMASH
  else if @special and not @specialPrevious
    @move = Controls.SPECIAL | @getJoystickDirection()

  # Copy values to previous variables
  @joystickPrevious.copy(@joystick)
  @attackPrevious = @attack
  @specialPrevious = @special
  @jumpPrevious = @jump

Controls::getJoystickDirection = ()->
  # Include dead zone when the time comes
  if @joystick.x == @joystick.y == 0
    return 0
  else if @joystick.x>Math.abs(@joystick.y)
    return Controls.RIGHT
  else if @joystick.x<-Math.abs(@joystick.y)
    return Controls.LEFT
  else if @joystick.y>=Math.abs(@joystick.x)
    return Controls.UP
  else if @joystick.y<=-Math.abs(@joystick.x)
    return Controls.DOWN
  return 0
