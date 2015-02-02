# An object representing an edge
Utils = require("Utils")
Ledge = module.exports = (options)->
  THREE.Object3D.call(this)
  Utils.setVectorByArray(@position, options.position)

  # The facing the fighter will take when grabbing the ledge
  @facingRight = options.facingRight or false
  # The current fighter attached to the ledge
  @fighter = null

Ledge:: = Object.create(THREE.Object3D::)
Ledge::constructor = Ledge
