SpecialAttackMove = require("moves/SpecialAttackMove")
Event = require("Event")
module.exports = class TestCounterMove extends SpecialAttackMove
  constructor: (@fighter, options)->
    super
    @takeDamageBackup = null
    @rerouteDamage = (hitbox, otherFighter)=>
      # TODO: DRY up all this code (appears in the fighter class)
      if otherFighter?.smashCharge?
        smashChargeFactor = 1 + otherFighter.smashCharge*.2
      else
        smashChargeFactor = 1
      damage = hitbox.damage * smashChargeFactor

      @fighter.facingRight = hitbox.owner.position.x > @fighter.position.x
      @fighter.trigger("testcounterattack", hitbox, otherFighter)

    @nextMove = "idle"
    @eventSequence = @eventSequence.concat [
      new Event(
        start: ()=>
          @takeDamageBackup = @fighter.takeDamage
          @fighter.takeDamage = @rerouteDamage
          return
        startTime: 1
        end: ()=>
          @fighter.takeDamage = @takeDamageBackup
          return
        endTime: 30
      )
    ]
