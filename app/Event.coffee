# An event that occurs within a move.
# Typically, the turning on or off of hitboxes.
module.exports = class Event
  constructor: (options)->
    @startOccurred = false
    @endOccurred = false
    @copyFromOptions(options)

  copyFromOptions: (options)->
    @start = options.start
    @startTime = options.startTime
    @end = options.end or null
    @endTime = options.endTime or 0

  update: (currentTime)->
    if not @startOccurred
      if @startTime <= currentTime
        @start?()
        @startOccurred = true
        @endOccurred = false
    else if @end? and not @endOccurred
      if @endTime <= currentTime
        @end?()
        @endOccurred = true

  reset: ()->
    # Clean up!
    if @startOccurred and not @endOccurred
      @end?()
    @startOccurred = false
