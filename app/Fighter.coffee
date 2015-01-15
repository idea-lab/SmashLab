# A moving, figting, controllable character
Box = require("Box")
KeyboardControls = require("controls/KeyboardControls")
module.exports = ()->
  THREE.Object3D.call(this)

  @velocity = new THREE.Vector3()
  @touchingGround = true
  @jumpsRemaining = 2
  
  # These two parameters control the jump. Very handy!
  @airTime = 60 # in frames
  @jumpHeight = 4 # in world units (meters)

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
  # Demo respawn (Please remove when the time comes)
  if @position.y < -10
    @position.set(0, 1, 0)
    @velocity.set(0, 0, 0)
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
        # Just landing. Engage your flaps and reverse your jets
        # because ground control needs to know your heading.
        @touchingGround = true
        @jumpsRemaining = 2
        if @velocity.y < 0
          @velocity.y = 0
        

module.exports::update = ->
  @controller.update()
  @velocity.x = @controller.joystick.x * .1
  # Jump
  if @jumpsRemaining>0 and @controller.jump
    @velocity.y = 4 * @jumpHeight / @airTime
    @touchingGround = false
    @jumpsRemaining--
  
  # Gotta get that gravity
  @velocity.y -= 8 * @jumpHeight / @airTime / @airTime

