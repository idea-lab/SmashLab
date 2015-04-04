SpecialAttackMove = require("moves/SpecialAttackMove")
tempVec = new THREE.Vector3()
module.exports = class TestRecoveryMove extends SpecialAttackMove
  constructor: (@fighter, options)->
    super
    @duration = 60
    @flightDirection = new THREE.Vector3()
    @nextMove = "disabledfall"

  trigger: ()->
    super
    @flightDirection.set(0, 0, 0)

  update: (deltaTime)->
    super
    if @currentTime >= 40
      if @flightDirection.length() is 0
        @flightDirection.set(@fighter.controller.joystick.x, @fighter.controller.joystick.y, 0).normalize()
        if @flightDirection.length() is 0
          @flightDirection.set(0, 1, 0)
        if @flightDirection.x > 0
          @fighter.facingRight = true
        else if @flightDirection.x < 0
          @fighter.facingRight = false
      tempVec.copy(@flightDirection).multiplyScalar(0.15 * deltaTime)
      @fighter.position.add(tempVec)
      @fighter.velocity.copy(tempVec).multiplyScalar(0.8)
    else
      @fighter.velocity.set(0, 0, 0)