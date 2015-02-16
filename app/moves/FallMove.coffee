AerialMove = require("moves/AerialMove")
module.exports = class FallMove extends AerialMove
  constructor: (@fighter, options)->
    super
    @triggerableMoves = @triggerableMoves.concat [
      "jump"
      "ledgegrab"
    ]
