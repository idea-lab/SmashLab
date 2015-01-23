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

  # A boolean set to true if the player wants to jump
  @jump = false

  # The detected move the player wants to make
  @move = 0



Controls.LEFT = 1
Controls.RIGHT = 2
Controls.UP = 4
Controls.DOWN = 8
Controls.ATTACK = 16
Controls.SMASH = 32
Controls.SPECIAL = 64

Controls.SMASH_FRAMES = 10
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
  if @attack and not @attackPrevious
    @move = Controls.ATTACK | @getJoystickDirection()
    if @joystickSmashed > 0
      @move |= Controls.SMASH
  else if @special and not @specialPrevious
    @move = Controls.SPECIAL | @getJoystickDirection()

  # Copy values to previous variables
  @joystickPrevious.copy(@joystick)
  @attackPrevious = @attack
  @specialPrevious = @special

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
