module.exports = class FinalTest
  @name: "Final Test-ination"

  # The exported model's source code URI
  @modelSrc: "models/Stage.json"
  # To be filled in by a loader
  @modelJSON: null

  # TODO: Get these assets into a loader!
  @moteImage: THREE.ImageUtils.loadTexture("images/Mote.png")

  # The camera boundaries
  @cameraBox: {
    size: [28, 20]
    position: [0, 1]
  }

  # The KO Boundaries
  @safeBox: {
    size: [36, 22]
    position: [0, 3]
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

  constructor: (@scene)->
    @material = new THREE.MeshLambertMaterial(shading:THREE.FlatShading)

    geometry = THREE.JSONLoader.prototype.parse(FinalTest.modelJSON).geometry
    mesh = new THREE.Mesh(geometry, @material)
    @scene.add(mesh)
    @boxes = for i in [0..50]
      mesh = new THREE.Mesh(new THREE.BoxGeometry(1, 1, 1), @material)
      FinalTest.initBox(mesh)
      mesh.position.z = -Math.random() * FinalTest.BOX_MAX_DIST
      @scene.add(mesh)
      mesh

    @moteContainer = new THREE.Object3D()
    @motes = for i in [0..50]
      sprite = new THREE.Sprite(new THREE.SpriteMaterial(map: FinalTest.moteImage))
      sprite.scale.multiplyScalar(0.2)
      FinalTest.initMote(sprite)
      FinalTest.initMote(sprite)
      sprite.position.z = -Math.random() * FinalTest.SPRITE_MAX_DIST
      @moteContainer.add(sprite)
      sprite

    @scene.camera.add(@moteContainer)
    @scene.fog = new THREE.Fog(0x000000, 50, FinalTest.BOX_MAX_DIST)

  update: (deltaTime)->
    for box in @boxes
      box.position.z += 0.5 * deltaTime
      if box.position.z >= FinalTest.BOX_MIN_DIST
        FinalTest.initBox(box)

    for sprite in @motes
      sprite.position.z += 0.5 * deltaTime
      if sprite.position.z >= FinalTest.SPRITE_MIN_DIST
        FinalTest.initMote(sprite)

  @initMote: (sprite)->
    angle = Math.random() * Math.PI * 2
    radius = FinalTest.SPRITE_SPAWN_MIN_RADIUS + FinalTest.SPRITE_SPAWN_VARYING_RADIUS * Math.random()
    sprite.position.set(
      Math.cos(angle) * radius,
      Math.sin(angle) * radius,
      - FinalTest.SPRITE_MAX_DIST
    )
    sprite.material.rotation = angle


  @initBox: (mesh)->
    angle = Math.random() * Math.PI * 2
    radius = FinalTest.BOX_SPAWN_MIN_RADIUS + FinalTest.BOX_SPAWN_VARYING_RADIUS * Math.random()
    mesh.position.set(
      Math.cos(angle) * radius,
      Math.sin(angle) * radius,
      - FinalTest.BOX_MAX_DIST
    )
    mesh.rotation.set(Math.random() * Math.PI * 2, Math.random() * Math.PI * 2, 0)
    mesh.scale.set(1, 1, 1).multiplyScalar(FinalTest.BOX_MIN_SIZE + FinalTest.BOX_VARYING_SIZE * Math.random())

  @SPRITE_SPAWN_MIN_RADIUS: 5
  @SPRITE_SPAWN_VARYING_RADIUS: 5
  @SPRITE_MAX_DIST: 20
  @SPRITE_MIN_DIST: 5

  @BOX_SPAWN_MIN_RADIUS: 10
  @BOX_SPAWN_VARYING_RADIUS: 50
  @BOX_MIN_SIZE: 1
  @BOX_VARYING_SIZE: 2
  @BOX_MAX_DIST: 100
  @BOX_MIN_DIST: 10
