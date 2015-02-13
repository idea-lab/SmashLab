module.exports = {
  name: "Test player"

  # The exported model's source code URI
  modelSrc: "models/Test 3.json"
  # To be filled in by a loader
  modelJSON: null

  # Physics properties
  airTime: 60 # in frames
  jumpHeight: 3 # in world units (meters)
  shortHopHeight: 1.3 # in world units (meters)
  maxFallSpeed: 0.12

  airAccel: 0.01
  airSpeed: 0.08
  airFriction: 0.002

  groundAccel: 0.015
  groundSpeed: 0.12
  groundFriction: 0.01

  dashSpeed: 0.21
  crawlSpeed: 0.06

  # The main hitbox
  box: {
    size: [0.5, 1.86]
    position: [0, 0.93]
  }

  # The box used for grabbing the edge
  ledgeBox: {
    size: [2.2, 1.5]
    position: [0.1, 1.7]
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
      name: "ledgegrab"
      animation: "Ledge Hang"
    }
    {
      name: "shield"
      animation: "Shield"
    }
    {
      name: "roll"
      animation: "Roll"
    }
    {
      name: "dodge"
      animation: "Dodge"
    }
    {
      name: "airdodge"
      animation: "Air Dodge"
    }
    {
      name: "stun"
      animation: "Stun"
    }
    {
      name: "dash"
      animation: "Dash"
    }
    {
      name: "dashattack"
      animation: "Dolphin"
      activeBoxes: [
        {
          size: [1.2, 0.5]
          angle: 0
          knockback: 8
          knockbackScaling: 0
          damage: 1
          position: [0.2, 0.25]
          startTime: 10
          endTime: 13
          freezeTime: 8
        }
        {
          size: [1.0, 0.6]
          angle: 0.5
          knockback: 8
          knockbackScaling: 0
          damage: 2
          position: [0.4, 0.25]
          startTime: 13
          endTime: 16
          freezeTime: 8
        }
        {
          size: [0.7, 0.7]
          angle: 1.0
          knockback: 8
          knockbackScaling: 0
          damage: 3
          position: [0.4, 0.7]
          startTime: 16
          endTime: 19
          freezeTime: 8
        }
        {
          size: [0.7, 0.5]
          angle: 1.2
          knockback: 5
          knockbackScaling: 15
          damage: 2
          position: [0.3, 1.2]
          startTime: 19
          endTime: 22
          freezeTime: 15
        }
      ]
    }
    {
      name: "neutral"
      animation: "Neutral"
      activeBoxes: [
        {
          size: [0.6, 0.4]
          angle: .7
          knockback: 2
          knockbackScaling: 7
          damage: 2
          position: [0.4, 1.3]
          startTime: 1
          endTime: 8
        }
      ]
    }
    {
      name: "uptilt"
      animation: "Up Tilt"
      activeBoxes: [
        {
          size: [0.8, 0.8]
          angle: 1.3
          knockback: 5
          knockbackScaling: 12
          damage: 4
          position: [0.1, 1.7]
          startTime: 5
          endTime: 12
        }
      ]
    }
    {
      name: "downtilt"
      animation: "Down Tilt"
      activeBoxes: [
        {
          size: [0.9, 0.7]
          angle: 1.2
          knockback: 2
          knockbackScaling: 15
          damage: 5
          position: [0.8, 0.3]
          startTime: 3
          endTime: 7
        }
      ]
    }
    {
      name: "sidetilt"
      animation: "Side Tilt"
      activeBoxes: [
        {
          size: [0.9, 0.6]
          angle: 0.8
          knockback: 4
          knockbackScaling: 7
          damage: 4
          position: [0.6, 1.3]
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
          size: [0.8, 0.9]
          angle: 1.4
          knockback: 8
          knockbackScaling: 16
          damage: 15
          position: [0, 1.5]
          startTime: 2
          endTime: 10
          freezeTime: 13
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
          size: [1.3, 0.8]
          angle: 0.8
          knockback: 4
          knockbackScaling: 20
          damage: 18
          position: [0.7, 1.2]
          startTime: 9
          endTime: 17
          freezeTime: 14
        }
        {
          size: [0.2, 0.2]
          angle: 0.8
          knockback: 6
          knockbackScaling: 23
          damage: 2
          position: [0.4, 1.2]
          startTime: 11
          endTime: 13
          freezeTime: 4
        }
      ]
    }
    {
      name: "downsmashcharge"
      animation: "Down Smash Charge"
    }
    {
      name: "downsmash"
      animation: "Down Smash"
      activeBoxes: [
        {
          size: [0.8, 0.9]
          angle: 0.7
          knockback: 2
          knockbackScaling: 22
          damage: 14
          position: [0.6, 0.4]
          startTime: 4
          endTime: 12
          freezeTime: 13
        }
        {
          size: [0.8, 0.9]
          angle: Math.PI - 0.7
          knockback: 2
          knockbackScaling: 22
          damage: 14
          position: [-0.6, 0.4]
          startTime: 16
          endTime: 25
          freezeTime: 13
        }
      ]
    }
    {
      name: "neutralaerial"
      animation: "Neutral Aerial"
      activeBoxes: [
        {
          size: [1.5, 0.4]
          angle: Math.PI - 0.5
          knockback: 1
          knockbackScaling: 0
          damage: 1.5
          position: [0, 1.4]
          startTime: 6
          endTime: 9
          freezeTime: 6
        }
        {
          size: [1.5, 0.4]
          angle: 0.5
          knockback: 1
          knockbackScaling: 0
          damage: 1.5
          position: [0, 1.4]
          startTime: 9
          endTime: 12
          freezeTime: 6
        }
        {
          size: [1.5, 0.4]
          angle: 0.5
          knockback: 1
          knockbackScaling: 0
          damage: 1.5
          position: [0, 1.4]
          startTime: 17
          endTime: 21
          freezeTime: 6
        }
        {
          size: [1.5, 0.4]
          angle: Math.PI - 0.8
          knockback: 6
          knockbackScaling: 12
          damage: 2
          position: [0, 1.4]
          startTime: 21
          endTime: 25
          freezeTime: 10
        }
      ]
    }
    {
      name: "forwardaerial"
      animation: "Knee of Fury"
      activeBoxes: [
        {
          size: [1.1, 0.85]
          angle: 0.8
          knockback: 2
          knockbackScaling: 13
          damage: 6
          # Used blender's 3D cursor.
          # How convenient!
          position: [0.6, 0.6]
          startTime: 5
          endTime: 15
        }
        # Sweet! spot
        {
          size: [0.2, 0.2]
          angle: 0.7
          knockback: 4
          knockbackScaling: 26
          damage: 2
          position: [0.28, 0.64]
          startTime: 7
          endTime: 9
          freezeTime: 15
        }
      ]
    }
    {
      name: "backaerial"
      animation: "Back Aerial"
      activeBoxes: [
        {
          size: [1.0, 0.7]
          angle: 2.5
          knockback: 5
          knockbackScaling: 0
          damage: 6
          # Used blender's 3D cursor.
          # How convenient!
          position: [-0.6, 0.4]
          startTime: 7
          endTime: 10
        }
        {
          size: [1.0, 0.7]
          angle: 2.5
          knockback: 5
          knockbackScaling: 10
          damage: 3
          # Used blender's 3D cursor.
          # How convenient!
          position: [-0.6, 0.4]
          startTime: 10
          endTime: 25
        }
      ]
    }
    {
      name: "upaerial"
      animation: "Up Aerial"
      activeBoxes: [
        {
          size: [0.6, 0.6]
          angle: 1.5
          knockback: 4
          knockbackScaling: 15
          damage: 4
          # Used blender's 3D cursor.
          # How convenient!
          position: [0.1, 1.5]
          startTime: 11
          endTime: 16
        }
        {
          size: [0.6, 1.2]
          angle: 1.3
          knockback: 2
          knockbackScaling: 8
          damage: 2
          position: [0.5, 1.0]
          startTime: 2
          endTime: 10
        }
        {
          size: [0.5, 1.0]
          angle: Math.PI - 1.3
          knockback: 2
          knockbackScaling: 8
          damage: 2
          position: [-0.4, 0.9]
          startTime: 12
          endTime: 20
        }
      ]
    }
    {
      name: "downaerial"
      animation: "Down Aerial"
      activeBoxes: [
        {
          size: [0.6, 0.8]
          angle: -1.3
          knockback: 6
          knockbackScaling: 16
          damage: 7
          position: [0.1, 0.25]
          startTime: 8
          endTime: 16
        }
      ]
    }
    {
      name: "crouch"
      animation: "Crouch"
    }
    {
      name: "crawl"
      animation: "Crawl"
    }
  ]
}