# A box that hurts when you get hit
Box = require("Box")
HitBox = module.exports = (options)->
  Box.apply(this, arguments)
  # 0 degrees is straight out, -90 is down, and 90 is up. Use radians.
  @angle = options.angle or 0

  # Knockback is in m/s. Why not Newtons? Weight shouldn't make much of a difference.
  @knockback = options.knockback or 1
  # How much additional knockback the move does at 100%.
  @knockbackScaling = options.knockbackScaling or 2

  # How much damage the box does, if you get hit
  @damage = options.damage or 3
  return

HitBox:: = Object.create(Box::)
HitBox::constructor = HitBox
