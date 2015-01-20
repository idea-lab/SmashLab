# A fixed-length sequence of events which the user can trigger, but loses most
# control during.
module.exports = ()->
  @length = 60
  @currentTime = 0
  @activeBoxes = []
  

module.exports::update = ()->
  @currentTime++
  if @currentTime > @length
    

module.exports::reset = ()->
  @currentTime = 0