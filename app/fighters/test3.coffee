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
  airSpeed: 0.1
  airFriction: 0.002

  groundAccel: 0.015
  groundSpeed: 0.2
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
      name: "hurt"
      animation: "Hurt"
    }
    {
      name: "neutral"
      animation: "Neutral"
      activeBoxes: [
        {
          size: [.8, .8]
          angle: 1
          knockback: 4
          knockbackScaling: 20
          damage: 20
          position: [.7, 0.9]
          startTime: 8
          endTime: 3
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
      duration: 40
      activeBoxes: [
        {
          size: [.8, .8]
          angle: 1
          knockback: 4
          knockbackScaling: 20
          damage: 20
          position: [.7, 0.9]
          startTime: 5
          endTime: 15
        }
      ]
    }
  ]
}