TestProjectile = require("../projectiles/TestProjectile")
SpecialAttackMove = require("moves/SpecialAttackMove")
Controller = require("controller/Controller")
Event = require("Event")
tempVec = new THREE.Vector3()
module.exports = class TestNeutralSpecialMove extends SpecialAttackMove

  @CHARGE_TIME: 180
  constructor: (@fighter, options)->
    super
    @duration = TestNeutralSpecialMove.CHARGE_TIME
    @triggerableMoves = @triggerableMoves.concat [
      "test3fire"
      "idle"
    ]
    @charge = 0
    @nextMove = "idle"
    # NOTE: Next few lines reused in TestProjectile
    @projectileSprite = new THREE.Sprite(new THREE.SpriteMaterial(map:TestProjectile.IMAGE_MAP))
    @projectileSprite.position.copy(TestProjectile.START_POSITION)
    @projectileSprite.visible = false
    @fighter.add(@projectileSprite)
    @eventSequence = @eventSequence.concat [
      new Event(
        start: =>
          @projectileSprite.visible = true
        startTime: 1
        end: =>
          @projectileSprite.visible = false
        endTime: TestNeutralSpecialMove.CHARGE_TIME
      )
    ]

  trigger: ()->
    super
    if @charge is TestNeutralSpecialMove.CHARGE_TIME
      # Fully charged! Release!
      @request("test3fire", 100, @charge/TestNeutralSpecialMove.CHARGE_TIME)
      @charge = 0

  update: (deltaTime)->
    @charge = Math.min(TestNeutralSpecialMove.CHARGE_TIME, @charge + deltaTime)
    # NOTE: Next line reused in TestProjectile
    @projectileSprite.scale.set(1, 1, 1).multiplyScalar(TestProjectile.INITIAL_SCALE + TestProjectile.ADDITIONAL_SCALE * @charge/TestNeutralSpecialMove.CHARGE_TIME)
    if (@fighter.controller.move & Controller.SHIELD)
      # Cancel charging
      @request("idle", 100)
    else if (@fighter.controller.move & Controller.SPECIAL)
      # Release!
      @projectileSprite.visible = false
      @request("test3fire", 100, @charge/TestNeutralSpecialMove.CHARGE_TIME)
      @charge = 0
    else if @charge is TestNeutralSpecialMove.CHARGE_TIME
      # Done charging, put away
      @request("idle", 100)
    super
    