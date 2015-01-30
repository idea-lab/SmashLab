# A moving, figting, controllable character
Box = require("Box")
Move = require("moves/Move")
Utils = require("Utils")
Controls = require("controls/Controls")
tempVector = new THREE.Vector3()
Fighter = module.exports = (fighterData = {}, @controller)->
  THREE.Object3D.call(this)

  @velocity = new THREE.Vector3()
  @touchingGround = true
  @jumpRemaining = true

  ## Start initializing everything based on the fighter data. ##

  # These two parameters control the jump. Very handy!
  @airTime = fighterData.airTime # in frames
  @jumpHeight = fighterData.jumpHeight # in world units (meters)
  @maxFallSpeed = fighterData.maxFallSpeed

  # Here are velocities
  @airAccel = fighterData.airAccel
  @airSpeed = fighterData.airSpeed
  @airFriction = fighterData.airFriction

  @groundAccel = fighterData.groundAccel
  @groundSpeed = fighterData.groundSpeed
  @groundFriction = fighterData.groundFriction

  @diAccel = 0.002
  @diSpeed = 0.02

  # Hitbox
  @box = new Box(fighterData.box)
  @add(@box)

  # The fighterdata is expected to come with its own JSON. Be sure to load beforehand!
  parsedJSON = THREE.JSONLoader.prototype.parse(Utils.clone(fighterData.modelJSON))
  @mesh=new THREE.SkinnedMesh(parsedJSON.geometry, new THREE.MeshBasicMaterial({skinning:true, color: Math.floor(Math.random()*0xffffff)}))
  @mesh.rotation.y=Math.PI/2
  @add(@mesh)
  @mesh.sdebug=new THREE.SkeletonHelper(@mesh)
  # HAX to the MAX. Please remove this eventually.
  setTimeout ()=>
    @parent.add(@mesh.sdebug)
  , 0
  
  # Set up moves
  @moveset = [
    new (require("moves/IdleMove"))(this, Utils.findObjectByName(fighterData.moves, "idle"))
    new (require("moves/WalkMove"))(this, Utils.findObjectByName(fighterData.moves, "walk"))
    new (require("moves/JumpMove"))(this, Utils.findObjectByName(fighterData.moves, "jump"))
    new (require("moves/FallMove"))(this, Utils.findObjectByName(fighterData.moves, "fall"))
    new (require("moves/LandMove"))(this, Utils.findObjectByName(fighterData.moves, "land"))
    new (require("moves/HurtMove"))(this, Utils.findObjectByName(fighterData.moves, "hurt"))
    new (require("moves/Move"))(this, Utils.findObjectByName(fighterData.moves, "neutral"))
    new (require("moves/SmashChargeMove"))(this, Utils.findObjectByName(fighterData.moves, "sidesmashcharge"))
    new (require("moves/SmashMove"))(this, Utils.findObjectByName(fighterData.moves, "sidesmash"))
  ]

  # Current move
  @move = null

  @damage = 0

  # True if right, false if left
  @facingRight = true

  @respawn()
  return

Fighter:: = Object.create(THREE.Object3D::)
Fighter::constructor = Fighter

# When the fighter is hit by a hit box
Fighter::hurt = (hitbox)->
  smashChargeFactor = 1 + hitbox.smashCharge*.2
  @damage += hitbox.damage * smashChargeFactor

  launchSpeed = smashChargeFactor * (@damage/100*hitbox.knockbackScaling+hitbox.knockback)/60
  velocityToAdd = tempVector.set(Math.cos(hitbox.angle)*launchSpeed,Math.sin(hitbox.angle)*launchSpeed,0)

  # Change velocity based on facing
  velocityToAdd.x *= hitbox.matrixWorld.elements[0]

  # Change facing based on velocity
  @facingRight = hitbox.matrixWorld.elements[0] < 0

  # Gain another jump
  @jumpRemaining = true

  @trigger("hurt")
  @move.duration = launchSpeed*200
  
  @velocity.copy(velocityToAdd)
