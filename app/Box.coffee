# A general purpose box to serve as a hitbox.
tempVector = new THREE.Vector3()
tempVector2 = new THREE.Vector3()

# Beware of security issues and other strange things that could occur
returnVector = new THREE.Vector3()

Box = module.exports = (@size = new THREE.Vector3())->
  THREE.Object3D.call(this)
  @debugBox = new THREE.Mesh(new THREE.BoxGeometry(@size.x,@size.y,.1), new THREE.MeshNormalMaterial())
  @add(@debugBox)
  @debugBox.visible=false
  return

Box:: = Object.create(THREE.Object3D::)
Box::constructor = Box

# Returns whether or not the current box intersects the provided box
Box::intersects = (otherBox)->
  tempVector.setFromMatrixPosition(@matrixWorld)
  tempVector2.setFromMatrixPosition(otherBox.matrixWorld)
  # Find vector from one center of box to the other center
  tempVector.sub(tempVector2)
  # If the distance is less than the sum of the "radii", the boxes intersect.
  return Math.abs(tempVector.x)*2<=@size.x+otherBox.size.x and
    Math.abs(tempVector.y)*2<=@size.y+otherBox.size.y

# Returns a vector describing the change in position the current dynamic box
# needs to make in order to stop colliding with the provided, stationary box
# NOTE: Only works with static boxes wider than they are tall.
# NOTE: It is assumed that the two boxes are intersecting beforehand.
Box::resolveCollision = (staticBox)->
  tempVector.setFromMatrixPosition(@matrixWorld)
  tempVector2.setFromMatrixPosition(staticBox.matrixWorld)
  # Find vector from one center of box to the other center
  tempVector.sub(tempVector2)
  boundX = staticBox.size.x / 2 +
    (Math.abs(tempVector.y) - staticBox.size.y / 2) * (@size.x/@size.y)
  if tempVector.x<-boundX
    # Move the object LEFT to stop colliding
    return returnVector.set(-@size.x / 2 - staticBox.size.x / 2 - tempVector.x, 0, 0)
  else if tempVector.x>boundX
    # Move the object RIGHT to stop colliding
    return returnVector.set(@size.x / 2 + staticBox.size.x / 2 - tempVector.x, 0, 0)
  else if tempVector.y<0
    # Move the object DOWN to stop colliding
    return returnVector.set(0, -@size.y / 2 - staticBox.size.y / 2 - tempVector.y, 0)
  else
    # Move the object UP to stop colliding
    return returnVector.set(0, @size.y / 2 + staticBox.size.y / 2 - tempVector.y, 0)
  # TODO: not completed
  return
