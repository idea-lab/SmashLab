# Contains the stage and fighters, and updates the fight.
Fighter = require("Fighter")
Box = require("Box")
Utils = require("Utils")
Ledge = require("Ledge")
KeyboardControls = require("controls/KeyboardControls")
tempVector = new THREE.Vector3()
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
  box=new Box(size: new THREE.Vector3(14, 0.3, 0), position: new THREE.Vector3(0, -0.15, 0))
  @add(box)
  @activeBoxes = [box]

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
  
  testFighterData = require("fighters/test3")
  loader = new THREE.JSONLoader()
  @players = [false, false, false, false]
  $.ajax(testFighterData.modelSrc).done (data)=>
    testFighterData.modelJSON = data
    @add(window.player=@players[0]=new Fighter(testFighterData, stage: this, color : new THREE.Color(0xff0000), controller : new KeyboardControls({
      upKey: 38
      downKey: 40
      leftKey: 37
      rightKey: 39
      attackKey: 16
      specialKey: 34 #Page down
    })))
    @loaded = true
  $(window).on "keydown", (event)=>
    switch event.keyCode
      when 50#Number 2
        if not @players[1]
          @add(@players[1] = new Fighter(testFighterData, stage: this, color: new THREE.Color(0x0000ff), controller: new KeyboardControls({
            upKey: 87
            downKey: 83
            leftKey: 65
            rightKey: 68
            attackKey: 81
            specialKey: 69
          })))
      when 51#Number 3
        if not @players[2]
          @add(@players[2] = new Fighter(testFighterData, stage: this, color: new THREE.Color(0xffff00), controller: new KeyboardControls({
            upKey: 73
            downKey: 75
            leftKey: 74
            rightKey: 76
            attackKey: 85
            specialKey: 79
          })))
      when 52#Number 4
        if not @players[3]
          @add(@players[3] = new Fighter(testFighterData, stage: this, color: new THREE.Color(0x00ff00), controller: new KeyboardControls({
            upKey: 84
            downKey: 71
            leftKey: 70
            rightKey: 72
            attackKey: 82
            specialKey: 89
          })))

  # TODO: Clean it up!
  loader.load("models/Stage.json", (geometry)=>
    mesh=new THREE.Mesh(geometry,new THREE.MeshNormalMaterial())
    @add(mesh)
  )
  #@orbitcontrols = new THREE.OrbitControls(@camera)
  return

Stage:: = Object.create(THREE.Scene::)
Stage::constructor = Stage

# Updates the entire fight.
Stage::update = ->
  if not @loaded
    return

  # Update cycle has these events in order:
  # - Apply velocities
  for fighter in @children when fighter instanceof Fighter
    fighter.applyVelocity()

  # - Resolve player-stage collisions and players out of bounds, as well as ledge grab
  for fighter in @children when fighter instanceof Fighter
    fighter.resolveStageCollisions(this)

  # - Update hitboxes and moves, player input, set movement velocity,
  #   controllers, gravity, and the rest of the good stuff
  for fighter in @children when fighter instanceof Fighter
    fighter.update()
  
  # - Detect hitbox-player collision, set velocities for colliding hitboxes
  #   (velocities will be applied next render)
  for fighter in @children when fighter instanceof Fighter
    if fighter.move
      for hitbox in fighter.move.activeBoxes when hitbox.active
        # Update hitbox
        hitbox.updateMatrixWorld()
        # Go through hitboxes
        for target in @children when target isnt fighter and target instanceof Fighter
          if hitbox.intersects(target.box) and not (target in hitbox.alreadyHit)
            target.hurt(hitbox, fighter)
            hitbox.alreadyHit.push(target)
  
  if @players[0]
    $("#player1").text(Math.floor(@players[0].damage))
      .css("border-bottom-color", Utils.colorToCSS(@players[0].color))
  if @players[1]
    $("#player2").text(Math.floor(@players[1].damage))
      .css("border-bottom-color", Utils.colorToCSS(@players[1].color))
  if @players[2]
    $("#player3").text(Math.floor(@players[2].damage))
      .css("border-bottom-color", Utils.colorToCSS(@players[2].color))
  if @players[3]
    $("#player4").text(Math.floor(@players[3].damage))
      .css("border-bottom-color", Utils.colorToCSS(@players[3].color))

  @updateCamera()

# Update camera
Stage::updateCamera = ->
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
  characterMargin = 4

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
  @cameraShakeTime++
  shake.multiplyScalar(0.7 * Math.sin(@cameraShakeTime * 0.5))
  @camera.position.add(shake)
  @cameraShake.multiplyScalar(.8)

Stage::resize = ->
  @camera.aspect = @game.width/@game.height
  @camera.fov = @fov
  @camera.updateProjectionMatrix()