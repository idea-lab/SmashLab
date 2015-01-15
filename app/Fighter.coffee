# A moving, figting, controllable character
Box = require("Box")
KeyboardControls = require("controls/KeyboardControls")
module.exports = ()->
  THREE.Object3D.call(this)

  @velocity = new THREE.Vector3()
  @touchingGround = true
  @jumpRemaining = true
  
  # These two parameters control the jump. Very handy!
  @airTime = 60 # in frames
  @jumpHeight = 4 # in world units (meters)

  # Here are velocities
  @groundSpeed = 0.2
  @airAccel = 0.015
  @airSpeed = 0.1
  @groundAccel = 0.05
  @groundFriction = 0.03

  @box = new Box(new THREE.Vector3(1, 1.8))
  @box.position.set(0, 0.9,0)
  @add(@box)

  mesh=new THREE.Mesh(new THREE.BoxGeometry(1,1.8, 1),new THREE.MeshNormalMaterial())
  mesh.position.set(0, 0.9, 0)
  @add(mesh)

  @controller = new KeyboardControls()
  return

module.exports:: = Object.create(THREE.Object3D::)
module.exports::constructor = module.exports

# Plenty of these methods are explained in Stage.update()
module.exports::applyVelocity = ->
  @position.add(@velocity)
  # Demo respawn (Please remove when the time comes)
  if @position.y < -10
    @position.set(0, 1, 0)
    @velocity.set(0, 0, 0)
  @updateMatrixWorld()
  @box.updateMatrixWorld()


module.exports::resolveStageCollisions = (stage)->
  @touchingGround = false
  for stageBox in stage.children when stageBox instanceof Box
    if @box.intersects(stageBox)
      #Touching the stage
      resolutionVector = @box.resolveCollision(stageBox)
      @position.add(resolutionVector)
      if resolutionVector.y > 0
        # Just landing. Engage your flaps and reverse your jets
        # because ground control needs to know your heading.
        @touchingGround = true
        @jumpRemaining = true
        if @velocity.y < 0
          @velocity.y = 0
        

module.exports::update = ->
  @controller.update()

  # Jump
  if @jumpRemaining and @controller.jump
    @velocity.y = 4 * @jumpHeight / @airTime
    if not @touchingGround
      @jumpRemaining = false
    @touchingGround = false

  # Lateral Movement
  maxSpeed = if @touchingGround then @groundSpeed else @airSpeed
  acceleration = if @touchingGround then @groundAccel else @airAccel
  sign = Math.sign(@controller.joystick.x)
  @velocity.x += sign *
    Math.max(0,
    Math.min(Math.abs(@controller.joystick.x*acceleration),
    maxSpeed - sign*@velocity.x))
  # Friction
  if @touchingGround
    @velocity.x = Math.sign(@velocity.x) * Math.max(0, Math.abs(@velocity.x) - @groundFriction)

  # Gotta get that gravity
  @velocity.y -= 8 * @jumpHeight / @airTime / @airTime

