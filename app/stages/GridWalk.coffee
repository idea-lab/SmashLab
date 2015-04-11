module.exports = class GridWalk
  @name: "GridWalk"

  # The exported model's source code URI
  @modelSrc: "models/nexus.json"
  # To be filled in by a loader
  @modelJSON: null

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
      size: [40, 10]
      position: [0, -5]
    }
    {
      size: [3, 1.5]
      position: [6.675, 0.75]
      debug: true
    }
    {
      size: [3, 1.5]
      position: [-6.675, 0.75]
      debug: true
    }
  ]

  constructor: (@stage)->
    geometry = THREE.JSONLoader.prototype.parse(GridWalk.modelJSON).geometry
    mesh = new THREE.Mesh(geometry, new THREE.MeshNormalMaterial(shading:THREE.FlatShading))
    mesh.scale.multiplyScalar(2.25)
    mesh.position.set(0, 1, -4).multiply(mesh.scale)
    @stage.add(mesh)

    #create THE GRID
    texture = new THREE.ImageUtils.loadTexture("images/TRON_Tile.png");
    texture.wrapS=texture.wrapT=THREE.RepeatWrapping;
    texture.repeat.set(50,50);
    texture.anisotropy=@stage.game.renderer.getMaxAnisotropy();
    plane = new THREE.Mesh( new THREE.PlaneBufferGeometry(100, 100), new THREE.MeshBasicMaterial(
        
        {
            color: 0x00ddff,
            map:texture
        }
        #this is a javascript object
    ));
    plane.position.set(0, 0, 0)
    plane.rotation.x=-Math.PI/2
    @stage.add(plane)
###    
    
    
    
    
    //random blender stuff
    
    loader = new THREE.JSONLoader();
    
    
    function lld( geometry ) {
        nexus = new THREE.Mesh( geometry, new THREE.MeshNormalMaterial() );
        nexus.scale.set( 1000, 1000, 1000 );
        nexus.position.set(0,1000,-1000);
        @stage.add(nexus);
        
    }
    
    function lld2( geometry ) {
        monkey = new THREE.Mesh( geometry, new THREE.MeshNormalMaterial() );
        monkey.scale.set( 1000, 1000, 1000 );
        monkey.position.set(0,1000,0);
        @stage.add(monkey);
        
    }
    
    
    loader.load( "nexus.js", lld);
    //loader.load( "test.js", lld2);
    
    
    
    
    //put THE GRID in the xz-plane\/
    ###