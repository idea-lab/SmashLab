# A fixed-length sequence of events which the user can trigger, but loses most
# control during.
Event = require("Event")
Utils = require("Utils")
Box = require("Box")
module.exports = class Move
  constructor: (@fighter, options)->
    # Link together fighter mesh animations and the move
    if not options?
      console.warn("A move does not appear in the character JSON.")
      return

    @name = options.name

    animationObject = Utils.findObjectByName(@fighter.mesh.geometry.animations, options.animation)
    if animationObject?
      @animation = then new THREE.Animation(
        @fighter.mesh,
        animationObject
      )
      @animationDuration = Math.round(@animation.data.length * 60)
      #console.log(@name, @duration)

    else if options.animation isnt false
      @animation = null
      console.warn("#{@name} does not have an associated animation")
      @animationDuration = null

    @lastBonePosition = 0
    @changeInPosition = 0
    # TODO: Eventually try to remove the clone, if possible.

    # Automatically transition into another move when completed. If null, the animation loops
    @nextMove = null

    # The next move that the current move would immediately like to trigger
    @triggerNextPriority = -Infinity
    @triggerNext = null
    @triggerArguments = []

    @duration = @animationDuration or 20
    # The number of frames the previous animation will blend into the current one
    @blendFrames = 0
    @weight = 0
    # The weight given to the animation (for blending)

    # Other triggerable moves during this move
    @triggerableMoves = []

    # The maximum allowed fighter movement during the move
    @movement = Move.NO_MOVEMENT

    # Whether or not the fighter's movement during the animation will actually move the fighter
    # E.g. Rolling, dash attacking
    @allowAnimatedMovement = false

    @eventSequence = []
    @hitBoxes = []
    # Number of frames
    @currentTime = 1
    @active = false

    # Stop the character from falling off the stage
    @stopAtLedges = false
    
    @copyFromOptions(options)

    @reset()

  copyFromOptions: (options)->
    # In order for a hitbox to register, it needs to 1. be a member of hitBoxes and
    # 2. be activated by an event in the eventSequence.
    # Take care that a move is only created with options from fighterData.
    # That means all boxes are initialized with arrays instead of Vector3's, etc.
    @duration = options.duration or @duration
    @allowAnimatedMovement = options.allowAnimatedMovement or @allowAnimatedMovement
    @stopAtLedges = options.stopAtLedges or @stopAtLedges

    if options.hitBoxes?
      for i in [0...options.hitBoxes.length]
        boxOptions = options.hitBoxes[i]
        if @hitBoxes[i]?
          box = @hitBoxes[i]
          box.copyFromOptions(boxOptions)
        else
          box = new Box(boxOptions)
          @fighter.add(box)
          box.owner = @fighter
          @hitBoxes.push(box)
        eventOptions = {
          start: box.activate
          startTime: boxOptions.startTime
          end: box.deactivate
          endTime: boxOptions.endTime
        }
        if @eventSequence[i]?
          @eventSequence[i].copyFromOptions(eventOptions)
        else
          @eventSequence.push(new Event(eventOptions))


  # Note: does not update the animation!
  update: (deltaTime)->
    for event in @eventSequence
      event.update(@currentTime)
    @currentTime += deltaTime
    if @currentTime > @duration
      if @nextMove?
        # Stay on ending frame to potentially blend into the next move
        @currentTime = @duration
        # DON'T DARE STOP THE MOVE - CAUSES WEIGHTS TO STOP WORKING
        @request(@nextMove)
    # Continue moving

  # Syncs values in move to its associated animation
  # UGH - I've been solving this bug for hours
  # I finally found the solution: all blend weights need
  # to be reset BEFORE ANY are updated.
  preUpdateAnimation: ()->
    if @animation?
      @animation.resetBlendWeights()

  updateAnimation: ()->
    if @animation?
      # Sync those values
      @animation.currentTime = (@currentTime - 1) / 60
      #console.log @name, @currentTime, @animation.currentTime, @animation.data.length
      @animation.weight = @weight
      baseBone = @animation.root.children[0]
      beforeBonePosition = baseBone.position.z
      @animation.update(0)
      # This is quite important for animated rolling and dash attacks - moves the fighter based on the movement
      # of the root bone.
      if @allowAnimatedMovement
        if @active
          changeInPosition = baseBone.position.z - @lastBonePosition
          @lastBonePosition = baseBone.position.z
          @fighter.position.x += if @fighter.facingRight then changeInPosition else -changeInPosition
        # As if the update didn't touch the bone position at all.
        baseBone.position.z = beforeBonePosition

  trigger: ()->
    @active = true
    @triggerNext = null
    @triggerNextPriority = -Infinity
    @currentTime = 1
    @lastBonePosition = 0
    if @animation?
      @animation.play(0, 0)

  # Request to trigger the next move with a given priority
  request: (name, priority = 0, args...)->
    if priority > @triggerNextPriority
      @triggerNextPriority = priority
      @triggerNext = name
      @triggerArguments = args or []

  animationReset: ()->
    if @animation?
      @animation.reset()

  reset: ()->
    if @active
      @active = false
      for box in @hitBoxes
        box.alreadyHit = [] # TODO: more efficient?
      for event in @eventSequence
        event.reset()

  @NO_MOVEMENT: 0
  @DI_MOVEMENT: 1
  @FULL_MOVEMENT: 2 # Includes air movement
