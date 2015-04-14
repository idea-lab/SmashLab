# I've been grabbed! I'm stuck
Move = require("moves/Move")
Utils = require("Utils")
tempVector = new THREE.Vector3()
module.exports = class HeldMove extends Move
  @CONTROLLER_ESCAPE_MULTIPLIER: 3
  constructor: (@fighter, options)->
    super
    @lastMove = 0
    @blendFrames = 10
    @triggerableMoves = @triggerableMoves.concat [
      "pummelled"
    ]

  update: (deltaTime)->
    super
    @fighter.grabEscape = Math.max(0, @fighter.grabEscape - deltaTime)
    if @fighter.controller.move isnt @lastMove
      @lastMove = @fighter.controller.move
      @fighter.grabEscape -= HeldMove.CONTROLLER_ESCAPE_MULTIPLIER * deltaTime
    if @fighter.grabEscape is 0 or not @fighter.grabbedBy or @fighter.grabbedBy.grabbing isnt @fighter
      @fighter.grabbedBy = null
      @request("idle", 100)
    else
      @fighter.facingRight = not @fighter.grabbedBy.facingRight
      # Be grabbed
      tempVector.setFromMatrixPosition(@fighter.grabbedBy.grabPoint.matrixWorld)
      @fighter.velocity.copy(@fighter.box.position).multiplyScalar(-1).sub(@fighter.position).add(tempVector).multiplyScalar(0.2)
      @fighter.position.add(@fighter.velocity.multiplyScalar(deltaTime))
      @fighter.velocity.set(0, 0, 0)
  trigger: (grabbedBy)->
    super
    @lastMove = 0
    if grabbedBy?
      @fighter.makeVulnerable()
      @fighter.grabbedBy = grabbedBy
      @fighter.grabEscape = @fighter.damage * 2 + 60
