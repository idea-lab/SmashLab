# Sets up the game and renderloops it.
Game = require("Game")
window.game = new Game(document.body)
render = ()->
  (window.requestAnimationFrame or window.mozRequestAnimationFrame)(render)
  game.render()

window.addEventListener("resize", ()->
  game.resize()
, false)
render()
