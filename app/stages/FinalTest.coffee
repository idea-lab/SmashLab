module.exports = class StageData
  @name: "Final Test-ination"

  # The exported model's source code URI
  @modelSrc: "models/Stage.json"
  # To be filled in by a loader
  @modelJSON: null

  # The camera boundaries
  @cameraBox: {
    size: [26, 20]
    position: [0, 2]
  }

  # The KO Boundaries
  @safeBox: {
    size: [36, 22]
    position: [0, 4]
  }

  # The main hitboxes
  @collisionBoxes: [
    {
      size: [14, 0.3]
      position: [0, -0.15]
      leftLedge: true
      rightLedge: true
    }
  ]

  @init: (scene)->
    geometry = THREE.JSONLoader.prototype.parse(@modelJSON).geometry
    mesh = new THREE.Mesh(geometry, new THREE.MeshLambertMaterial(shading:THREE.FlatShading))
    scene.add(mesh)
