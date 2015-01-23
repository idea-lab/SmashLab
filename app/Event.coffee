# An event that occurs within a move.
# Typically, the turning on or off of hitboxes.
Event = module.exports = (options)->
  console.log(options)
  @callback = options.callback
  @time = options.time
  @occurred = false

Event::trigger = ()->
  if not @occurred
    console.log(@callback)
    @callback.call(this)
    @occurred = true
Event::reset = ()->
  @occurred = false