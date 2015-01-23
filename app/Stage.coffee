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

  @add(new Fighter())
  @add(new Fighter({controller: new KeyboardControls({
    upKey: 87
    downKey: 83
    leftKey: 65
    rightKey: 68
    attackKey: 70
    specialKey: 71
  })}))
  
  # TODO: Clean it up!
  loader = new THREE.JSONLoader()
  loader.load("models/Stage.json", (geometry)=>
    mesh=new THREE.Mesh(geometry,new THREE.MeshNormalMaterial())
    @add(mesh)
  )
  @orbitcontrols = new THREE.OrbitControls(@camera)
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
        # Go through hitboxes
        for target in @children when target instanceof Fighter
          if hitbox.intersects(target.box) and not (target in hitbox.alreadyHit)
            console.log("GO")
            hitbox.alreadyHit.push(target)
            target.hurt(hitbox)
  
  # - Update animations

Stage::resize = ->
  @camera.aspect = @game.width/@game.height
  @camera.fov = @fov
  @camera.updateProjectionMatrix()