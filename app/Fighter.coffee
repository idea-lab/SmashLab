# A moving, figting, controllable character
Box = require("Box")
Move = require("moves/Move")
Utils = require("Utils")
Controls = require("controls/Controls")
Ledge = require("Ledge")
tempVector = new THREE.Vector3()
Fighter = module.exports = (fighterData = {}, @options)->
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

  @diAccel = 0.008
  @diSpeed = 0.05

  @controller = options.controller
  @stage = options.stage
  @color = options.color or new THREE.Color(Math.floor(Math.random()*0xffffff))
  # Hitbox
  @box = new Box(fighterData.box)
  # @box.debugBox.visible = true
  @add(@box)

  # The current ledge being grabbed, if any
  @ledge = null
  @canGrabLedge = true

  # The box used for grabbing the edge
  @ledgeBox = new Box(fighterData.ledgeBox)
  # @ledgeBox.debugBox.visible = true
  @add(@ledgeBox)

  # The fighterdata is expected to come with its own JSON. Be sure to load beforehand!
  parsedJSON = THREE.JSONLoader.prototype.parse(Utils.clone(fighterData.modelJSON))
  @mesh=new THREE.SkinnedMesh(parsedJSON.geometry, new THREE.MeshBasicMaterial({skinning:true, color: @color}))
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
    new (require("moves/LedgeGrabMove"))(this, Utils.findObjectByName(fighterData.moves, "ledgegrab"))
    new (require("moves/NeutralMove"))(this, Utils.findObjectByName(fighterData.moves, "neutral"))
    new (require("moves/GroundAttackMove"))(this, Utils.findObjectByName(fighterData.moves, "uptilt"))
    new (require("moves/GroundAttackMove"))(this, Utils.findObjectByName(fighterData.moves, "downtilt"))
    new (require("moves/GroundAttackMove"))(this, Utils.findObjectByName(fighterData.moves, "sidetilt"))
    new (require("moves/SmashChargeMove"))(this, Utils.findObjectByName(fighterData.moves, "sidesmashcharge"))
    new (require("moves/SmashMove"))(this, Utils.findObjectByName(fighterData.moves, "sidesmash"))
    new (require("moves/SmashChargeMove"))(this, Utils.findObjectByName(fighterData.moves, "upsmashcharge"))
    new (require("moves/SmashMove"))(this, Utils.findObjectByName(fighterData.moves, "upsmash"))
    new (require("moves/SmashChargeMove"))(this, Utils.findObjectByName(fighterData.moves, "downsmashcharge"))
    new (require("moves/SmashMove"))(this, Utils.findObjectByName(fighterData.moves, "downsmash"))
    new (require("moves/AerialAttackMove"))(this, Utils.findObjectByName(fighterData.moves, "neutralaerial"))
    new (require("moves/AerialAttackMove"))(this, Utils.findObjectByName(fighterData.moves, "downaerial"))
    new (require("moves/AerialAttackMove"))(this, Utils.findObjectByName(fighterData.moves, "upaerial"))
    new (require("moves/AerialAttackMove"))(this, Utils.findObjectByName(fighterData.moves, "backaerial"))
    new (require("moves/AerialAttackMove"))(this, Utils.findObjectByName(fighterData.moves, "forwardaerial"))
  ]

  # Current move
  @move = null

  @damage = 0

  # How much the current player has been charged by a smash
  @smashCharge = 0

  # True if right, false if left
  @facingRight = true

  @respawn()
  return

Fighter:: = Object.create(THREE.Object3D::)
Fighter::constructor = Fighter

# When the fighter is hit by a hit box
Fighter::hurt = (hitbox, otherfighter)->
  if otherfighter?
    smashChargeFactor = 1 + otherfighter.smashCharge*.2
  else
    smashChargeFactor = 1

  launchSpeed = smashChargeFactor * (@damage/100*hitbox.knockbackScaling+hitbox.knockback)/60
  velocityToAdd = tempVector.set(Math.cos(hitbox.angle)*launchSpeed,Math.sin(hitbox.angle)*launchSpeed,0)

  @damage += hitbox.damage * smashChargeFactor

  # Change velocity based on facing
  velocityToAdd.x *= hitbox.matrixWorld.elements[0]

  # Change facing based on velocity
  @facingRight = hitbox.matrixWorld.elements[0] < 0

  # Gain another jump
  @jumpRemaining = true

  # Freeze Time
  launchSpeedFactor = Math.max(Math.min(launchSpeed * 3, 1), 0)
  freeze = Math.max(hitbox.freezeTime, 3) * launchSpeedFactor
  @frozen = otherfighter.frozen = freeze

  # Multiple hitboxes compound velocities
  if @move.name is "hurt" and @move.currentTime is 1
    @velocity.add(velocityToAdd)
  else
    @velocity.copy(velocityToAdd)
  velocityToAdd.multiplyScalar(launchSpeedFactor)
  @stage.cameraShake.sub(velocityToAdd)
  @stage.cameraShakeTime = 1
  @trigger("hurt", launchSpeed)
  
# Plenty of these methods are explained in Stage.update()
Fighter::applyVelocity = ->
  if @frozen > 0
    return
  @position.add(@velocity)
  @updateMatrixWorld()
  @box.updateMatrixWorld()

