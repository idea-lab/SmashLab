#A moving, figting, controllable character
Box = require("Box")
KeyboardControls = require("controls/KeyboardControls")
module.exports = ()->
  THREE.Object3D.call(this)
  @box = new Box(new THREE.Vector3(1,1.8),new THREE.Vector3(0,0.9))
  @add(@box.debugBox)
  @controller = new KeyboardControls()
  return

module.exports::=THREE.Object3D::

module.exports::update = ()->
  @controller.update()
  @position.x+=@controller.joystick.x*.1
  @position.y+=@controller.joystick.y*.1
  
