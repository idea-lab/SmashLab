Entity = require("Entity")
Stage = require("Stage")
Box = require("Box")
module.exports = class TestProjectile extends Entity
  @START_POSITION: new THREE.Vector3(0.6, 1.1, 0)
  @IMAGE_MAP: THREE.ImageUtils.loadTexture("images/Test3Projectile.png")
  @INITIAL_SCALE: 0.5
  @ADDITIONAL_SCALE: 1
  @PROJECTILE_LIFETIME: 100
  @BASE_VELOCITY: 6
  @VELOCITY_SCALING: 6
  constructor: (@fighter, @charge)->
    super
    @lifetime = TestProjectile.PROJECTILE_LIFETIME
    @projectileSprite = new THREE.Sprite(new THREE.SpriteMaterial(map:TestProjectile.IMAGE_MAP))

    @projectileSprite.scale.set(1, 1, 1).multiplyScalar(TestProjectile.INITIAL_SCALE + TestProjectile.ADDITIONAL_SCALE * @charge)
    @add(@projectileSprite)

    # Proper placement, part 1
    @position.copy(TestProjectile.START_POSITION)

    # Turn around the projectile
    @facingRight = @fighter.facingRight
    @velocity.set(TestProjectile.BASE_VELOCITY + @charge * TestProjectile.VELOCITY_SCALING, 0, 0)
    if not @facingRight
      @position.x*=-1
      @velocity.x*=-1
      # This line makes the hitboxes work
      @rotation.y = Math.PI

    # Proper placement, part 2
    @position.add(@fighter.position)

    # Setup hitboxes
    mainHitbox = new Box(
      active: true
      size: [1 * @projectileSprite.scale.x, 1 * @projectileSprite.scale.y]
      position: [0, 0]
      angle: 0.5
      knockback: 5  + 5 * @charge
      knockbackScaling: 10
      damage: 5 + @charge * 15
      freezeTime: 7 + 15 * @charge
      debug: true
      owner: @fighter
    )
    @add(mainHitbox)
    @hitBoxes.push(mainHitbox)
    @collisionBoxes.push(mainHitbox)

  resolveCollision: (box, entity, deltaTime)->
    if entity instanceof Stage
      @lifetime = 0
  giveDamage: ()->
    @lifetime = 0