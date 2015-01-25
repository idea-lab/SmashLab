# A fixed-length sequence of events which the user can trigger, but loses most
# control during.
Move = module.exports = (@fighter, options)->
  # Number of frames
  @length = 40
  @currentTime = 0
  # In order for a hitbox to register, it needs to 1. be a member of activeBoxes and 2. be activated by an event in the eventSequence.
  @activeBoxes = options.activeBoxes or []
  @eventSequence = options.eventSequence  or []
  return

#module.exports:: = THREE.Object3D

Move::update = (deltaTime)->
  for event in @eventSequence when not event.occurred and event.time<=@currentTime
    event.trigger()
  @currentTime += deltaTime
  if @currentTime > @length
    # End the move
    @reset()
    return null
  # Continue moving
  return this


Move::reset = ()->
  @currentTime = 0
  for box in @activeBoxes
    box.deactivate()
    box.alreadyHit = [] # TODO: more efficient?
  for event in @eventSequence
    event.reset()
