# Contains the stage and fighters, and updates the fight.
Fighter = require("Fighter")
Box = require("Box")
KeyboardControls = require("controls/KeyboardControls")
Stage = module.exports = (@game) ->
  THREE.Scene.call(this)
  @fov = 45
  @camera = new THREE.PerspectiveCamera(1,1,1,100)
  @camera.position.set(0, 0, 10)
  @add(@camera)
  @resize()

  # Add hitboxes and fighters
  box=new Box(size: new THREE.Vector3(14,.3))
  box.position.set(0,-0.15,0)
  @add(box)

  @add(new Fighter({controller: new KeyboardControls({
    upKey: 38
    downKey: 40
    leftKey: 37
    rightKey: 39
    attackKey: 16
    specialKey: 34 #Page down
  })}))
  @add(new Fighter({controller: new KeyboardControls({
    upKey: 87
    downKey: 83
    leftKey: 65
    rightKey: 68
    attackKey: 81
    specialKey: 69
  })}))
  @add(new Fighter({controller: new KeyboardControls({
    upKey: 84
    downKey: 71
    leftKey: 70
    rightKey: 72
    attackKey: 82
    specialKey: 89
  })}))
  @add(new Fighter({controller: new KeyboardControls({
    upKey: 73
    downKey: 75
    leftKey: 74
    rightKey: 76
    attackKey: 85
    specialKey: 79
  })}))
  
  # TODO: Clean it up!
  loader = new THREE.JSONLoader()
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
  # Update cycle has these events in order:
  # - Apply velocities
  for fighter in @children when fighter instanceof Fighter
    fighter.applyVelocity()

  # - Resolve player-stage collisions
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
            hitbox.alreadyHit.push(target)
            target.hurt(hitbox)
  
  # Update camera
  # maxPosition = new THREE.Vector3(-Infinity, -Infinity, 0) # TODO: Make temporary
  # minPosition = new THREE.Vector3(Infinity, Infinity, 0) # TODO: Make temporary
  maxPosition = new THREE.Vector3() # TODO: Make temporary
  minPosition = new THREE.Vector3() # TODO: Make temporary
  worldPosition = new THREE.Vector3()# TODO: Make temporary
  for fighter in @children when fighter instanceof Fighter
    worldPosition.setFromMatrixPosition(fighter.box.matrixWorld)
    maxPosition.x = Math.max(maxPosition.x, worldPosition.x)
    maxPosition.y = Math.max(maxPosition.y, worldPosition.y)
    minPosition.x = Math.min(minPosition.x, worldPosition.x)
    minPosition.y = Math.min(minPosition.y, worldPosition.y)
  characterMargin = 5
  maxPosition.x+=characterMargin
  maxPosition.y+=characterMargin
  minPosition.x-=characterMargin
  minPosition.y-=characterMargin
  averagePosition = maxPosition.add(minPosition).multiplyScalar(.5)
  targetCameraPosition = new THREE.Vector3() # TODO: Make temporary
  targetCameraPosition.copy(averagePosition)
  targetCameraPosition.z = (maxPosition.x-minPosition.x)*1.2

  targetCameraPosition.multiplyScalar(.1)
  @camera.position.multiplyScalar(.9).add(targetCameraPosition)
  # - Update animations

Stage::resize = ->
  @camera.aspect = @game.width/@game.height
  @camera.fov = @fov
  @camera.updateProjectionMatrix()