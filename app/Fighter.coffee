# A moving, figting, controllable character
Box = require("Box")
Move = require("moves/Move")
Utils = require("Utils")
Controller = require("controller/Controller")
Ledge = require("Ledge")
tempVector = new THREE.Vector3()
Entity = require("Entity")
module.exports = class Fighter extends Entity
  constructor: (options, fighterData = {})->
    super
    @touchingGround = true
    @jumpRemaining = true

    ## Start initializing everything based on the fighter data. ##

    @diAccel = 0.008
    @diSpeed = 0.05

    @controller = options.controller
    @stage = options.stage
    @color = options.color or new THREE.Color(Math.floor(Math.random()*0xffffff))

    # Hitbox
    @box = new Box(fighterData.box)
    @collisionBoxes = [@box]
    # @box.debugBox.visible = true
    @add(@box)

    # The fighterdata is expected to come with its own JSON. Be sure to load beforehand!
    parsedJSON = THREE.JSONLoader.prototype.parse(Utils.clone(fighterData.modelJSON))
    @mesh=new THREE.SkinnedMesh(parsedJSON.geometry, new THREE.MeshLambertMaterial({skinning:true, shading:THREE.FlatShading, color: (new THREE.Color()).copy(@color)}))
    @mesh.rotation.y=Math.PI/2
    @add(@mesh)
    # @mesh.sdebug=new THREE.SkeletonHelper(@mesh)
    # # HAX to the MAX. Please remove this eventually.
    # setTimeout ()=>
    #   @parent.add(@mesh.sdebug)
    # , 0

    # The current ledge being grabbed, if any
    @ledge = null
    @canGrabLedge = true

    # The box used for grabbing the edge
    @ledgeBox = new Box(fighterData.ledgeBox)
    # @ledgeBox.debugBox.visible = true
    @add(@ledgeBox)

    # Whether or not the player is INVICIBLE
    @invulnerable = true
    @initialInvulnerability = Fighter.INITIAL_INVULNERABILITY
    @dodging = false
    @makeInvulnerable = ()=>
      @invulnerable = true
      @mesh.material.color.copy(@color)
      # Apply the screen effect to the color    
      @mesh.material.color.r = 1 - (1 - @mesh.material.color.r) * 0.5
      @mesh.material.color.g = 1 - (1 - @mesh.material.color.g) * 0.5
      @mesh.material.color.b = 1 - (1 - @mesh.material.color.b) * 0.5
    @makeVulnerable = ()=>
      @invulnerable = false
      @mesh.material.color.copy(@color)
    @startDodge = ()=>
      @makeInvulnerable()
      @dodging = true
    @endDodge = ()=>
      @makeVulnerable()
      @dodging = false

    # Current move
    @move = null

    @damage = 0
    @dying = 0

    # How much the current player has been charged by a smash
    @smashCharge = 0 # TODO: Eventually remove this to have it passed to the hurt target

    # Contains all hitBoxes that can hurt
    @hitBoxes = []

    # True if right, false if left
    @facingRight = true

    # TODO: This is spaghetti code. Please clean this up.
    @shieldDamage = Fighter.SHIELD_MAX_DAMAGE
    @shielding = false
    @shieldScale = 1.5
    @shieldBox = new Box(position: @box.position)
    @add(@shieldBox)

    @shieldObject = new THREE.Object3D()
    @shieldObject.visible = false
    @shieldObject.position.copy(@box.position)
    @add(@shieldObject)
    shield1Image = THREE.ImageUtils.loadTexture("images/Shield Additive.png")
    shield1 = new THREE.Sprite(new THREE.SpriteMaterial({depthTest:false, blending:THREE.AdditiveBlending, map:shield1Image, opacity:1}))
    @shieldObject.add(shield1)
    shield2Image = THREE.ImageUtils.loadTexture("images/Shield Subtractive.png")
    oppositeColor = new THREE.Color()
    oppositeColor.copy(@color)
    oppositeColor.r = 1 - oppositeColor.r
    oppositeColor.g = 1 - oppositeColor.g
    oppositeColor.b = 1 - oppositeColor.b
    shield2 = new THREE.Sprite(new THREE.SpriteMaterial({depthTest:false, blending:THREE.SubtractiveBlending, map:shield2Image, opacity:1, color: oppositeColor}))
    @shieldObject.add(shield2)
    shield3Image = THREE.ImageUtils.loadTexture("images/Shield Tint.png")
    shield3 = new THREE.Sprite(new THREE.SpriteMaterial({depthTest:false, blending:THREE.AdditiveBlending, map:shield3Image, opacity:1, color: @color}))
    @shieldObject.add(shield3)

    @activateShield = ()=>
      @shielding = true

    @deactivateShield = ()=>
      @shielding = false

    @moveset = []

    @moveset.push(new (require("moves/DeadMove"))(this, {name: "dead", animation: false}))

    @copyFighterData(fighterData)

    @respawn()
  # Build that moveset!
  @movetemplate: {
    "idle" : "IdleMove"
    "walk" : "WalkMove"
    "jump" : "JumpMove"
    "fall" : "FallMove"
    "land" : "LandMove"
    "hurt" : "HurtMove"
    "ledgegrab" : "LedgeGrabMove"
    "neutral" : "NeutralMove"
    "uptilt" : "GroundAttackMove"
    "downtilt" : "GroundAttackMove"
    "sidetilt" : "GroundAttackMove"
    "sidesmashcharge" : "SmashChargeMove"
    "sidesmash" : "SmashMove"
    "upsmashcharge" : "SmashChargeMove"
    "upsmash" : "SmashMove"
    "downsmashcharge" : "SmashChargeMove"
    "downsmash" : "SmashMove"
    "neutralaerial" : "AerialAttackMove"
    "downaerial" : "AerialAttackMove"
    "upaerial" : "AerialAttackMove"
    "backaerial" : "AerialAttackMove"
    "forwardaerial" : "AerialAttackMove"
    "shield" : "ShieldMove"
    "roll" : "RollMove"
    "dodge" : "DodgeMove"
    "airdodge" : "AirDodgeMove"
    "stun" : "StunMove"
    "dash" : "DashMove"
    "dashattack" : "DashAttackMove"
    "crouch" : "CrouchMove"
    "crawl" : "CrawlMove"
    "upspecial" : "SpecialAttackMove"
    "disabledfall" : "DisabledFallMove"
  }

  copyFighterData: (fighterData)->
    # These two parameters control the jump. Very handy!
    @airTime = fighterData.airTime # in frames
    @jumpHeight = fighterData.jumpHeight # in world units (meters)
    @shortHopHeight = fighterData.shortHopHeight
    @maxFallSpeed = fighterData.maxFallSpeed

    # Here are velocities
    @airAccel = fighterData.airAccel
    @airSpeed = fighterData.airSpeed
    @airFriction = fighterData.airFriction

    @groundAccel = fighterData.groundAccel
    @groundSpeed = fighterData.groundSpeed
    @groundFriction = fighterData.groundFriction

    @dashSpeed = fighterData.dashSpeed
    @crawlSpeed = fighterData.crawlSpeed

    # Add/update moves
    for move in fighterData.moves
      moveObject = Utils.findObjectByName(@moveset, move.name)
      if moveObject
        moveObject.copyFromOptions(move)
      else
        @moveset.push(new (require(if move?.custom? then "fighters/#{fighterData.id}/moves/#{move.custom}" else "moves/#{Fighter.movetemplate[move.name]}"))(this, move))

  # When the fighter is hit by a hit box
  takeDamage: (hitbox, otherFighter)->
    if @invulnerable
      return

    if otherFighter?.smashCharge?
      smashChargeFactor = 1 + otherFighter.smashCharge*.2
    else
      smashChargeFactor = 1

    if @shielding
      launchSpeed = 0.05
    else
      launchSpeed = smashChargeFactor * (@damage/100*hitbox.knockbackScaling+hitbox.knockback)/60
    velocityToAdd = tempVector.set(Math.cos(hitbox.angle)*launchSpeed,Math.sin(hitbox.angle)*launchSpeed,0)
    # Change velocity based on facing
    velocityToAdd.x *= hitbox.matrixWorld.elements[0]

    damage = hitbox.damage * smashChargeFactor
    if @shielding
      # Nullify upwards knockback
      velocityToAdd.y = -0.01
      @shieldDamage = Math.max(0, @shieldDamage - damage * Fighter.SHIELD_DAMAGE_REDUCTION)
    else
      @damage += damage

      # Change facing based on velocity
      if velocityToAdd.x isnt 0
        @facingRight = velocityToAdd.x < 0

      # Gain another jump
      @jumpRemaining = true
    
    # Freeze Time
    launchSpeedFactor = Math.max(Math.min(launchSpeed * 3 - .4, 1), 0.01)
    freeze = Math.max(hitbox.freezeTime, 3) * launchSpeedFactor
    if otherFighter?
      otherFighter.frozen = freeze
    @frozen = freeze

    # Multiple hitBoxes compound velocities
    # if not @shielding and @move.name is "hurt" and @move.currentTime is 1
    @velocity.add(velocityToAdd)
    # else
    #   @velocity.copy(velocityToAdd)
    velocityToAdd.normalize().multiplyScalar(launchSpeedFactor)
    @stage.cameraShake.sub(velocityToAdd)
    @stage.cameraShakeTime = 1
    if not @shielding
      @trigger("hurt", launchSpeed)
    
  # Plenty of these methods are explained in Stage.update()
  applyVelocity: (deltaTime)->
    if @frozen > 0
      return
    tempVector.copy(@velocity).normalize().multiplyScalar(Math.min(@velocity.length(), Fighter.MAX_VELOCITY))
    tempVector.multiplyScalar(deltaTime)
    @position.add(tempVector)
    @touchingGround = false

  resolveCollision: (otherBox, entity, deltaTime)->
    if entity is @stage
      # Ground collision - Touching the stage
      resolutionVector = @box.resolveCollision(otherBox)
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
    else if entity instanceof Fighter
      # Soft fighter-fighter collision
      if @position.x > entity.position.x
        @position.x += Fighter.SOFT_COLLISION_VELOCITY * deltaTime
        entity.position.x -= Fighter.SOFT_COLLISION_VELOCITY * deltaTime
      else
        @position.x -= Fighter.SOFT_COLLISION_VELOCITY * deltaTime
        entity.position.x += Fighter.SOFT_COLLISION_VELOCITY * deltaTime

  update: (deltaTime)->
    @controller.update(deltaTime)

    #console.log @move.name
    if @frozen > 0
      @frozen = Math.max(0, @frozen - deltaTime)
    else
      if @dying > 0
        @dying = Math.max(0, @dying - deltaTime)
        if @dying is 0
          @respawn()
      else
        if @initialInvulnerability > 0 and @initialInvulnerability - deltaTime <= 0
          @makeVulnerable()
        @initialInvulnerability = Math.max(@initialInvulnerability - deltaTime, 0)

        # Gotta get that gravity (goes here because the move can mess with it)
        @velocity.y -= Math.max(0, Math.min(8 * deltaTime * @jumpHeight / @airTime / @airTime, @velocity.y + @maxFallSpeed))

      # Complete the current move
      if @move.name is "walk"
        @move.update(Math.abs(@controller.joystick.x)*deltaTime)
      else
        @move.update(deltaTime)

      # Handle automatic endings of moves
      if @move.triggerNext?
        @trigger(@move.triggerNext, @move.triggerArguments...)

      @triggerFromController()

      @updatePhysics(deltaTime)

    if @dying is 0
      @updateShield(deltaTime)
      @updateMesh(deltaTime)

    #@mesh.sdebug.update()

  respawn: ()->
    @position.set(0, 1, 0)
    @updateMatrixWorld()
    @box.updateMatrixWorld()
    #@position.set(0, 0, 0)
    @velocity.set(0, 0, 0)
    @damage = 0
    @shieldDamage = Fighter.SHIELD_MAX_DAMAGE
    @touchingGround = true
    @jumpRemaining = true
    @ledge = null
    @canGrabLedge = true
    @dying = 0
    @trigger("idle")
    @move.animationReset()
    @move.reset()
    @move.weight = 1
    @makeInvulnerable() 
    @initialInvulnerability = Fighter.INITIAL_INVULNERABILITY
    # TODO: Reset moves

  # Triggers a move
  trigger: (movename, options...)->
    if @move
      @move.reset()
    move = Utils.findObjectByName(@moveset, movename)
    if move?
      @move = move
      @hitBoxes = move.hitBoxes
      @move.trigger(options...)
    else
      console.warn("Move #{movename} has not been added to the moveset")
      @hitBoxes = []

  # Requests a move to be triggered if the current move allows
  request: (movename, options...)->
    if movename in @move.triggerableMoves
      @trigger(movename, options...)
      return true
    else
      return false

  # Triggers moves that the controller would like to
  triggerFromController: ()->
    # TODO: Triggerables (is this the right place?)
    if @move.name is "idle"
      if @controller.move and not @controller.suspendedMove
        @controller.suspendMove(@controller.move)

    if (@controller.move & Controller.SPECIAL)
      if (@controller.move & Controller.UP)
        @request("upspecial")
      else if (@controller.move & Controller.DOWN)
        @request("downspecial")
      else if (@controller.move & (Controller.RIGHT | Controller.LEFT))
        @facingRight = not (@controller.move & Controller.LEFT)
        @request("sidespecial")
      else
        @request("neutralspecial")
    if (@controller.move & Controller.ATTACK) and (@controller.move & Controller.TILT)
      if (@controller.move & Controller.UP)
        @request("upsmashcharge")
      else if (@controller.move & Controller.DOWN)
        @request("downsmashcharge")
      else if (@controller.move & (Controller.LEFT | Controller.RIGHT))
        if "sidesmashcharge" in @move.triggerableMoves
          if @request("sidesmashcharge")
            @facingRight = not (@controller.move & Controller.LEFT)
    if (@controller.move & Controller.ATTACK)
      @request("dashattack")
      if (@controller.move & Controller.UP)
        @request("uptilt")
        @request("upaerial")
      else if (@controller.move & Controller.DOWN)
        @request("downtilt")
        @request("downaerial")
      else if (@controller.move & (Controller.RIGHT | Controller.LEFT))
        # Side/tilt
        if @request("sidetilt")
          @facingRight = not (@controller.move & Controller.LEFT)
        else
          # Forward/back Aerial
          forward = @facingRight and (@controller.move & Controller.RIGHT) or
            not @facingRight and (@controller.move & Controller.LEFT)
          if forward
            @request("forwardaerial")
          else
            @request("backaerial")
      else
        # Side
        @request("neutral")
        @request("neutralaerial")

    # Shield
    if (@controller.move & Controller.SHIELD)
      @request("airdodge")
    if ((@controller.move & Controller.SHIELD) or @move.name is "shield") and (@controller.move & Controller.TILT)
      if (@controller.move & (Controller.LEFT | Controller.RIGHT))
        if @request("roll")
          @facingRight = not (@controller.move & Controller.RIGHT)
      if (@controller.move & Controller.DOWN)
        @request("dodge")
    else if (@controller.shield isnt 0 and not @controller.suspendedMove)
      @request("shield")

    # Dashing
    if (@controller.move & Controller.DOUBLE_TILT)
      if (@controller.move & (Controller.LEFT | Controller.RIGHT))
        if @touchingGround
          @request("dash")
        # if not @touchingGround
        #   # Air turn
        #   if @move.movement is Move.FULL_MOVEMENT
        #     @facingRight = not (@controller.move & Controller.LEFT)
    
    # Deferred triggering from Idle
    if @move.name is "idle" and (@controller.move & Controller.ANY_DIRECTION)
      if (@controller.move & Controller.DOWN)
        @request("crouch")
      else if @controller.joystick.x isnt 0 
        @request("walk")

    # Fall from ledge
    if @move.name is "ledgegrab"
      if (@controller.move & Controller.DOWN) #or (@controller.move & (Controller.LEFT | Controller.RIGHT)) 
        if @request("fall")
          @ledge.fighter = null
          @ledge = null

  updateMesh: (deltaTime)->
    # Handle fading of weights to new move
    @move.weight = Math.min(1, @move.weight + 1/(@move.blendFrames / deltaTime + 1))
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
    
    # Turn around
    if @move.blendFrames isnt 0
      if @facingRight
        if @rotation.y > Math.PI
          @rotation.y += deltaTime * Fighter.ROTATION_SPEED
        else if @rotation.y > 0
          @rotation.y -= deltaTime * Fighter.ROTATION_SPEED
        if @rotation.y < 0 or @rotation.y > Math.PI * 2
          @rotation.y = 0
      else
        if @rotation.y is 0
          @rotation.y = Math.PI * 2
        if @rotation.y > Math.PI
          @rotation.y = Math.max(Math.PI, @rotation.y - deltaTime * Fighter.ROTATION_SPEED)
        else if @rotation.y < Math.PI
          @rotation.y = Math.min(Math.PI, @rotation.y + deltaTime * Fighter.ROTATION_SPEED)
    else
      @rotation.y = if @facingRight then 0 else Math.PI

  updatePhysics: (deltaTime)->
    ## Physics

    #Detect out of bounds
    if not @box.intersects(@stage.safeBox)
      if @dying is 0
        @trigger("dead")
        @dying = Fighter.DEAD_TIME
      return
    
    #Don't fall off the stage
    if @move.preventFall
      for ledgeBox in @stage.ledgeBoxes when ledgeBox instanceof Box
        if @box.intersects(ledgeBox)
          #Touching the stage
          resolutionVector = @box.resolveCollision(ledgeBox)
          @position.add(resolutionVector)

    #Ledge grab
    ledgeAvailable = false
    for ledge in @stage.children when ledge instanceof Ledge
      if @ledgeBox.contains(ledge.position)
        ledgeAvailable = true
        if @canGrabLedge and @request("ledgegrab", ledge)
          @canGrabLedge = false
        break
    if not ledgeAvailable
      @canGrabLedge = true

    # Jump
    # TODO: Hmmm... Is this the right place to trigger jump?
    if @jumpRemaining and ((@controller.move & Controller.JUMP) or (@controller.move & Controller.UP) and (@controller.move & Controller.TILT))
      @request("jump")

    sign = Math.sign(@controller.joystick.x)

    # Friction
    friction = deltaTime * (if @touchingGround then @groundFriction else @airFriction)
    # Lateral Movement
    if (@controller.move & (Controller.ANY_DIRECTION)) and sign isnt 0 and (@move.movement is Move.FULL_MOVEMENT or (@move.movement is Move.DI_MOVEMENT and not @touchingGround))
        # Even if movement is disabled during a move,
        # still allow DI if in the air.
        if @move.name is "dash"
          maxSpeed = @dashSpeed
          acceleration = deltaTime * (@groundAccel + @groundFriction)
          # Don't allow the velocity to exceed the maximum speed
          @velocity.x += sign *
            Math.max(0,
            Math.min(acceleration,
            maxSpeed - sign*@velocity.x))
        else
          maxSpeed = if @move.movement is Move.DI_MOVEMENT then @diSpeed else
            if @touchingGround then (if @move.name is "crawl" then @crawlSpeed else @groundSpeed) else @airSpeed
          maxSpeed *= Math.abs(@controller.joystick.x)
          acceleration = deltaTime * (if @move.movement is Move.DI_MOVEMENT then @diAccel + @airFriction else
            if @touchingGround then @groundAccel else @airAccel + @airFriction)
          acceleration *= Math.abs(@controller.joystick.x)
          # Don't allow the velocity to exceed the maximum speed
          @velocity.x += sign *
            Math.max(0,
            Math.min(Math.abs(acceleration) + friction,
            maxSpeed - sign*@velocity.x))

    # Facing
    if @move.movement is Move.FULL_MOVEMENT and @touchingGround
      if sign > 0
        @facingRight = true
      else if sign < 0
        @facingRight = false

    @velocity.x = Math.sign(@velocity.x) * Math.max(0, Math.abs(@velocity.x) - friction)

    # Ledge Grab
    if @move.name is "ledgegrab" and @ledge?
      @facingRight = @ledge.facingRight
      # Move to the ledge
      handPosition = @box.getVertex(@facingRight)
      @velocity.copy(@ledge.position).sub(handPosition)
      length = @velocity.length()
      factor = 1 / Math.max(1, 10 - @move.currentTime)
      @velocity.normalize().multiplyScalar(length * factor)

  updateShield: (deltaTime)->
    if @shielding
      @shieldDamage = Math.max(0, @shieldDamage - deltaTime * Fighter.SHIELD_DRAIN_RATE)
      @shieldObject.visible = true
      size = @shieldScale * (0.3 + 0.7 * @shieldDamage / Fighter.SHIELD_MAX_DAMAGE)
      @shieldObject.scale.set(size, size, size)
      @shieldBox.size.set(0.8 * size, 0.8 * size, 0)
      if @shieldDamage is 0
        # TODO: Add a penalty
        @shieldDamage = 0.6 * Fighter.SHIELD_MAX_DAMAGE
        @trigger("stun")
    else
      @shieldDamage = Math.min(Fighter.SHIELD_MAX_DAMAGE, @shieldDamage + deltaTime * Fighter.SHIELD_RECHARGE_RATE)
      @shieldObject.visible = false

  @SHIELD_DRAIN_RATE: 8/60
  @SHIELD_RECHARGE_RATE: 2/60
  @SHIELD_MAX_DAMAGE: 50
  @SHIELD_DAMAGE_REDUCTION: 0.7
  @ROTATION_SPEED: 0.3
  @MAX_VELOCITY: 0.4
  @SOFT_COLLISION_VELOCITY: 0.001
  @INITIAL_INVULNERABILITY: 180
  @DEAD_TIME: 60