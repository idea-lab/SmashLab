# A fixed-length sequence of events which the user can trigger, but loses most
# control during.
Event = require("Event")
Utils = require("Utils")
Box = require("Box")
Move = module.exports = (@fighter, options)->
  # Link together fighter mesh animations and the move
  @name = options.name

  @animation = new THREE.Animation(
    @fighter.mesh,
    Utils.findObjectByName(@fighter.mesh.geometry.animations, options.animation)
  )
  # TODO: Eventually try to remove the clone, if possible.

  # Automatically transition into another move when completed. If null, the animation loops
  @nextMove = null

  # The number of frames the previous animation will blend into the current one
  @blendFrames = 0
  @weight = 0
  # The weight given to the animation (for blending)

  # Other triggerable moves during this move
  @triggerableMoves = []

  # The maximum allowed fighter movement during the move
  @movement = Move.NO_MOVEMENT

  # Number of frames
  @duration = options.duration or Math.round(@animation.data.length*60) or 1
  @currentTime = 1

  # In order for a hitbox to register, it needs to 1. be a member of activeBoxes and
  # 2. be activated by an event in the eventSequence.
  # Take care that a move is only created with options from fighterData.
  # That means all boxes are initialized with arrays instead of Vector3's, etc.
  @eventSequence = []
  @activeBoxes = []
  if options.activeBoxes?
    for boxOptions in options.activeBoxes
      box = new Box(boxOptions)
      @fighter.add(box)
      @activeBoxes.push(box)
      @eventSequence.push(new Event(callback:box.activate, time:box.startTime))
      @eventSequence.push(new Event(callback:box.deactivate, time:box.endTime))

  @reset()
  return

#module.exports:: = THREE.Object3D

# Note: does not update the animation!
Move::update = (deltaTime)->
  for event in @eventSequence when not event.occurred and event.time<=@currentTime
    event.trigger()
  @currentTime += deltaTime
  if @currentTime > @duration
    if @nextMove
      # Stay on ending frame to potentially blend into the next move
      @currentTime = @duration
      @animation.stop()
      return @nextMove
    else
      # Loop
      @currentTime = 1 + (@currentTime-1) % @duration
      @animation.play(0, 0)
  # Continue moving
  return @name

# Syncs values in move to its associated animation
# UGH - I've been solving this bug for hours
# I finally found the solution: all blend weights need
# to be reset BEFORE ANY are updated.
Move::preUpdateAnimation = ()->
  @animation.resetBlendWeights()

Move::updateAnimation = ()->
  @animation.currentTime = (@currentTime-1)/60
  @animation.weight = @weight
  @animation.update(1/60)

Move::trigger = ()->
  @animation.play(0, 0)

Move::animationReset = ()->
  @currentTime = 1
  @weight = 0
  @animation.reset()

Move::reset = ()->
  for box in @activeBoxes
    box.deactivate()
    box.alreadyHit = [] # TODO: more efficient?
  for event in @eventSequence
    event.reset()

Move.NO_MOVEMENT = 0
Move.DI_MOVEMENT = 1
Move.FULL_MOVEMENT = 2 # Includes air movement
