#A moving, figting, controllable character
Box = require("Box")
module.exports = ()->
  THREE.Object3D.call(this)
  @box = new Box(new THREE.Vector3(1,1.8),new THREE.Vector3(0,0.9))
  @add(@box.debugBox)
  return

  
module.exports::=THREE.Object3D::
