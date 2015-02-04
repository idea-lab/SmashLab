# An event that occurs within a move.
# Typically, the turning on or off of hitboxes.
Event = module.exports = (options)->
  @start = options.start
  @startTime = options.startTime
  @startOccurred = false
  @end = options.end or null
  @endTime = options.endTime or 0
  @endOccurred = false
  return

Event::update = (currentTime)->
  if not @startOccurred
    if @startTime <= currentTime
      @start()
      @startOccurred = true
  else if @end? and not @endOccurred
    if @endTime <= currentTime
      @end()
      @endOccurred = true

Event::reset = ()->
  # Clean up!
  if @startOccurred and not @endOccurred
    @end()
  @startOccurred = false
  @endOccurred = false
