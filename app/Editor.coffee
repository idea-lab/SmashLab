module.exports = class Editor
  constructor: (@element, @id)->
    @onupdate = null
    @element.addEventListener "input", (event)=>
      @saveText(@element.innerText)
      try
        @onupdate?(@getJSON())
    @element.addEventListener "keydown", (event)=>
      event.stopPropagation()
    @element.addEventListener "keyup", (event)=>
      event.stopPropagation()
    @element.addEventListener "mouseenter", (event)=>
      @element.style.opacity = 1
    @element.addEventListener "mouseleave", (event)=>
      @element.blur()
      @element.style.opacity = 0
    window.addEventListener "keydown", (event)=>
      @element.style.opacity = 1
      if event.keyCode is 192
        if @element.style.display is "inherit"
          @element.style.display = "none"
        else
          @element.style.display = "inherit"

  getText: ()->
    @element.value

  getJSON: ()->
    try
      JSON.parse(@getText())
      @element.style.color = ""
    catch
      @element.style.color = "red"
      return null
  setText: (text)->
    @element.value = text

  setJSON: (object)->
    @setText(JSON.stringify(object, null, 2))

  loadText : ()->
    if localStorage?[@id]?.length?>0
      @setText(localStorage[@id])

  saveText : ()->
    localStorage[@id] = @getText()