# Plenty of these methods are explained in Stage.update()
Fighter::applyVelocity = ->
  @position.add(@velocity)
  @updateMatrixWorld()
  @box.updateMatrixWorld()

Fighter::resolveStageCollisions = (stage)->
  @touchingGround = false
  for stageBox in stage.activeBoxes when stageBox instanceof Box
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
  
  #Detect out of bounds
  if not @box.intersects(stage.safebox)
    @respawn()
    @position.set(0, 1, 0)

Fighter::update = ->
  @controller.update()

  # Complete the current move
  @move.update(1)
  # Handle automatic endings of moves
  if @move.triggerNext isnt @move.name
    @trigger(@move.triggerNext)

  # TODO: Triggerables (is this the right place?)
  if "sidesmashcharge" in @move.triggerableMoves and (@controller.move & Controls.SMASH)
    @trigger("sidesmashcharge")
  else if "neutral" in @move.triggerableMoves and (@controller.move & Controls.ATTACK)
    @trigger("neutral")
  # Handle fading of weights to new move
  @move.weight = Math.min(1, @move.weight + 1/(@move.blendFrames+1))
  # Compute sum of existing weights
  sum = 0
  for move in @moveset when move isnt @move
    sum += move.weight

  # Reduce existing weight sums to 0
  factor = if @move.weight > .999 or sum< .001 then 0 else (1-@move.weight)/sum
  for move in @moveset when move isnt @move
    if move.weight > 0
      move.weight *= factor

  # Complete animation update
  for move in @moveset when move.weight isnt 0
    move.preUpdateAnimation()
  for move in @moveset when move.weight isnt 0
    move.updateAnimation()

  ## Physics
  # Jump
  # TODO: Hmmm... How to trigger land when hitting ground during an aerial?
  if "jump" in @move.triggerableMoves and @move.movement is Move.FULL_MOVEMENT and @jumpRemaining and @controller.jump
    @velocity.y = 4 * @jumpHeight / @airTime
    @trigger("jump")
    if not @touchingGround
      @jumpRemaining = false
    @touchingGround = false

  sign = Math.sign(@controller.joystick.x)

  # Lateral Movement
  if @move.movement is Move.FULL_MOVEMENT or @move.movement is Move.DI_MOVEMENT and not @touchingGround
    # Even if movement is disabled during a move,
    # still allow DI if in the air.
    maxSpeed = if @move.movement is Move.DI_MOVEMENT then @diSpeed else
      if @touchingGround then @groundSpeed else @airSpeed
    acceleration = if @move.movement is Move.DI_MOVEMENT then @diAccel+@airFriction else
      if @touchingGround then @groundAccel+@groundFriction else @airAccel+@airFriction
    # Don't allow the velocity to exceed the maximum speed
    @velocity.x += sign *
      Math.max(0,
      Math.min(Math.abs(@controller.joystick.x*acceleration),
      maxSpeed - sign*@velocity.x))

  # Facing
  if @move.movement is Move.FULL_MOVEMENT and @touchingGround
    if sign > 0
      @facingRight = true
    else if sign < 0
      @facingRight = false

  if @facingRight
    @rotation.y = 0
  else
    @rotation.y = Math.PI 

  # Friction
  friction = if @touchingGround then @groundFriction else @airFriction
  @velocity.x = Math.sign(@velocity.x) * Math.max(0, Math.abs(@velocity.x) - friction)

  # Gotta get that gravity
  @velocity.y -= Math.max(0, Math.min(8 * @jumpHeight / @airTime / @airTime, @velocity.y + @maxFallSpeed))
  
  @mesh.sdebug.update()

Fighter::respawn = ()->
  @position.set(0, 0, 0)
  @velocity.set(0, 0, 0)
  @damage = 0
  @touchingGround = true
  @jumpRemaining = true
  @trigger("idle")
  @move.animationReset()
  @move.reset()
  @move.weight = 1
  # TODO: Reset moves

# Triggers a move
Fighter::trigger = (movename)->
  if @move
    @move.reset()
  @move = Utils.findObjectByName(@moveset, movename)
  @move.reset()
  @move.trigger()