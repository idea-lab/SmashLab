# A general purpose box to serve as a hitbox.
tempVector = new THREE.Vector3()
tempVector2 = new THREE.Vector3()

# Beware of security issues and other strange things that could occur
returnVector = new THREE.Vector3()

Utils = require("Utils")
module.exports = class Box extends THREE.Object3D
  constructor: (options)->
    super()
    @size = new THREE.Vector3()


    @debugBox = new THREE.Mesh(new THREE.BoxGeometry(1, 1, 1), new THREE.MeshNormalMaterial(wireframe: true))
    @add(@debugBox)

    @owner = options.owner or null

    @alreadyHit = []

    @collides = true
    # Can this box actively cause damage?
    @active = options.active or false


    @activate = ()=>
      @active = @collides = true
      @debugBox.visible = true

    @deactivate = ()=>
      @active = @collides = false
      @debugBox.visible = false

    @copyFromOptions(options)

  copyFromOptions: (options)->
    Utils.setVectorByArray(@size, options.size)
    Utils.setVectorByArray(@position, options.position)
    
    @debugBox.scale.set(@size.x, @size.y, 0.1)

    # 0 degrees is straight out, -90 is down, and 90 is up. Use radians.
    @angle = options.angle or 0

    # Knockback is in m/s. Why not Newtons? Weight shouldn't make much of a difference.
    @knockback = options.knockback or 0
    # How   much additional knockback the move does at 100%.
    @knockbackScaling = options.knockbackScaling or 0

    # How much damage the box does, if you get hit
    @damage = options.damage or 0

    @freezeTime = options.freezeTime or 0

    @debugBox.visible = options.debug? or false

  # Gets the top left/right vertex of the box.
  getVertex: (right)->
    tempVector.setFromMatrixPosition(@matrixWorld)
    if right
      return returnVector.set(tempVector.x + @size.x / 2, tempVector.y + @size.y / 2, 0)
    else
      return returnVector.set(tempVector.x - @size.x / 2, tempVector.y + @size.y / 2, 0)

  # Returns whether or not the current box contains the provided vector
  contains: (vector)->
    tempVector.setFromMatrixPosition(@matrixWorld)
    return -@size.x / 2 <= vector.x - tempVector.x <= @size.x / 2 and
      -@size.y / 2 <= vector.y - tempVector.y <= @size.y / 2

  # Returns whether or not the current box intersects the provided box
  intersects: (otherBox)->
    tempVector.setFromMatrixPosition(@matrixWorld)
    tempVector2.setFromMatrixPosition(otherBox.matrixWorld)
    # Find vector from one center of box to the other center
    tempVector.sub(tempVector2)
    # If the distance is less than the sum of the "radii", the boxes intersect.
    return Math.abs(tempVector.x) * 2 <= @size.x + otherBox.size.x and
      Math.abs(tempVector.y) * 2 <= @size.y + otherBox.size.y

  # Returns a vector describing the change in position the current dynamic box
  # needs to make in order to stop colliding with the provided, stationary box
  # NOTE: Only works with static boxes wider than they are tall.
  # NOTE: It is assumed that the two boxes are intersecting beforehand.
  resolveCollision: (staticBox)->
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
