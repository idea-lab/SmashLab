# Manages and renders the entire game, menus, and stages.
Stage = require("Stage")
Game = module.exports = (@element) ->
  @renderer= new THREE.WebGLRenderer({morphTargets: 16})
  @width = 0
  @height = 0
  @stage = new Stage(this)
  @resize()
  @element.appendChild(@renderer.domElement)

  return

Game::render = ->
  @stage.update()
  @renderer.render(@stage, @stage.camera)

Game::resize = ->
  @width = @element.offsetWidth
  @height = @element.offsetHeight
  @renderer.setSize(@width, @height)
  @stage.resize()
