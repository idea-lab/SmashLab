# Contains the stage and fighters, and updates the fight.
Fighter = require("Fighter")
Box = require("Box")
module.exports = (@game) ->
  THREE.Scene.call(this)
  @fov = 45
  @camera = new THREE.PerspectiveCamera(1,1,1,100)
  @camera.position.set(0, 0, 10)
  @add(@camera)
  @resize()

  # Add hitboxes and fighters
  box=new Box(new THREE.Vector3(10,.5))
  box.position.set(0,-0.25,0)
  @add(box)

  @add(new Fighter())

  mesh=new THREE.Mesh(new THREE.BoxGeometry(10,.5,4),new THREE.MeshNormalMaterial())
  mesh.position.set(0,-0.25,0)
  @add(mesh)

  @orbitcontrols = new THREE.OrbitControls(@camera)
  return

module.exports:: = Object.create(THREE.Scene::)
module.exports::constructor = module.exports

# Updates the entire fight.
module.exports::update = ->
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
  
  # - Update animations

module.exports::resize = ->
  @camera.aspect = @game.width/@game.height
  @camera.fov = @fov
  @camera.updateProjectionMatrix()