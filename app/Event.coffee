# An event that occurs within a move.
# Typically, the turning on or off of hitboxes.
Event = module.exports = (options)->
  @callback = options.callback
  @time = options.time
  @occurred = false

Event::trigger = ()->
  if not @occurred
    @callback.call(this)
    @occurred = true
Event::reset = ()->
  @occurred = false
