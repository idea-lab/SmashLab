Move = require("moves/Move")
Event = require("Event")
module.exports = class TestCounterAttackMove extends Move
  @ATTACKER_FREEZE: 10
  constructor: (@fighter, options)->
    super
    @nextMove = "idle"
    @takeDamageBackup = null
    @freezeInsteadOfDamage = (hitbox, otherFighter)=>
      if otherFighter?.frozen?
        otherFighter.frozen = @fighter.frozen + TestCounterAttackMove.ATTACKER_FREEZE

    @eventSequence = @eventSequence.concat [
      new Event(
        start: ()=>
          # Some stuff moved down below
          @fighter.makeInvulnerable()
          return
        startTime: 1
        end: ()=>
          @fighter.takeDamage = @takeDamageBackup
          @fighter.makeVulnerable()
          return
        endTime: 30
      )
    ]

  trigger: (hitbox, otherFighter)->
    @fighter.frozen = 20
    @freezeInsteadOfDamage(hitbox, otherFighter)
    @takeDamageBackup = @fighter.takeDamage
    @fighter.takeDamage = @freezeInsteadOfDamage

    @hitBoxes[0].damage = hitbox.damage * 1.5
    @hitBoxes[0].knockback = hitbox.knockback * 1.2
    @hitBoxes[0].knockbackScaling = hitbox.knockbackScaling * 1.2
    super