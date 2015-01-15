# A general controls object to hold controls for a character
module.exports = ()->
  # The main stick, with directional controls.
  @joystick = new THREE.Vector2()
  
  # A boolean set to true if the player wants to jump
  @jump = false