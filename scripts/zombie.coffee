require [ 'mwe/GameCore', 'mwe/Sprite', 'mwe/ResourceManager', 'mwe/CanvasManager', 'mwe/InputManager', 'mwe/GameAction', 'mwe/reiner/Creature'], (GameCore, Sprite, ResourceManager, CanvasManager, InputManager, GameAction, Creature) ->
  gameWidth = 800
  gameHeight = 600
  spriteList = []
  ###
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
  ###
  require [ 'dojo/domReady!' ], ->
    rm = new ResourceManager imageDir: 'images/'
    images = rm.loadFiles {
      backgroundImg: 'background_800.png'
      #face: 'GHappyAdrian.png'
      #drunk: 'DrunkAdrian.png'
      bwi: 'builder/walking_b.png'
      swi2: 'soldier/walking_b.png'
      sshi: 'soldier/shooting.png'
      sgi: 'soldier/greeting_b.png'
      gwi: 'girl/walking_b.png'
      gzwi: 'greenZombie/walking_b.png'
      gzdi: 'greenZombie/dying_b.png'
      gzii: 'greenZombie/talking_b.png'
    }

    for i in [0..2]
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
      zombie.walkingAnims = zombie.createAnimations 8, 125, images.gzwi, 96, 96, 0
      zombie.idleAnims = zombie.createAnimations 8, 125, images.gzii, 96, 96, 0
      zombie.dyingAnims = zombie.createAnimations 9, 125, images.gzdi, 96, 96, 0
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
    sprite.walkingAnims = sprite.createAnimations 8, 75, images.swi2, 96, 96, 0
    sprite.dyingAnims = sprite.createAnimations 8, 75, images.swi2, 96, 96, 0
    sprite.idleAnims = sprite.createAnimations 9, [3000, 150, 150, 150, 1000, 150, 150, 150, 3000], images.sgi, 96, 96, 0
    spriteList.push sprite

    girl = new Creature {
      x: 100
      y: 200
      w: 50
      h: 50
      dx: 0.15
      dy: 0.12
      xStartVelocity: 0.15
      yStartVelocity: 0.12
      collisionRadius: 20
      walkingAnims: sprite.createAnimations 8, 75, images.gwi, 96, 96, 0
      idleAnims: sprite.createAnimations 8, 75, images.gwi, 96, 96, 0
      talkingAnims: sprite.createAnimations 8, 75, images.gwi, 96, 96, 0
      name: 'girl'
    }
    spriteList.push girl

    soldier = new Creature {
      x: 10
      y: 150
      w: 80
      h: 80
      dx: 0.2
      dy: 0.1
      walkingAnims: sprite.createAnimations 8, 75, images.bwi, 96, 96, 0
      idleAnims: sprite.createAnimations 8, 75, images.bwi, 96, 96, 0
      talkingAnims: sprite.createAnimations 8, 75, images.bwi, 96, 96, 0
      name: 'cw'
    }
    spriteList.push soldier

    cm = new CanvasManager {
      canvasId: 'drawing'
      height: gameHeight
      width: gameWidth
      loadingBackground: '#000'
      loadingForeground: '#BADA55'
      draw: (context) ->
        context.drawImage images.backgroundImg, 0, 0
        for s in spriteList
          s.drawCurrentFrame context
    }

    im = new InputManager()
    im.bindKeys()

    game = new GameCore {
      inputManager: im
      canvasManager: cm
      resourceManager: rm
      initInput: (im) ->
        @moveLeft = new GameAction name: 'moveLeft'
        @moveRight = new GameAction name: 'moveRight'
        @moveUp = new GameAction name: 'moveUp'
        @moveDown = new GameAction name: 'moveDown'
        @exit = new GameAction {
          name: 'exit'
          behavior: @moveLeft.statics.DETECT_INITIAL_PRESS_ONLY
        }
        im.mapToKey @moveLeft, dojo.keys.LEFT_ARROW
        im.mapToKey @moveRight, dojo.keys.RIGHT_ARROW
        im.mapToKey @moveUp, dojo.keys.UP_ARROW
        im.mapToKey @moveDown, dojo.keys.DOWN_ARROW
        im.mapToKey @exit, dojo.keys.ESCAPE
    }

    game.update = (elapsedTime) ->
      @handleInput()
      for s in spriteList
        s.hasCollided = false
        s.hasHitWall = false
        s.update elapsedTime
        if handleWalls s
          playAnvil = true
          s.hasHitWall = false
      for s in spriteList
        if not s.hasCollided and not s.hasHitWall
          for otherS in spriteList
            if s isnt otherS
              if intersectSprite s, otherS
                s.hasCollided = true
                otherS.hasCollided = true
        if s isnt sprite and s.hasCollided and not s.hasHitWall
          flipX s
          flipY s
          s.update elapsedTime # move a little further in the new direction
      spriteList.sort (a,b) -> return a.y - b.y

    game.handleInput = ->
      if @moveLeft.isPressed()
        sprite.dx = -1 * Math.abs sprite.xStartVelocity
      else if @moveRight.isPressed()
        sprite.dx = Math.abs sprite.xStartVelocity
      else
        sprite.dx = 0

      if @moveUp.isPressed()
        sprite.dy = -1 * Math.abs sprite.yStartVelocity
      else if @moveDown.isPressed()
        sprite.dy = Math.abs sprite.yStartVelocity
      else
        sprite.dy = 0

    game.run()

  jump = 5
  playFart = false
  handleWalls = (s) ->
    hitWall = false
    if s.x > gameWidth - s.w
      s.x = s.x - jump
      flipX s
      hitWall = true
    else if s.x < 0
      s.x = s.x + jump
      flipX s
      hitWall = true

    if s.y > gameHeight - s.h
      s.y = s.y - jump
      flipY s
      hitWall = true
    else if s.y < 0
      s.y = s.y + jump
      flipY s
      hitWall = true

    return hitWall

  flipX = (s) ->
    s.dx = s.dx * -1

  flipY = (s) ->
    s.dy = s.dy * -1

  intersectSprite = (s1, s2) ->
    distance_squared = Math.pow((s1.x + (s1.anim.width / 2)) - (s2.x + (s2.anim.width / 2)), 2) + Math.pow((s1.y + (s1.anim.height / 2)) - (s2.y + (s2.anim.height / 2)), 2)
    radii_squared = Math.pow s1.collisionRadius + s2.collisionRadius, 2
    return distance_squared < radii_squared # true if intersect

  changeDirection = ->
    sprite.dy = sprite.dy * -1
    sprite.dx = sprite.dx * -1
