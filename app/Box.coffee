# A general purpose box to serve as a hitbox.
module.exports = (@size = new THREE.Vector3())->
  THREE.Object3D.call(this)
  @debugBox = new THREE.Mesh(new THREE.BoxGeometry(@size.x,@size.y,.1), new THREE.MeshNormalMaterial())
  @add(@debugBox)
  return

module.exports:: = Object.create(THREE.Object3D::)

module.exports::intersects = (oBox)->
  return
  