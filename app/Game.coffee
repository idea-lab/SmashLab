# Manages and renders the entire game, menus, and stages.
Stage = require("Stage")
Game = module.exports = (@element) ->
  @renderer= new THREE.WebGLRenderer({preserveDrawingBuffer: true})
  # @cyclicalbuffer = window.buffer = []
  # @record = true
  # @time = 0
  # $(window).on "keydown", (event)=>
  #   if event.keyCode is 96
  #     @record = false
  @width = 0
  @height = 0
  @stage = new Stage(this)
  @resize()
  @element.appendChild(@renderer.domElement)

  return

Game::render = ->
  @stage.update()
  @renderer.render(@stage, @stage.camera)
  # # Save at 20 fps
  # if @record and @time % 3 is 0
  #   @cyclicalbuffer.push(@renderer.domElement.toDataURL("image/png"))
  # # Save 2 seconds
  # while @cyclicalbuffer.length > 40
  #   @cyclicalbuffer.shift()
  # @time++

Game::resize = ->
  @width = @element.offsetWidth
  @height = @element.offsetHeight
  @renderer.setSize(@width, @height)
  @stage.resize()