Fighter::resolveStageCollisions = (stage)->
  if @frozen > 0
    return

  #Detect out of bounds
  if not @box.intersects(stage.safebox)
    @respawn()
    @position.set(0, 1, 0)
    return

  # Grond collision
  @touchingGround = false
  for stageBox in stage.activeBoxes when stageBox instanceof Box
    if @box.intersects(stageBox)
      #Touching the stage
      resolutionVector = @box.resolveCollision(stageBox)
      @position.add(resolutionVector)
      if resolutionVector.y > 0
        # Just landing. Engage your flaps and reverse your jets
        # because ground control needs to know your heading.
        if @move.name is "hurt"
          # Bounce!
          @velocity.y = 0.8 * Math.abs(@velocity.y)
        else
          @touchingGround = true
          @jumpRemaining = true
          if @velocity.y < 0
            @velocity.y = 0
  
  #Ledge grab
  ledgeAvailable = false
  for ledge in stage.children when ledge instanceof Ledge
    if @ledgeBox.contains(ledge.position)
      ledgeAvailable = true
      if @canGrabLedge and not (@controller.move & Controls.DOWN)
        @trigger("ledgegrab", ledge)
        @canGrabLedge = false
      break
  if not ledgeAvailable
    @canGrabLedge = true

Fighter::update = ->
  @controller.update()


  if @frozen > 0
    @frozen = Math.max(0, @frozen - 1)
  else
    # Complete the current move
    @move.update(1)

    # Handle automatic endings of moves
    if @move.triggerNext?
      @trigger(@move.triggerNext)

    @triggerFromController()

    @updatePhysics()

  @updateMesh()
  
  @mesh.sdebug.update()

Fighter::respawn = ()->
  @position.set(0, 0, 0)
  @velocity.set(0, 0, 0)
  @damage = 0
  @touchingGround = true
  @jumpRemaining = true
  @ledge = null
  @canGrabLedge = true
  @trigger("idle")
  @move.animationReset()
  @move.reset()
  @move.weight = 1
  # TODO: Reset moves

# Triggers a move
Fighter::trigger = (movename, options)->
  if @move
    @move.reset()
  @move = Utils.findObjectByName(@moveset, movename)
  @move.trigger(options)

# Triggers moves that the controller would like to
Fighter::triggerFromController = ()->
  # TODO: Triggerables (is this the right place?)
  if (@controller.move & Controls.SMASH)
    if (@controller.move & Controls.UP)
      if "upsmashcharge" in @move.triggerableMoves
        @trigger("upsmashcharge")
    else if (@controller.move & Controls.DOWN)
      if "downsmashcharge" in @move.triggerableMoves
        @trigger("downsmashcharge")
    else if (@controller.move & (Controls.LEFT | Controls.RIGHT))
      if "sidesmashcharge" in @move.triggerableMoves
        @facingRight = not (@controller.move & Controls.LEFT)
        @trigger("sidesmashcharge")
  if (@controller.move & Controls.ATTACK)
    if (@controller.move & Controls.UP)
      if "uptilt" in @move.triggerableMoves
        @trigger("uptilt")
      if "upaerial" in @move.triggerableMoves
        @trigger("upaerial")
    else if (@controller.move & Controls.DOWN)
      if "downtilt" in @move.triggerableMoves
        @trigger("downtilt")
      if "downaerial" in @move.triggerableMoves
        @trigger("downaerial")
    else if (@controller.move & (Controls.RIGHT | Controls.LEFT))
      # Side/tilt
      if "sidetilt" in @move.triggerableMoves
        @facingRight = not (@controller.move & Controls.LEFT)
        @trigger("sidetilt")
      else
        # Forward/back Aerial
        forward = @facingRight and (@controller.move & Controls.RIGHT) or
          not @facingRight and (@controller.move & Controls.LEFT)
        if forward
          if "forwardaerial" in @move.triggerableMoves
            @trigger("forwardaerial")
        else
          if "backaerial" in @move.triggerableMoves
            @trigger("backaerial")
    else
      # Side
      if "neutral" in @move.triggerableMoves
        @trigger("neutral")
      if "neutralaerial" in @move.triggerableMoves
        @trigger("neutralaerial")

  # Fall from ledge
  if @move.name is "ledgegrab" and (@controller.move & Controls.DOWN) and "fall" in @move.triggerableMoves
      @ledge.fighter = null
      @ledge = null
      @trigger("fall")


Fighter::updateMesh = ()->
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
  
  if @facingRight
    @rotation.y = 0
  else
    @rotation.y = Math.PI 

Fighter::updatePhysics = ()->
  ## Physics
  # Jump
  # TODO: Hmmm... Is this the right place to trigger jump?
  if "jump" in @move.triggerableMoves  and
      @jumpRemaining and (@controller.move & Controls.JUMP)
    @velocity.y = 4 * @jumpHeight / @airTime
    @trigger("jump")
    if not @touchingGround
      @jumpRemaining = false
    @touchingGround = false

  sign = Math.sign(@controller.joystick.x)

  # Lateral Movement
  if @move.movement is Move.FULL_MOVEMENT or (@move.movement is Move.DI_MOVEMENT and not @touchingGround)
    if (@move.name isnt "idle" or @controller.joystickSmashed is 0)
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

  # Friction
  friction = if @touchingGround then @groundFriction else @airFriction
  @velocity.x = Math.sign(@velocity.x) * Math.max(0, Math.abs(@velocity.x) - friction)

  # Gotta get that gravity
  @velocity.y -= Math.max(0, Math.min(8 * @jumpHeight / @airTime / @airTime, @velocity.y + @maxFallSpeed))

  # Ledge Grab
  if @move.name is "ledgegrab" and @ledge?
    @facingRight = @ledge.facingRight
    # Move to the ledge
    handPosition = @box.getVertex(@facingRight)
    @velocity.copy(@ledge.position).sub(handPosition)
    length = @velocity.length()
    @velocity.normalize().multiplyScalar(Math.min(0.2, length))