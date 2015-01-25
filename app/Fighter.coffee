# A moving, figting, controllable character
Box = require("Box")
KeyboardControls = require("controls/KeyboardControls")
Controls = require("controls/Controls")
Move = require("Move")
Event = require("Event")
Fighter = module.exports = (options = {})->
  THREE.Object3D.call(this)

  @velocity = new THREE.Vector3()
  @touchingGround = true
  @jumpRemaining = true

  # These two parameters control the jump. Very handy!
  @airTime = 60 # in frames
  @jumpHeight = 3 # in world units (meters)
  @maxFallSpeed = 0.12

  # Here are velocities
  @airAccel = 0.01
  @airSpeed = 0.1
  @airFriction = 0.002

  @groundAccel = 0.015
  @groundSpeed = 0.2
  @groundFriction = 0.01

  @diAccel = 0.01
  @diSpeed = 0.05

  @box = new Box(size: new THREE.Vector3(.5, 1.86))
  @box.position.set(0, 0.93,0)
  @add(@box)

  # TODO: Eventually remove this
  @moveBox = new Box(size: new THREE.Vector3(.8, .8), angle:1)
  @moveBox.position.set(.7, 0.9,0)
  @add(@moveBox)
  @coolMove = new Move(this, {
    activeBoxes: [@moveBox]
    eventSequence: [
      new Event({callback:@moveBox.activate, time:5})
      new Event({callback:@moveBox.deactivate, time:15})
    ]
  })

  @mesh = null
  # TODO: Clean it up!
  loader = new THREE.JSONLoader()
  loader.load("models/Test 3.json", (geometry)=>
    @mesh=new THREE.SkinnedMesh(geometry,new THREE.MeshBasicMaterial({skinning:true, color: Math.floor(Math.random()*0xffffff)}))
    @mesh.rotation.y=Math.PI/2
    @mesh.sdebug=new THREE.SkeletonHelper(@mesh)
    @parent.add(@mesh.sdebug)
    @add(@mesh)
    @mesh.run = new THREE.Animation(@mesh, @mesh.geometry.animations[3])
    @mesh.idle = new THREE.Animation(@mesh, @mesh.geometry.animations[0])
  )
  @controller = options.controller or new KeyboardControls()

  @move = null
  @damage = 0

  # True if right, false if left
  @facingRight = true
  return

Fighter:: = Object.create(THREE.Object3D::)
Fighter::constructor = Fighter

# When the fighter is hit by a hit box
Fighter::hurt = (hitbox)->
  @damage += hitbox.damage
  #TODO: turn this into a temp variable
  launchSpeed = (@damage/100*hitbox.knockbackScaling+hitbox.knockback)/60
  velocityToAdd = new THREE.Vector3(Math.cos(hitbox.angle)*launchSpeed,Math.sin(hitbox.angle)*launchSpeed,0)
  # Change velocity based on facing
  velocityToAdd.x *= hitbox.matrixWorld.elements[0]

  @velocity.add(velocityToAdd)
# Plenty of these methods are explained in Stage.update()
Fighter::applyVelocity = ->
  @position.add(@velocity)
  # Demo respawn (Please remove when the time comes)
  if @position.y < -10
    @position.set(0, 1, 0)
    @velocity.set(0, 0, 0)
    @damage = 0
  @updateMatrixWorld()
  @box.updateMatrixWorld()


Fighter::resolveStageCollisions = (stage)->
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


Fighter::update = ->
  @controller.update()
  movementEnabled = true
  if @controller.move and not @move
    @coolMove.reset()
    @move = @coolMove
  if @move
    # Complete the current move
    movementEnabled = false
    newMove = @move.update(1)
    @move = newMove

  # Jump
  if movementEnabled and @jumpRemaining and @controller.jump
    @velocity.y = 4 * @jumpHeight / @airTime
    if not @touchingGround
      @jumpRemaining = false
    @touchingGround = false

  sign = Math.sign(@controller.joystick.x)

  # Lateral Movement
  if movementEnabled or not @touchingGround
    # Even if movement is disabled during a move,
    # still allow DI if in the air.
    maxSpeed = if not movementEnabled then @diSpeed else if @touchingGround then @groundSpeed else @airSpeed
    acceleration = if not movementEnabled then @diAccel+@airFriction else if @touchingGround then @groundAccel+@groundFriction else @airAccel+@airFriction

    # Don't allow the velocity to exceed the maximum speed
    @velocity.x += sign *
      Math.max(0,
      Math.min(Math.abs(@controller.joystick.x*acceleration),
      maxSpeed - sign*@velocity.x))

  # Facing
  if movementEnabled and @touchingGround
    if sign > 0
      @facingRight = true
      @rotation.y = 0
    else if sign < 0
      @facingRight = false
      @rotation.y = Math.PI 

  # Friction
  friction = if @touchingGround then @groundFriction else @airFriction
  @velocity.x = Math.sign(@velocity.x) * Math.max(0, Math.abs(@velocity.x) - friction)

  # Gotta get that gravity
  @velocity.y -= Math.max(0, Math.min(8 * @jumpHeight / @airTime / @airTime, @velocity.y + @maxFallSpeed))

  @updateMesh()

Fighter::updateMesh = ->
  # TODO: Clean it up!
  return if not @mesh
  @mesh.run.resetBlendWeights()
  @mesh.idle.resetBlendWeights()
  @mesh.run.update(1/30)
  @mesh.idle.update(1/60)
  @mesh.sdebug.update()
  if @move
    @mesh.run.stop() if @mesh.run.isPlaying
    @mesh.idle.stop() if @mesh.idle.isPlaying
  else
    if @controller.joystick.x != 0
      @mesh.run.play() if not @mesh.run.isPlaying
      @mesh.idle.stop() if @mesh.idle.isPlaying
    else
      @mesh.run.stop() if @mesh.run.isPlaying
      @mesh.idle.play() if not @mesh.idle.isPlaying
