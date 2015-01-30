module.exports = {
  name: "Test player"

  # The exported model's source code URI
  modelSrc: "models/Test 3.json"
  # To be filled in by a loader
  modelJSON: null

  # Physics properties
  airTime: 60 # in frames
  jumpHeight: 3 # in world units (meters)
  maxFallSpeed: 0.12

  airAccel: 0.01
  airSpeed: 0.08
  airFriction: 0.002

  groundAccel: 0.015
  groundSpeed: 0.15
  groundFriction: 0.01

  # The main hitbox
  box: {
    size: [.5, 1.86]
    position: [0, 0.93]
  }
  # The list of moves
  moves: [
    # Pay attentiton to the move names!
    # The names help link pre-made behaviors
    # to the moves and animations
    {
      name: "idle"
      animation: "Idle"
    }
    {
      name: "walk"
      animation: "Walk"
    }
    {
      name: "jump"
      animation: "Jump"
    }
    {
      name: "fall"
      animation: "Fall"
    }
    {
      name: "land"
      animation: "Land"
    }
    {
      name: "hurt"
      animation: "Hurt"
    }
    {
      name: "neutral"
      animation: "Neutral"
      activeBoxes: [
        {
          size: [.6, .6]
          angle: 1
          knockback: 2
          knockbackScaling: 10
          damage: 5
          position: [.4, 1.3]
          startTime: 1
          endTime: 8
        }
      ]
    }
    {
      name: "sidesmashcharge"
      animation: "Side Smash Charge"
    }
    {
      name: "sidesmash"
      animation: "Side Smash"
      activeBoxes: [
        {
          size: [.8, .8]
          angle: 1
          knockback: 4
          knockbackScaling: 20
          damage: 20
          position: [.5, 0.9]
          startTime: 4
          endTime: 10
        }
      ]
    }
    {
      name: "upsmashcharge"
      animation: "Up Smash Charge"
    }
    {
      name: "upsmash"
      animation: "Up Smash"
      activeBoxes: [
        {
          size: [.9, .9]
          angle: 1.5
          knockback: 4
          knockbackScaling: 20
          damage: 20
          position: [0, 1.7]
          startTime: 8
          endTime: 15
        }
      ]
    }
    {
      name: "neutralaerial"
      animation: "Knee of Fury"
      activeBoxes: [
        {
          size: [.85, .85]
          angle: 1
          knockback: 5
          knockbackScaling: 10
          damage: 10
          # Used blender's 3D cursor.
          # How convenient!
          position: [.38, 0.67]
          startTime: 10
          endTime: 20
        }
      ]
    }
    {
      name: "downaerial"
      animation: "Down Aerial"
      activeBoxes: [
        {
          size: [.8, .8]
          angle: -1.3
          knockback: 6
          knockbackScaling: 12
          damage: 10
          # Used blender's 3D cursor.
          # How convenient!
          position: [0.05, 0.25]
          startTime: 8
          endTime: 16
        }
      ]
    }
  ]
}