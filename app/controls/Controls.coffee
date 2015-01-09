#A general controls object to hold controls for a character
module.exports = ()->
  # The main stick, with directional controls.
  @joystick = new THREE.Vector2()
  