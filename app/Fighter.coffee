# A moving, figting, controllable character
Box = require("Box")
KeyboardControls = require("controls/KeyboardControls")
Controls = require("controls/Controls")
Move = require("Move")
Fighter = module.exports = ()->
  THREE.Object3D.call(this)

  @velocity = new THREE.Vector3()
  @touchingGround = true
  @jumpRemaining = true
  
  # These two parameters control the jump. Very handy!
  @airTime = 60 # in frames
  @jumpHeight = 3 # in world units (meters)
  @maxFallSpeed = 0.2

  # Here are velocities
  @airAccel = 0.015
  @airSpeed = 0.1
  @airFriction = 0.001

  @groundAccel = 0.05
  @groundSpeed = 0.2
  @groundFriction = 0.02

  @box = new Box(size: new THREE.Vector3(.9, 1.86))
  @box.position.set(0, 0.93,0)
  @add(@box)

  @mesh = null
  # TODO: Clean it up!
  loader = new THREE.JSONLoader()
  loader.load("models/Test 3.json", (geometry)=>
    @mesh=new THREE.SkinnedMesh(geometry,new THREE.MeshBasicMaterial({skinning:true}))
    @mesh.sdebug=new THREE.SkeletonHelper(@mesh)
    @parent.add(@mesh.sdebug)
    @add(@mesh)
    @mesh.run = new THREE.Animation(@mesh, @mesh.geometry.animations[3])
    @mesh.idle = new THREE.Animation(@mesh, @mesh.geometry.animations[0])
  )

  @controller = new KeyboardControls()
  
  @move = null
  return

Fighter:: = Object.create(THREE.Object3D::)
Fighter::constructor = Fighter

# Plenty of these methods are explained in Stage.update()
Fighter::applyVelocity = ->
  @position.add(@velocity)
  # Demo respawn (Please remove when the time comes)
  if @position.y < -10
    @position.set(0, 1, 0)
    @velocity.set(0, 0, 0)
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
  #console.log(@controller.move)
  movementEnabled = true
  if @controller.move and not @move
    @move = new Move()
  if @move
    # Complete the current move
    movementEnabled = false
    moveFinished = @move.update()
    if moveFinished
      @move = null

  if movementEnabled
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
  
    # Don't allow the velocity to exceed the maximum speed
    @velocity.x += sign *
      Math.max(0,
      Math.min(Math.abs(@controller.joystick.x*acceleration),
      maxSpeed - sign*@velocity.x))

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
      if @controller.joystick.x>0
        @mesh.rotation.y=Math.PI/2
      else
        @mesh.rotation.y=-Math.PI/2
    else
      @mesh.run.stop() if @mesh.run.isPlaying
      @mesh.idle.play() if not @mesh.idle.isPlaying
