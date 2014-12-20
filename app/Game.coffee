#Managesand renders the entire game, menus, and stages.
Stage = require("Stage")
module.exports = (@element) ->
  @renderer= new THREE.WebGLRenderer()
  @width = 0
  @height = 0
  @resize()
  @stage = new Stage(this)
  @element.appendChild(@renderer.domElement)
  return

module.exports::render = ->
  @stage.update()
  @renderer.render(@stage, @stage.camera)

module.exports::resize = ->
  @width = @element.offsetWidth
  @height = @element.offsetHeight
  @renderer.setSize(@width, @height)
