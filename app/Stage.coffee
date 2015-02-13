# Contains the stage and fighters, and updates the fight.
Fighter = require("Fighter")
Box = require("Box")
Utils = require("Utils")
Ledge = require("Ledge")
KeyboardController = require("controller/KeyboardController")
GamepadController = require("controller/GamepadController")
tempVector = new THREE.Vector3()
testFighterData = require("fighters/test3")

Stage = module.exports = (@game) ->
  THREE.Scene.call(this)
  @fov = 45
  @camera = new THREE.PerspectiveCamera(1, 1, 1, 100)
  @camera.position.set(0, 0, 10)
  @add(@camera)
  @resize()
  @cameraShakeTime = 0
  @cameraShake = new THREE.Vector3()

  # Add hitboxes
  box = new Box(size: new THREE.Vector3(14, 0.3, 0), position: new THREE.Vector3(0, -0.15, 0))
  @add(box)
  @activeBoxes = [box]

  #Boxes to collide with to avoid falling off the edge
  @ledgeBoxes = []
  ledgeBox = new Box(size: new THREE.Vector3(1, 1 ,0), position: (new THREE.Vector3()).copy(box.getVertex(true)))
  ledgeBox.position.x += 0.5
  ledgeBox.position.y += 0.5
  @ledgeBoxes.push(ledgeBox)
  @add(ledgeBox)

  ledgeBox = new Box(size: new THREE.Vector3(1, 1 ,0), position: (new THREE.Vector3()).copy(box.getVertex(false)))
  ledgeBox.position.x -= 0.5
  ledgeBox.position.y += 0.5
  @ledgeBoxes.push(ledgeBox)
  @add(ledgeBox)

  # Makes it so the ledges work
  box.updateMatrixWorld()
  ledge1 = new Ledge(position: (new THREE.Vector3()).copy(box.getVertex(true)), facingRight: false)
  @add(ledge1)
  ledge2 = new Ledge(position: (new THREE.Vector3()).copy(box.getVertex(false)), facingRight: true)
  @add(ledge2)



  # Safe box - the box in which you aren't immediately KO'ed
  @safebox = new Box(size: new THREE.Vector3(34,20))
  @safebox.position.y = 4
  @add(@safebox)

  # Camera stays in the camera box
  @camerabox = new Box(size: new THREE.Vector3(24,18))
  # @camerabox.debugBox.visible = true
  @camerabox.position.y = 2
  @add(@camerabox)

  # TODO: Remove this eventually
  @loaded = false
  
  @inactiveControllers = [
    # Arrow Keys ZX
    new KeyboardController({
      upKey: 38
      downKey: 40
      leftKey: 37
      rightKey: 39
      attackKey: 90
      shieldKey: 88
    })
    # WASDY7
    new KeyboardController({
      upKey: 87
      downKey: 83
      leftKey: 65
      rightKey: 68
      attackKey: 89
      shieldKey: 55
    })
    # TFGHO0
    new KeyboardController({
      upKey: 84
      downKey: 71
      leftKey: 70
      rightKey: 72
      attackKey: 79
      shieldKey: 48
    })
    # IJKL']
    new KeyboardController({
      upKey: 73
      downKey: 75
      leftKey: 74
      rightKey: 76
      attackKey: 222
      shieldKey: 221
    })
    # HomeEndDeletePageDownNumpad7Slash
    new KeyboardController({
      upKey: 36
      downKey: 35
      leftKey: 46
      rightKey: 34
      attackKey: 103
      shieldKey: 111
    })
    # Numpad8456
  #   new KeyboardController({
  #     upKey: 
  #     downKey: 
  #     leftKey: 
  #     rightKey: 
  #     attackKey: 
  #     shieldKey: 
  #   })
  ]

  @players = []
  @playerHudElements = [] # TODO: Remove!
  
  $.ajax(testFighterData.modelSrc).done (data)=>
    testFighterData.modelJSON = data
    @loaded = true

  window.addEventListener "gamepadconnected", (event)=>
    @inactiveControllers.push(new GamepadController(gamepad: event.gamepad))

  # TODO: Clean it up!
  loader = new THREE.JSONLoader()
  loader.load("models/Stage.json", (geometry)=>
    mesh=new THREE.Mesh(geometry,new THREE.MeshLambertMaterial(shading:THREE.FlatShading))
    @add(mesh)
    directionalLight = new THREE.DirectionalLight(0xffffff, 2)
    directionalLight.position.set(0, 1, 0.5)
    @add(directionalLight)
    hemisphereLight = new THREE.HemisphereLight(0xffffff, 1)
    hemisphereLight.position.set(0, -1, -0.5)
    @add(hemisphereLight)
  )
  @deltaTime = 1
  $(window).on "keydown", (event)=>
    switch event.keyCode
      when 189, 173 then @deltaTime = Math.max(0.1, @deltaTime * 0.9)
      when 187, 61 then @deltaTime = Math.min(2, @deltaTime / 0.9)
  #@orbitcontrols = new THREE.OrbitControls(@camera)
  return

Stage:: = Object.create(THREE.Scene::)
Stage::constructor = Stage

