# A moving, figting, controllable character
Box = require("Box")
KeyboardControls = require("controls/KeyboardControls")
module.exports = ()->
  THREE.Object3D.call(this)

  @velocity = new THREE.Vector3()
  @touchingGround = true

  @box = new Box(new THREE.Vector3(1,1.8))
  @box.position.set(0,0.9,0)
  @add(@box)

  mesh=new THREE.Mesh(new THREE.BoxGeometry(1,1.8,1),new THREE.MeshNormalMaterial())
  mesh.position.set(0,0.9,0)
  @add(mesh)

  @controller = new KeyboardControls()
  return

module.exports:: = Object.create(THREE.Object3D::)
module.exports::constructor = module.exports

# Plenty of these methods are explained in Stage.update()
module.exports::applyVelocity = ->
  @position.add(@velocity)
  @updateMatrixWorld()
  @box.updateMatrixWorld()


module.exports::resolveStageCollisions = (stage)->
  @touchingGround = false
  for stageBox in stage.children when stageBox instanceof Box
    if @box.intersects(stageBox)
      #Touching the stage
      resolutionVector = @box.resolveCollision(stageBox)
      @position.add(resolutionVector)
      if resolutionVector.y > 0
        @touchingGround = true

module.exports::update = ->
  @controller.update()
  @velocity.x = @controller.joystick.x * .1
  # Jump
  if @touchingGround and @controller.joystick.y > 0
    @velocity.y = .3
    @touchingGround = false
  
  # Gotta get that gravity
  @velocity.y -= 0.01

