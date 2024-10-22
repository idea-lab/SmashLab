# Contains the stage and fighters, and updates the fight.
Fighter = require("Fighter")
Entity = require("Entity")
Box = require("Box")
Utils = require("Utils")
Ledge = require("Ledge")
CPS = require("CSSParticleSystem")
KeyboardController = require("controller/KeyboardController")
GamepadController = require("controller/GamepadController")
tempVector = new THREE.Vector3()

Editor = require("Editor")
editor = new Editor(document.getElementById("editor"), "test3data")

editor.loadText()
test3Data = editor.getJSON()
if not test3Data
  test3Data = require("fighters/test3/test3")
if not editor.getText()
  editor.setJSON(test3Data)
  

module.exports = class Stage extends THREE.Scene
  constructor: (@stageData, @game) ->
    super()
    @fov = 45
    @camera = new THREE.PerspectiveCamera(1, 1, 1, 100)
    @camera.position.set(0, 0, 10)
    @add(@camera)
    @resize()
    @cameraShake = new THREE.Vector3()
    @cameraShakePos = new THREE.Vector3()

    # Add hitboxes
    @collisionBoxes = []
    @ledgeBoxes = []
    for activeBox in @stageData.collisionBoxes
      box = new Box(activeBox)
      box.updateMatrixWorld()
      @collisionBoxes.push(box)
      @add(box)
      # Add boxes to collide with to avoid falling off the edge
      # along with the ledges
      if activeBox.leftLedge?
        # Makes it so the ledges work
        leftLedge = new Ledge(position: (new THREE.Vector3()).copy(box.getVertex(false)), facingRight: true)
        @add(leftLedge)
        ledgeBox = new Box(size: new THREE.Vector3(1, 1 ,0), position: (new THREE.Vector3()).copy(box.getVertex(true)))
        ledgeBox.position.x += 0.5
        ledgeBox.position.y += 0.5
        @ledgeBoxes.push(ledgeBox)
        @add(ledgeBox)
      if activeBox.rightLedge?
        rightLedge = new Ledge(position: (new THREE.Vector3()).copy(box.getVertex(true)), facingRight: false)
        @add(rightLedge)
        ledgeBox = new Box(size: new THREE.Vector3(1, 1 ,0), position: (new THREE.Vector3()).copy(box.getVertex(false)))
        ledgeBox.position.x -= 0.5
        ledgeBox.position.y += 0.5
        @ledgeBoxes.push(ledgeBox)
        @add(ledgeBox)

    # Safe box - the box in which you aren't immediately KO'ed
    @safeBox = new Box(@stageData.safeBox)
    @add(@safeBox)

    # Camera stays in the camera box
    @cameraBox = new Box(@stageData.cameraBox)
    @add(@cameraBox)

    # Let the stage do its thing
    @stageObject = new @stageData(this)

    # TODO: Remove this eventually
    @loaded = false
    
    @inactiveControllers = [
      # Arrow Keys ZXC
      new KeyboardController({
        upKey: 38
        downKey: 40
        leftKey: 37
        rightKey: 39
        attackKey: 90
        specialKey: 88
        shieldKey: 67
        grabKey: 86
      })
      # WASDY789
      new KeyboardController({
        upKey: 87
        downKey: 83
        leftKey: 65
        rightKey: 68
        attackKey: 89
        specialKey: 55
        shieldKey: 56
        grabKey: 57
      })
      # TFGHO0-
      new KeyboardController({
        upKey: 84
        downKey: 71
        leftKey: 70
        rightKey: 72
        attackKey: 79
        specialKey: 48
        shieldKey: 189
        grabKey: 187
      })
      # IJKL;[]\
      new KeyboardController({
        upKey: 73
        downKey: 75
        leftKey: 74
        rightKey: 76
        attackKey: 186
        specialKey: 219
        shieldKey: 221
        grabKey: 220
      })
      # HomeEndDeletePageDownNumpad7SlashStarMinus 
      new KeyboardController({
        upKey: 36
        downKey: 35
        leftKey: 46
        rightKey: 34
        attackKey: 103
        specialKey: 111
        shieldKey: 106
        grabKey: 109
      })
    ]

    @inactiveControllers.push(new GamepadController(gamepadIndex: 0))
    @inactiveControllers.push(new GamepadController(gamepadIndex: 1))
    @inactiveControllers.push(new GamepadController(gamepadIndex: 2))
    @inactiveControllers.push(new GamepadController(gamepadIndex: 3))
    @activeControllers = []


    @players = []

    #Editor binding
    editor.onupdate = (data)=>
      for player in @players
        player.copyFighterData(data)

    @playerHudElements = [] # TODO: Remove!
    
    $.ajax(test3Data.modelSrc).done (data)=>
      test3Data.modelJSON = data
      @loaded = true

    # TODO: Clean it up!
    directionalLight = new THREE.DirectionalLight(0xffffff, 2)
    directionalLight.position.set(0, 1, 0.5)
    @add(directionalLight)
    hemisphereLight = new THREE.HemisphereLight(0xffffff, 1)
    hemisphereLight.position.set(0, -1, -0.5)
    @add(hemisphereLight)

    @deltaTime = 1
    $(window).on "keydown", (event)=>
      switch event.keyCode
        when 49 then @deltaTime = 0.1 #Math.max(0.1, @deltaTime * 0.9)
        #when 50 then @deltaTime = Math.min(2, @deltaTime / 0.9)
        when 51 then @removeAllFighters()
    $(window).on "keyup", (event)=>
      switch event.keyCode
        when 49 then @deltaTime = 1
    #@orbitcontrols = new THREE.OrbitControls(@camera)

    @particleSystem = new CPS.CSSParticleSystem()

  # Updates the entire fight.
  update: ->
    if not @loaded
      return

    @updateInactiveControllers()

    # Update cycle has these events in order:
    # - Apply velocities
    for entity in @children when entity instanceof Entity
      entity.applyVelocity(@deltaTime)
      entity.updateMatrixWorld()
      for box in entity.collisionBoxes when box.collides
          box.updateMatrixWorld()

    # - Detect and resolve collisions between physics (collision) boxes and entities
    #   Includes fighter-stage, fighter-fighter, and projectile-stage

    for e in [0...@children.length]
      entity = @children[e]
      if entity instanceof Entity
        for box in entity.collisionBoxes when box.collides
          for otherBox in @collisionBoxes when box.collides
              if box.intersects(otherBox)
                entity.resolveCollision(box, otherBox, this, @deltaTime)
                # box.resolveCollision?(otherBox, @stage)
                # otherBox.resolveCollision?(box, entity)
          for f in [e + 1...@children.length]
            secondEntity = @children[f]
            if secondEntity instanceof Entity
              for otherBox in secondEntity.collisionBoxes when otherBox.collides
                if box.intersects(otherBox)
                  # box.resolveCollision?(otherBox, secondEntity)
                  # otherBox.resolveCollision?(box, entity)
                  entity.resolveCollision(box, otherBox, secondEntity, @deltaTime)
                  secondEntity.resolveCollision(otherBox, box, entity, @deltaTime)

    # - Update hitboxes and moves, player input, set movement velocity,
    #   controllers, gravity, and the rest of the good stuff
    for entity in @children when entity instanceof Entity
      entity.update(@deltaTime)
    
    # - Detect hitbox-player collision, set velocities for colliding hitboxes
    #   (velocities will be applied next render)
    for entity in @children when entity instanceof Entity
      for hitbox in entity.hitBoxes when hitbox.collides and (hitbox.active or hitbox.deflect)
        hitbox.updateMatrixWorld()
        # Go through potential targets
        for target in @children when target isnt entity and target instanceof Entity and hitbox.owner isnt target
          if not (target in hitbox.alreadyHit)
            # TODO: Account for multiple collision boxes?
            if target.collisionBoxes.length > 0 and hitbox.intersects(target.collisionBoxes[0]) or target.shielding and hitbox.intersects(target.shieldBox)
              unless hitbox.collide?(target)
                if hitbox.deflect
                  target.deflect?(hitbox, entity)
                else if not target.dodging
                  target.takeDamage(hitbox, entity)
                  entity.giveDamage(hitbox, target)
              hitbox.alreadyHit.push(target)

    # Remove dead projectiles
    i = 0
    while i < @children.length
      entity = @children[i]
      if entity instanceof Entity
        if entity.lifetime? and entity.lifetime <= 0
          @children.splice(i, 1)
          i--
      i++

    @stageObject.update?(@deltaTime)

    @updateHUD()
    @updateCamera()

    @particleSystem.update(@deltaTime)

  # Update camera
  updateCamera: ->
    if not @players.length
      return
    # maxPosition = new THREE.Vector3(-Infinity, -Infinity, 0) # TODO: Make temporary
    # minPosition = new THREE.Vector3(Infinity, Infinity, 0) # TODO: Make temporary
    maxPositionX = -Infinity
    maxPositionY = -Infinity
    minPositionX = Infinity
    minPositionY = Infinity
    worldPosition = tempVector.set(0, 0, 0) # TODO: Make temporary

    # Find the bounding box of all fighters
    for fighter in @children when fighter instanceof Fighter
      worldPosition.setFromMatrixPosition(fighter.box.matrixWorld)
      maxPositionX = Math.max(maxPositionX, worldPosition.x)
      maxPositionY = Math.max(maxPositionY, worldPosition.y)
      minPositionX = Math.min(minPositionX, worldPosition.x)
      minPositionY = Math.min(minPositionY, worldPosition.y)
    characterMargin = 3.5

    # Add a margin to the bounding box
    maxPositionX += characterMargin
    maxPositionY += characterMargin
    minPositionX -= characterMargin
    minPositionY -= characterMargin

    maxPositionX = Math.min(maxPositionX, @cameraBox.position.x + @cameraBox.size.x * 0.5)
    maxPositionY = Math.min(maxPositionY, @cameraBox.position.y + @cameraBox.size.y * 0.5)
    minPositionX = Math.max(minPositionX, @cameraBox.position.x - @cameraBox.size.x * 0.5)
    minPositionY = Math.max(minPositionY, @cameraBox.position.y - @cameraBox.size.y * 0.5)
    
    # Compute where the camera wants to go
    averagePosition = tempVector.set(maxPositionX + minPositionX, maxPositionY + minPositionY, 0).multiplyScalar(0.5)
    averagePosition.z = Math.max(
      (maxPositionY - minPositionY),
      (maxPositionX - minPositionX) / @camera.aspect
    )/2/Math.tan(Math.PI*@camera.fov/180/2)



    # Pull back from camera bounds
    maxZ = Math.min(
      @cameraBox.size.y,
      @cameraBox.size.x / @camera.aspect
    )/2/Math.tan(Math.PI*@camera.fov/180/2)
    zFactor = 1 - Math.min(1, averagePosition.z/maxZ)
    maxPositionX = @cameraBox.position.x + @cameraBox.size.x * 0.5 * zFactor
    maxPositionY = @cameraBox.position.y + @cameraBox.size.y * 0.5 * zFactor
    minPositionX = @cameraBox.position.x - @cameraBox.size.x * 0.5 * zFactor
    minPositionY = @cameraBox.position.y - @cameraBox.size.y * 0.5 * zFactor

    averagePosition.x = Math.min(Math.max(averagePosition.x, minPositionX), maxPositionX)
    averagePosition.y = Math.min(Math.max(averagePosition.y, minPositionY), maxPositionY)
    averagePosition.z = Math.min(Math.max(averagePosition.z, 0), maxZ)
    
    # Lerp the camera to the averagePosition
    @camera.position.lerp(averagePosition, 0.1)

    kx = tempVector.copy(@cameraShakePos).multiplyScalar(-@deltaTime*Stage.CAMERA_SHAKE_K)
    @cameraShake.add(kx).multiplyScalar(Stage.CAMERA_SHAKE_DECAY)
    tempVector.copy(@cameraShake).multiplyScalar(@deltaTime)
    @cameraShakePos.add(tempVector)
    @camera.position.add(@cameraShakePos)

  resize: ->
    @camera.aspect = @game.width/@game.height
    @camera.fov = @fov
    @camera.updateProjectionMatrix()

  updateInactiveControllers: ()->
    for i in [0...@inactiveControllers.length]
      # TODO: Please don't faint while trying to remove this code
      if i >= @inactiveControllers.length
        break
      controller = @inactiveControllers[i]
      controller.update(0)
      if controller.active
        fighter = new Fighter({
          stage: this,
          color: @getPlayerColor(@players.length),
          controller: controller
        }, test3Data)
        @add(fighter)
        @players.push(fighter)
        hudElement = $("<div class=\"damagepercent\"></div>")
        $(".bottombar").append(hudElement)
        hudElement.css("border-bottom-color", "rgba("+Utils.colorToCSS(fighter.color)[4..-2]+", 0.8)")
        @playerHudElements.push(
          hudElement
        )
        @activeControllers.push(controller)
        @inactiveControllers.splice(i, 1)

  removeAllFighters: ()->
    $(".bottombar").empty()
    @playerHudElements=[]
    for fighter in @players
      @remove(fighter)
    @players = []
    for activeController in @activeControllers
      activeController.active = false
      @inactiveControllers.push(activeController)
    @activeControllers = []
    #TODO: Incomplete

  updateHUD: ()->
    for i in [0...@players.length]
      @playerHudElements[i].text(Math.floor(@players[i].damage)+"%")
        .css("color", Utils.damageToCSS(@players[i].damage))

  getPlayerColor: (index)->
    return switch index
      when 0 then new THREE.Color(0xff0000)
      when 1 then new THREE.Color(0x0000ff)
      when 2 then new THREE.Color(0xffff00)
      when 3 then new THREE.Color(0x00bb00)
      when 4 then new THREE.Color(0xff8800)
      when 5 then new THREE.Color(0x00ffff)
      when 6 then new THREE.Color(0xff00ff)
      when 7 then new THREE.Color(0x8800ff)
      else new THREE.Color(Math.round(Math.random() * 0xffffff))
  @CAMERA_SHAKE_K: 0.28
  @CAMERA_SHAKE_DECAY: 0.75