# Updates the entire fight.
Stage::update = ->
  if not @loaded
    return

  @updateInactiveControllers()

  # Update cycle has these events in order:
  # - Apply velocities
  for fighter in @children when fighter instanceof Fighter
    fighter.applyVelocity(@deltaTime)

  # Soft player-player collision
  for fighter in @children when fighter instanceof Fighter
    for otherFighter in @children when otherFighter isnt fighter and otherFighter instanceof Fighter
      if fighter.box.intersects(otherFighter.box)
        if fighter.position.x > otherFighter.position.x
          fighter.position.x += Stage.FIGHTER_SOFT_COLLISION_VELOCITY * @deltaTime
          otherFighter.position.x -= Stage.FIGHTER_SOFT_COLLISION_VELOCITY * @deltaTime
        else
          fighter.position.x -= Stage.FIGHTER_SOFT_COLLISION_VELOCITY * @deltaTime
          otherFighter.position.x += Stage.FIGHTER_SOFT_COLLISION_VELOCITY * @deltaTime

  # - Resolve player-stage collisions and players out of bounds, as well as ledge grab
  for fighter in @children when fighter instanceof Fighter
    fighter.resolveStageCollisions(this)

  # - Update hitboxes and moves, player input, set movement velocity,
  #   controllers, gravity, and the rest of the good stuff
  for fighter in @children when fighter instanceof Fighter
    fighter.update(@deltaTime)
  
  # - Detect hitbox-player collision, set velocities for colliding hitboxes
  #   (velocities will be applied next render)
  for fighter in @children when fighter instanceof Fighter
    if fighter.move
      for hitbox in fighter.move.activeBoxes when hitbox.active
        # Update hitbox
        hitbox.updateMatrixWorld()
        # Go through hitboxes
        for target in @children when target isnt fighter and target instanceof Fighter
          if hitbox.intersects(if target.shielding then target.shieldBox else target.box) and not (target in hitbox.alreadyHit)
            target.hurt(hitbox, fighter)
            hitbox.alreadyHit.push(target)

  @updateHUD()
  @updateCamera()

# Update camera
Stage::updateCamera = ->
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

  maxPositionX = Math.min(maxPositionX, @camerabox.position.x + @camerabox.size.x * 0.5)
  maxPositionY = Math.min(maxPositionY, @camerabox.position.y + @camerabox.size.y * 0.5)
  minPositionX = Math.max(minPositionX, @camerabox.position.x - @camerabox.size.x * 0.5)
  minPositionY = Math.max(minPositionY, @camerabox.position.y - @camerabox.size.y * 0.5)
  
  # Compute where the camera wants to go
  averagePosition = tempVector.set(maxPositionX + minPositionX, maxPositionY + minPositionY, 0).multiplyScalar(0.5)
  averagePosition.z = Math.max(
    (maxPositionY - minPositionY),
    (maxPositionX - minPositionX) / @camera.aspect
  )/2/Math.tan(Math.PI*@camera.fov/180/2)



  # Pull back from camera bounds
  maxZ = Math.min(
    @camerabox.size.y,
    @camerabox.size.x / @camera.aspect
  )/2/Math.tan(Math.PI*@camera.fov/180/2)
  zFactor = 1 - Math.min(1, averagePosition.z/maxZ)
  maxPositionX = @camerabox.position.x + @camerabox.size.x * 0.5 * zFactor
  maxPositionY = @camerabox.position.y + @camerabox.size.y * 0.5 * zFactor
  minPositionX = @camerabox.position.x - @camerabox.size.x * 0.5 * zFactor
  minPositionY = @camerabox.position.y - @camerabox.size.y * 0.5 * zFactor

  averagePosition.x = Math.min(Math.max(averagePosition.x, minPositionX), maxPositionX)
  averagePosition.y = Math.min(Math.max(averagePosition.y, minPositionY), maxPositionY)

  
  # Lerp the camera to the averagePosition
  @camera.position.lerp(averagePosition, 0.1)
  shake = tempVector.copy(@cameraShake)
  @cameraShakeTime+= @deltaTime
  shake.multiplyScalar(0.7 * Math.sin(@cameraShakeTime * 0.5))
  @camera.position.add(shake)
  @cameraShake.multiplyScalar(0.8)

Stage::resize = ->
  @camera.aspect = @game.width/@game.height
  @camera.fov = @fov
  @camera.updateProjectionMatrix()

Stage::updateInactiveControllers = ()->
  for i in [0...@inactiveControllers.length]
    # TODO: Please don't faint while trying to remove this code
    if i >= @inactiveControllers.length
      break
    controller = @inactiveControllers[i]
    controller.update(0)
    if controller.active
      fighter = new Fighter(testFighterData, {
        stage: this,
        color: @getPlayerColor(@players.length),
        controller: controller
      })
      @add(fighter)
      @players.push(fighter)
      hudElement = $("<div class=\"damagepercent\"></div>")
      $(".bottombar").append(hudElement)
      hudElement.css("border-bottom-color", "rgba("+Utils.colorToCSS(fighter.color)[4..-2]+", 0.5)")
      @playerHudElements.push(
        hudElement
      )
      @inactiveControllers.splice(i, 1)

Stage::updateHUD = ()->
  for i in [0...@players.length]
    @playerHudElements[i].text(Math.floor(@players[i].damage))
      .css("color", Utils.damageToCSS(@players[i].damage))

Stage::getPlayerColor = (index)->
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

Stage.FIGHTER_SOFT_COLLISION_VELOCITY = 0.001