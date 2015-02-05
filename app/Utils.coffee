Utils = module.exports =
  # Sets the THREE.Vector3 by a two or three element [x, y, z] array.
  # Also works if array happens to be a THREE.Vector3 as well.
  setVectorByArray: (vector, array)->
    if array instanceof THREE.Vector3
      vector.copy(array)
    else if array instanceof Array
      vector.set(array[0] or 0, array[1] or 0, array[2] or 0)
    return vector

  # Finds the object in the given array by matching the name property
  findObjectByName: (array, name)->
    for item in array when item.name is name
      return item
    return null
  clone: (object)->
    JSON.parse(JSON.stringify(object))

  # Converts a THREE.js color to a CSS color
  colorToCSS: (color)->
    return "rgb(#{Math.floor(color.r*256)}, #{Math.floor(color.g*256)}, #{Math.floor(color.b*256)})"

  # Converts a damage to a CSS color
  damageToCSS: (damage)->
    index = damageStops.length - 1
    # No negative damages, please
    for stop, i in damageStops
      if stop > damage
        index = i - 1
        break
    tempColor.copy(colorStops[index])
    if index + 1 < colorStops.length
      progression = (damage - damageStops[index]) / (damageStops[index + 1] - damageStops[index])
      Utils.lerpColorRGB(tempColor, colorStops[index + 1], progression)
    return Utils.colorToCSS(tempColor)

  lerpColorRGB: (colorA, colorB, amount)->
    colorA.r = colorA.r * (1 - amount) + colorB.r * amount
    colorA.g = colorA.g * (1 - amount) + colorB.g * amount
    colorA.b = colorA.b * (1 - amount) + colorB.b * amount
    return colorA

tempColor = new THREE.Color()
damageStops = [
  0
  25
  50
  75
  100
  125
  300
]
colorStops = [
  new THREE.Color(0xFFFFFF)
  new THREE.Color(0xF5F58C)
  new THREE.Color(0xFFEA00)
  new THREE.Color(0xFF8800)
  new THREE.Color(0xE80000)
  new THREE.Color(0xA80000)
  new THREE.Color(0x610000)
]