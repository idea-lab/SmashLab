# An object representing an edge
Utils = require("Utils")
module.exports = class Ledge extends THREE.Object3D
  constructor: (options)->
    super()
    Utils.setVectorByArray(@position, options.position)

    # The facing the fighter will take when grabbing the ledge
    @facingRight = options.facingRight or false
    # The current fighter attached to the ledge
    @fighter = null
