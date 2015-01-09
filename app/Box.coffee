# A general purpose box to serve as a hitbox.
module.exports = (@size = new THREE.Vector3(), @position = new THREE.Vector3())->
  @debugBox = new THREE.Mesh(new THREE.BoxGeometry(@size.x,@size.y,1), new THREE.MeshNormalMaterial())
  @debugBox.position.add(@position)
  return
