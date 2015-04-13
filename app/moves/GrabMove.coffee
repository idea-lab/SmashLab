Move = require("moves/Move")
Fighter = require("Fighter")
module.exports = class GrabMove extends Move
  constructor: (@fighter, options)->
    super
    @duration = 50
    @triggerableMoves = @triggerableMoves.concat [
      "holdingmove"
    ]
    @hitBoxes[0].collide = (target)=>
      if target.initialInvulnerability is 0
        @fighter.grabbing = target
        target.trigger("held", @fighter)
        @request("hold", 100)
        return true
    @nextMove = "idle"
