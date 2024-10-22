module.exports = {
  "name": "Test player",
  "id": "test3",
  "modelSrc": "models/Test 4.json",
  "modelJSON": null,
  "airTime": 50,
  "jumpHeight": 2.5,
  "shortHopHeight": 1.3,
  "maxFallSpeed": 0.14,
  "airAccel": 0.01,
  "airSpeed": 0.08,
  "airFriction": 0.002,
  "groundAccel": 0.03,
  "groundSpeed": 0.12,
  "groundFriction": 0.01,
  "dashSpeed": 0.17,
  "crawlSpeed": 0.06,
  "collisionBoxes": [
    {
      "name": "mainBox",
      "size": [
        0.5,
        1.86
      ],
      "position": [
        0,
        0.93
      ]
    },
    {
      "name": "ledgeBox",
      "collides": false,
      "size": [
        2.2,
        1.5
      ],
      "position": [
        0.1,
        1.7
      ]
    },
    {
      "name": "grabPoint",
      "collides": false,
      "position": [
        0.7,
        1.1
      ]
    }
  ],
  "moves": [
    {
      "name": "idle",
      "animation": "Idle"
    },
    {
      "name": "walk",
      "animation": "Walk"
    },
    {
      "name": "jump",
      "animation": "Jump"
    },
    {
      "name": "fall",
      "animation": "Fall"
    },
    {
      "name": "land",
      "animation": "Land"
    },
    {
      "name": "hurt",
      "animation": "Hurt"
    },
    {
      "name": "ledgegrab",
      "animation": "Ledge Hang"
    },
    {
      "name": "shield",
      "animation": "Shield"
    },
    {
      "name": "roll",
      "animation": "Roll"
    },
    {
      "name": "dodge",
      "animation": "Dodge"
    },
    {
      "name": "airdodge",
      "animation": "Air Dodge"
    },
    {
      "name": "stun",
      "animation": "Stun"
    },
    {
      "name": "dash",
      "animation": "Dash"
    },
    {
      "name": "dashattack",
      "animation": "Dolphin",
      "hitBoxes": [
        {
          "size": [
            1.2,
            0.5
          ],
          "angle": 0,
          "knockback": 1,
          "knockbackScaling": 0,
          "damage": 1,
          "position": [
            0.2,
            0.25
          ],
          "startTime": 10,
          "endTime": 13,
          "freezeTime": 8
        },
        {
          "size": [
            1,
            0.6
          ],
          "angle": 0.5,
          "knockback": 1,
          "knockbackScaling": 0,
          "damage": 2,
          "position": [
            0.4,
            0.25
          ],
          "startTime": 13,
          "endTime": 16,
          "freezeTime": 8
        },
        {
          "size": [
            0.7,
            0.7
          ],
          "angle": 1,
          "knockback": 1,
          "knockbackScaling": 0,
          "damage": 3,
          "position": [
            0.4,
            0.7
          ],
          "startTime": 16,
          "endTime": 19,
          "freezeTime": 8
        },
        {
          "size": [
            0.7,
            0.5
          ],
          "angle": 1.2,
          "knockback": 10,
          "knockbackScaling": 5,
          "damage": 2,
          "position": [
            0.3,
            1.2
          ],
          "startTime": 19,
          "endTime": 22,
          "freezeTime": 15
        }
      ]
    },
    {
      "name": "neutral",
      "animation": "Neutral",
      "hitBoxes": [
        {
          "size": [
            0.6,
            0.4
          ],
          "angle": 0.7,
          "knockback": 1,
          "knockbackScaling": 1,
          "damage": 2,
          "position": [
            0.4,
            1.3
          ],
          "startTime": 1,
          "endTime": 8,
          "captureTime": 8
        }
      ]
    },
    {
      "name": "uptilt",
      "animation": "Up Tilt",
      "hitBoxes": [
        {
          "size": [
            0.8,
            0.8
          ],
          "angle": 1.3,
          "knockback": 6,
          "knockbackScaling": 4,
          "damage": 7,
          "position": [
            0.1,
            1.7
          ],
          "startTime": 5,
          "endTime": 12
        }
      ]
    },
    {
      "name": "downtilt",
      "animation": "Down Tilt",
      "hitBoxes": [
        {
          "size": [
            0.8,
            0.5
          ],
          "angle": 1.2,
          "knockback": 4,
          "knockbackScaling": 4,
          "damage": 7,
          "position": [
            0.8,
            0.3
          ],
          "startTime": 3,
          "endTime": 7
        }
      ]
    },
    {
      "name": "sidetilt",
      "animation": "Side Tilt",
      "hitBoxes": [
        {
          "size": [
            0.9,
            0.6
          ],
          "angle": 0.8,
          "knockback": 4,
          "knockbackScaling": 7,
          "damage": 7,
          "position": [
            0.6,
            1.3
          ],
          "startTime": 4,
          "endTime": 10
        }
      ]
    },
    {
      "name": "upsmashcharge",
      "animation": "Up Smash Charge"
    },
    {
      "name": "upsmash",
      "animation": "Up Smash",
      "hitBoxes": [
        {
          "size": [
            0.8,
            0.9
          ],
          "angle": 1.4,
          "knockback": 18,
          "knockbackScaling": 13,
          "damage": 16,
          "position": [
            0,
            1.5
          ],
          "startTime": 2,
          "endTime": 10,
          "freezeTime": 13
        }
      ]
    },
    {
      "name": "sidesmashcharge",
      "animation": "Side Smash Charge"
    },
    {
      "name": "sidesmash",
      "animation": "Side Smash",
      "hitBoxes": [
        {
          "size": [
            1.3,
            0.8
          ],
          "angle": 0.8,
          "knockback": 17,
          "knockbackScaling": 13,
          "damage": 18,
          "position": [
            0.7,
            1.2
          ],
          "startTime": 9,
          "endTime": 17,
          "freezeTime": 14
        },
        {
          "size": [
            0.2,
            0.2
          ],
          "angle": 0.8,
          "knockback": 5,
          "knockbackScaling": 5,
          "damage": 2,
          "position": [
            0.4,
            1.2
          ],
          "startTime": 11,
          "endTime": 13,
          "freezeTime": 4
        }
      ]
    },
    {
      "name": "downsmashcharge",
      "animation": "Down Smash Charge"
    },
    {
      "name": "downsmash",
      "animation": "Down Smash",
      "hitBoxes": [
        {
          "size": [
            0.8,
            0.9
          ],
          "angle": 0.7,
          "knockback": 15,
          "knockbackScaling": 13,
          "damage": 14,
          "position": [
            0.6,
            0.4
          ],
          "startTime": 4,
          "endTime": 12,
          "freezeTime": 13
        },
        {
          "size": [
            0.8,
            0.9
          ],
          "angle": 2.4,
          "knockback": 15,
          "knockbackScaling": 13,
          "damage": 14,
          "position": [
            -0.6,
            0.4
          ],
          "startTime": 16,
          "endTime": 25,
          "freezeTime": 13
        }
      ]
    },
    {
      "name": "neutralaerial",
      "animation": "Neutral Aerial",
      "hitBoxes": [
        {
          "size": [
            1,
            0.8
          ],
          "angle": 1.0,
          "knockback": 6,
          "knockbackScaling": 0,
          "damage": 4,
          "position": [
            -0.2,
            1.4
          ],
          "startTime": 8,
          "endTime": 11,
          "freezeTime": 2
        },
        {
          "size": [
            0.7,
            1.3
          ],
          "angle": -0.7,
          "knockback": 8,
          "knockbackScaling": 7,
          "damage": 2,
          "position": [
            0.8,
            0.9
          ],
          "startTime": 12,
          "endTime": 24,
          "freezeTime": 7
        }
      ]
    },
    {
      "name": "forwardaerial",
      "animation": "Knee of Fury",
      "hitBoxes": [
        {
          "size": [
            1.1,
            0.85
          ],
          "angle": 0.8,
          "knockback": 8,
          "knockbackScaling": 7,
          "damage": 6,
          "position": [
            0.6,
            0.6
          ],
          "startTime": 5,
          "endTime": 15
        },
        {
          "size": [
            0.2,
            0.2
          ],
          "angle": 0.7,
          "knockback": 7,
          "knockbackScaling": 15,
          "damage": 2,
          "position": [
            0.28,
            0.64
          ],
          "startTime": 7,
          "endTime": 9,
          "freezeTime": 30
        }
      ]
    },
    {
      "name": "backaerial",
      "animation": "Back Aerial",
      "hitBoxes": [
        {
          "size": [
            1,
            0.7
          ],
          "angle": 2.5,
          "knockback": 4,
          "knockbackScaling": 3,
          "damage": 6,
          "position": [
            -0.6,
            0.4
          ],
          "startTime": 7,
          "endTime": 10
        },
        {
          "size": [
            1,
            0.7
          ],
          "angle": 2.5,
          "knockback": 5,
          "knockbackScaling": 4,
          "damage": 3,
          "position": [
            -0.6,
            0.4
          ],
          "startTime": 10,
          "endTime": 25
        }
      ]
    },
    {
      "name": "upaerial",
      "animation": "Up Aerial",
      "hitBoxes": [
        {
          "size": [
            0.8,
            0.8
          ],
          "position": [
            0,
            1.9
          ],
          "angle": 1.5,
          "knockback": 1,
          "knockbackScaling": 0,
          "damage": 3,
          "startTime": 6,
          "endTime": 8,
          "freezeTime": 7,
          "captureTime": 5
        },
        {
          "size": [
            0.8,
            0.8
          ],
          "position": [
            0,
            1.9
          ],
          "angle": 1.5,
          "knockback": 12,
          "knockbackScaling": 10,
          "damage": 4,
          "startTime": 10,
          "freezeTime": 7,
          "endTime": 17
        }
      ]
    },
    {
      "name": "downaerial",
      "animation": "Down Aerial",
      "hitBoxes": [
        {
          "size": [
            0.6,
            0.8
          ],
          "angle": -1.3,
          "knockback": 11,
          "knockbackScaling": 11,
          "damage": 7,
          "position": [
            0.1,
            0.25
          ],
          "startTime": 8,
          "endTime": 16
        }
      ]
    },
    {
      "name": "crouch",
      "animation": "Crouch"
    },
    {
      "name": "crawl",
      "animation": "Crawl"
    },
    {
      "name": "upspecial",
      "animation": "Up Special",
      "custom": "TestRecoveryMove",
      "hitBoxes": [
        {
          "size": [
            1.2,
            1.2
          ],
          "position": [
            0,
            0.9
          ],
          "angle": 1.5707963267949,
          "knockback": 6,
          "knockbackScaling": 4,
          "damage": 8,
          "startTime": 40,
          "endTime": 60,
          "freezeTime": 6
        },
        {
          "size": [
            0.6,
            0.6
          ],
          "position": [
            0,
            0.9
          ],
          "angle": 1.6,
          "knockback": 7,
          "knockbackScaling": 6,
          "damage": 3,
          "startTime": 55,
          "endTime": 60,
          "freezeTime": 10
        }
      ]
    },
    {
      "name": "disabledfall",
      "animation": "Disabled Fall"
    },
    {
      "name": "neutralspecial",
      "custom": "TestNeutralSpecialMove",
      "animation": "Neutral Special"
    },
    {
      "name": "test3fire",
      "custom": "TestFireMove",
      "animation": "Fire"
    },
    {
      "name": "downspecial",
      "custom": "TestCounterMove",
      "animation": "TestCounter",
      "duration": 100
    },
    {
      "name": "testcounterattack",
      "custom": "TestCounterAttackMove",
      "animation": "TestCounterAttack",
      "duration": 50,
      "hitBoxes": [
        {
          "size": [
            1.3,
            0.8
          ],
          "angle": 0.8,
          "position": [
            0.7,
            1.2
          ],
          "startTime": 13,
          "endTime": 20,
          "freezeTime": 25
        }
      ]
    },
    {
      "name": "sidespecial",
      "animation": "Side Special",
      "allowAnimatedMovement": true,
      "stopAtLedges": true,
      "hitBoxes": [
        {
          "size": [
            1.3,
            0.6
          ],
          "angle": 2.6,
          "knockback": 1,
          "knockbackScaling": 0,
          "damage": 1.5,
          "position": [
            0,
            1.1
          ],
          "startTime": 6,
          "endTime": 9,
          "freezeTime": 6,
          "captureTime": 5
        },
        {
          "size": [
            1.3,
            0.6
          ],
          "angle": 0.5,
          "knockback": 1,
          "knockbackScaling": 0,
          "damage": 1.5,
          "position": [
            0,
            1.1
          ],
          "startTime": 9,
          "endTime": 12,
          "freezeTime": 6,
          "captureTime": 5
        },
        {
          "size": [
            1.3,
            0.6
          ],
          "angle": 0.5,
          "knockback": 1,
          "knockbackScaling": 0,
          "damage": 1.5,
          "position": [
            0,
            1.1
          ],
          "startTime": 17,
          "endTime": 21,
          "freezeTime": 6,
          "captureTime": 5
        },
        {
          "size": [
            1.3,
            0.6
          ],
          "angle": 2.3,
          "knockback": 9,
          "knockbackScaling": 8,
          "damage": 2,
          "position": [
            0,
            1.1
          ],
          "startTime": 21,
          "endTime": 25,
          "freezeTime": 10
        },
        {
          "deflect": true,
          "size": [
            1.5,
            0.8
          ],
          "position": [
            0,
            1.1
          ],
          "startTime": 6,
          "endTime": 18
        }
      ]
    },
    {
      "name": "grab",
      "animation": "Grab",
      "hitBoxes": [{
        "size": [
          0.75,
          0.5
        ],
        "position": [
          0.3,
          1.0
        ],
        "startTime": 10,
        "endTime": 22
      }]
    },
    {
      "name": "pummel",
      "animation": "Pummel",
      "hitBoxes": [
        {
          "collides": false,
          "startTime": 2,
          "damage": 2
        }
      ]
    },
    {
      "name": "hold",
      "animation": "Hold"
    },
    {
      "name": "held",
      "animation": "Held"
    },
    {
      "name": "upthrow",
      "animation": "Up Throw",
      "hitBoxes": [
        {
          "collides": false,
          "startTime": 12,
          "angle": 1.5,
          "knockback": 14,
          "knockbackScaling": 12,
          "damage": 8
        }
      ]
    },
    {
      "name": "downthrow",
      "animation": "Down Throw",
      "hitBoxes": [
        {
          "collides": false,
          "startTime": 14,
          "angle": -1.2,
          "knockback": 14,
          "knockbackScaling": 12,
          "damage": 9
        }
      ]
    },
    {
      "name": "forwardthrow",
      "animation": "Forward Throw",
      "hitBoxes": [
        {
          "collides": false,
          "startTime": 14,
          "angle": 0.8,
          "knockback": 13,
          "knockbackScaling": 11,
          "damage": 10
        }
      ]
    },
    {
      "name": "backthrow",
      "animation": "Back Throw",
      "hitBoxes": [
        {
          "collides": false,
          "startTime": 15,
          "angle": 2.3,
          "knockback": 12,
          "knockbackScaling": 10,
          "damage": 11
        }
      ]
    },
    {
      "name": "pummelled",
      "animation": "Pummelled"
    }
  ]
}