#A moving, figting, controllable character
Box = require("Box")
KeyboardControls = require("controls/KeyboardControls")
module.exports = ()->
  THREE.Object3D.call(this)
  @box = new Box(new THREE.Vector3(1,1.8))
  @box.position.set(0,0.9)
  @add(@box)

  mesh=new THREE.Mesh(new THREE.BoxGeometry(1,1.8,1),new THREE.MeshNormalMaterial())
  mesh.position.set(0,0.9,0)
  @add(mesh)

  @controller = new KeyboardControls()
  return

module.exports:: = Object.create(THREE.Object3D::)

module.exports::update = ->
  @controller.update()
  @position.x+=@controller.joystick.x*.1
  @position.y+=@controller.joystick.y*.1
  
