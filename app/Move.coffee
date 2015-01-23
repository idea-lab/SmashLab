# A fixed-length sequence of events which the user can trigger, but loses most
# control during.
Move = module.exports = ()->
  @length = 60
  @currentTime = 0
  @activeBoxes = []
  @eventSequence = []
  return
  
#module.exports:: = THREE.Object3D

Move::update = ()->
  @currentTime++
  if @currentTime > @length
    return true
  return false
    

Move::reset = ()->
  @currentTime = 0