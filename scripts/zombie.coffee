require [ 'mwe/GameCore', 'mwe/Sprite', 'mwe/ResourceManager', 'mwe/GameAction', 'mwe/reiner/Creature' ], (GameCore, Sprite, ResourceManager, GameAction, Creature) ->
  gameWidth = 800
  gameHeight = 600
  spriteList = []

  soundManager.url = '/nge/swf/'
  # soundManager.flashVersion = 9 # optional: shiny features (default = 8)
  # soundManager.useFlashBlock = false # optional: enable when you're ready to dive in
  soundManager.useHTML5Audio = true
  soundManager.debugMode = false

  soundManager.onready ->
    fartSound = soundManager.createSound id: 'aSound', url: 'sounds/fart.mp3'
    anvilSound = soundManager.createSound id: 'anvilSound', url: 'sounds/anvil.mp3'

  playSound = (sound) ->
    return sound.play() if sound
    return console.log "sound not loaded"

  require [ 'dojo/domReady!' ], ->
    rm = new ResourceManager imageDir: 'images/'
    rm.loadFiles {
      backgroundImg: 'background_800.png'
	    face: 'GHappyAdrian.png'
	    drunk: 'DrunkAdrian.png'
	    bwi: 'builder/walking_b.png'
      swi2: 'soldier/walking_b.png'
	    sshi: 'soldier/shooting.png'
	    sgi: 'soldier/greeting_b.png'
	    gwi: 'girl/walking_b.png'
	    gzwi: 'greenZombie/walking_b.png'
	    gzdi: 'greenZombie/dying_b.png'
	    gzii: 'greenZombie/talking_b.png'
    }

    for i in 3
      zombie = new Creature {
        x: Math.random() * (gameWidth - 96)
        y: Math.random() * (gameHeight - 96)
        w: 96
        h: 96
        dx: 0.02 + Math.random() * 0.03
        dy: 0.02 + Math.random() * 0.03
        xStartVelocity: 0.02 + Math.random() * 0.03
        yStartVelocity: 0.02 + Math.random() * 0.03
        collisionRadius: 20
      }
      zombie.name = "z#{i}"
      zombie.walkingAnims = zombie.createAnimations 8, 125, gzwi, 96, 96, 0
      zombie.idleAnims = zombie.createAnimations 8, 125, gzii, 96, 96, 0
      zombie.dyingAnims = zombie.createAnimations 9, 125, gzdi, 96, 96, 0
      spriteList.push zombie

    sprite = new Creature {
      x: 0
      y: 0
      w: 96
      h: 96
      dx: 0.2
      dy: 0.2
      xStartVelocity: 0.2
      yStartVelocity: 0.2
      collisionRadius: 20
      name: 'player'
    }
