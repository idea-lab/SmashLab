#Contains the stage and fighters, and updates the fight.
Fighter = require("Fighter")
Box = require("Box")
module.exports = (@game) ->
  THREE.Scene.call(this)
  @fov = 45
  @camera = new THREE.PerspectiveCamera(1,1,1,100)
  @camera.position.set(0, 0, 10)
  @add(@camera)
  console.log(this)
  @resize()
  
  #Add hitboxes and fighters
  @hitboxes=[new Box(new THREE.Vector3(10,.5), new THREE.Vector3(0,-.25))]
  @fighters=[new Fighter()]
  @add(@hitboxes[0].debugBox)
  @add(@fighters[0])
  
  @orbitcontrols = new THREE.OrbitControls(@camera)
  @orbitcontrols.damping = 0.2
  
  return

module.exports::=THREE.Scene::

module.exports::update = ->
  @orbitcontrols.update()

module.exports::resize= ->
  @camera.aspect = @game.width/@game.height
  @camera.fov = @fov
  @camera.updateProjectionMatrix()

