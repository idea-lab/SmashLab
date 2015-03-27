Move = require("moves/Move")
Event = require("Event")
TestProjectile = require("../projectiles/TestProjectile")
module.exports = class TestFireMove extends Move
  constructor: (@fighter, options)->
    super
    @duration = 50
    @nextMove = "idle"
    @projectileCharge = 0
    @eventSequence = @eventSequence.concat [
      new Event(
        start: ()=>
          newProjectile = new TestProjectile(@fighter, @projectileCharge)
          # Ghost collision in center if not for the next line
          newProjectile.updateMatrixWorld()
          @fighter.stage.add(newProjectile)
          return
        startTime: 10
      )
    ]

  trigger: (charge)->
    @projectileCharge = charge
    super

  update: (deltaTime)->
    super

