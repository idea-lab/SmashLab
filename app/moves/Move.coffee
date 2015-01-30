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
  @nextMove = "idle"

  # The next move that the current move would immediately like to trigger
  @triggerNextPriority = -Infinity
  @triggerNext = null

  # The number of frames the previous animation will blend into the current one
  @blendFrames = 0
  @weight = 0
  # The weight given to the animation (for blending)

  # Other triggerable moves during this move
  @triggerableMoves = []

  # The maximum allowed fighter movement during the move
  @movement = Move.NO_MOVEMENT

  @animationDuration = Math.round(@animation.data.length*60)
  # Number of frames
  @duration = options.duration or @animationDuration
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
      @eventSequence.push(new Event(callback:box.activate, time:boxOptions.startTime))
      @eventSequence.push(new Event(callback:box.deactivate, time:boxOptions.endTime))

  @reset()
  return

#module.exports:: = THREE.Object3D

# Note: does not update the animation!
Move::update = (deltaTime)->
  for event in @eventSequence when not event.occurred and event.time<=@currentTime
    event.trigger()
  @currentTime += deltaTime
  if @currentTime > @duration
    if @nextMove?
      # Stay on ending frame to potentially blend into the next move
      @currentTime = @duration
      # DON'T DARE STOP THE MOVE - CAUSES WEIGHTS TO STOP WORKING
      @triggerMove(@nextMove)
    else
      # Loop
      @currentTime = 1 + (@currentTime-1) % @duration
      @animation.play(0, 0)
  # Continue moving

# Syncs values in move to its associated animation
# UGH - I've been solving this bug for hours
# I finally found the solution: all blend weights need
# to be reset BEFORE ANY are updated.
Move::preUpdateAnimation = ()->
  @animation.resetBlendWeights()

Move::updateAnimation = ()->
  # TODO: Factor in animationDuration to prevent false times
  @animation.currentTime = (@currentTime-1)/60
  @animation.weight = @weight
  @animation.update(0)

Move::trigger = ()->
  @triggerNext = null
  @triggerNextPriority = -Infinity
  @animation.play(0, 0)

# Request to trigger the next move with a given priority
Move::triggerMove = (name, priority = 0)->
  if priority > @triggerNextPriority
    @triggerNextPriority = priority
    @triggerNext = name

Move::animationReset = ()->
  @animation.reset()

Move::reset = ()->
  @currentTime = 1
  for box in @activeBoxes
    box.deactivate()
    box.alreadyHit = [] # TODO: more efficient?
  for event in @eventSequence
    event.reset()

Move.NO_MOVEMENT = 0
Move.DI_MOVEMENT = 1
Move.FULL_MOVEMENT = 2 # Includes air movement
