# A general purpose box to serve as a hitbox.
tempVector = new THREE.Vector3()
tempVector2 = new THREE.Vector3()

# Beware of security issues and other strange things that could occur
returnVector = new THREE.Vector3()

Utils = require("Utils")
Box = module.exports = (options)->
  THREE.Object3D.call(this)
  @size = Utils.setVectorByArray(new THREE.Vector3(), options.size)

  Utils.setVectorByArray(@position, options.position)

  @debugBox = new THREE.Mesh(new THREE.BoxGeometry(@size.x,@size.y,.1), new THREE.MeshNormalMaterial())
  @add(@debugBox)

  # 0 degrees is straight out, -90 is down, and 90 is up. Use radians.
  @angle = options.angle or 0

  # Knockback is in m/s. Why not Newtons? Weight shouldn't make much of a difference.
  @knockback = options.knockback or 0
  # How much additional knockback the move does at 100%.
  @knockbackScaling = options.knockbackScaling or 0

  # How much damage the box does, if you get hit
  @damage = options.damage or 0

  # How much the current box has been charged by a smash
  @smashCharge = 0

  @alreadyHit = []
  # Can this box actively cause damage?
  @active = false

  @debugBox.visible = false

  @activate = ()=>
    @active = true
    @debugBox.visible = true

  @deactivate = ()=>
    @active = false
    @debugBox.visible = false

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
