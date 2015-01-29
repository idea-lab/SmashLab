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
