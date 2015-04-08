tempVector = new THREE.Vector3()
module.exports = class Entity extends THREE.Object3D
  constructor: ()->
    super()
    # Boxes used for object collision
    @collisionBoxes = []
    # Boxes used for damaging others
    @hitBoxes = []
    @velocity = new THREE.Vector3()
    @lifetime = null
    @frozen = 0
  
  update: (deltaTime)->
    if @frozen>0
      @frozen = Math.max(@frozen - deltaTime, 0)
      return
    if @lifetime?
      @lifetime -= deltaTime

  applyVelocity: (deltaTime)->
    if @frozen > 0
      return
    tempVector.copy(@velocity).multiplyScalar(deltaTime / 60)
    @position.add(tempVector)

  resolveCollision: (thisBox, otherBox, otherEntity, deltaTime)->

  takeDamage: (hitbox, entity)->

  giveDamage: (hitbox, target)->
