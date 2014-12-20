#Contains the stage and fighters, and updates the fight.
module.exports = (@game) ->
  THREE.Scene.call(this)
  @fov = 45
  @camera = new THREE.PerspectiveCamera(1,1,1,100)
  @camera.position.set(0, 0, 10)
  @add(@camera)
  @add(@box = new THREE.Mesh(new THREE.BoxGeometry(1,1,1),new THREE.MeshNormalMaterial()))
  console.log(this)
  @resize()
  return

module.exports::=THREE.Scene::

module.exports::update = ->
    @box.rotation.x+=.04
    @box.rotation.y+=.02

module.exports::resize= ->
    @camera.aspect = @game.width/@game.height
    @camera.fov = @fov
    @camera.updateProjectionMatrix()

