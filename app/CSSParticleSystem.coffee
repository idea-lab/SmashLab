class module.exports.CSSParticleSystem
  constructor: () ->
    @particles = []
  update: (deltaTime)->
    i = 0
    while i < @particles.length
      particle = @particles[i]
      particle.update(deltaTime)
      if particle.lifetime<=0
        particle.destroy()
        @particles.splice(i, 1)
        i--
      i++
  addParticle: (particle)->
    @particles.push(particle)

tempVector3 = new THREE.Vector3()
class Particle
  constructor: ()->
    @position = new THREE.Vector3()
    @velocity = new THREE.Vector3()
    @gravity = new THREE.Vector3()
    @lifetime = 30
  update: (deltaTime)->
    @position.add(tempVector3.copy(@velocity).multiplyScalar(deltaTime))
    @velocity.add(tempVector3.copy(@gravity).multiplyScalar(deltaTime))
    @lifetime = Math.max(0, @lifetime-deltaTime)
  destroy: ()->

class module.exports.CSSDamageParticle extends Particle
  constructor: (text)->
    super
    @element = new $("<div class=\"particle\"></div>").text(text)
    $(document.body).append(@element)
  update: (deltaTime)->
    super
    @element.css("opacity", Math.min(0.8, @lifetime/20))
      .css("transform", "translate(#{@position.x}px, #{@position.y}px)")
  destroy: ()->
    @element.remove()