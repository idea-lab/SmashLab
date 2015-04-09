tempVector = new THREE.Vector3()
Move = require("moves/Move")
Event = require("Event")
module.exports = class DeadMove extends Move
  constructor: (@fighter, options)->
    super
    @movement = Move.NO_MOVEMENT
    @eventSequence = [
      new Event({
        start: ()=>
          tempVector.copy(@fighter.velocity).normalize().multiplyScalar(0.8)
          @fighter.stage.cameraShake.sub(tempVector)
        startTime: 0
        end: ()=>
          @fighter.respawn()
        endTime: 60
      })
    ]
    @nextMove = null      