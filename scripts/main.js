
require(['mwe/GameCore', 'mwe/Sprite', 'mwe/ResourceManager', 'mwe/CanvasManager', 'mwe/GameAction', 'mwe/reiner/Creature', 'dojo/keys'], function(GameCore, Sprite, ResourceManager, CanvasManager, GameAction, Creature, keys) {
  var changeDirection, flipX, flipY, gameHeight, gameWidth, handleWalls, intersectSprite, jump, playFart, playSound, spriteList;
  gameWidth = 800;
  gameHeight = 600;
  spriteList = [];
  soundManager.url = '/nge/swf/';
  soundManager.useHTML5Audio = true;
  soundManager.debugMode = false;
  soundManager.onready(function() {
    var anvilSound, fartSound;
    fartSound = soundManager.createSound({
      id: 'aSound',
      url: 'sounds/fart.mp3'
    });
    return anvilSound = soundManager.createSound({
      id: 'anvilSound',
      url: 'sounds/anvil.mp3'
    });
  });
  playSound = function(sound) {
    if (sound) return sound.play();
    return console.log("sound not loaded");
  };
  require(['dojo/domReady!'], function() {
    var cm, game, girl, i, images, rm, soldier, sprite, zombie, _i, _len, _ref;
    rm = new ResourceManager({
      imageDir: 'images/'
    });
    images = rm.loadFiles({
      backgroundImg: 'background_800.png',
      bwi: 'builder/walking_b.png',
      swi2: 'soldier/walking_b.png',
      sshi: 'soldier/shooting.png',
      sgi: 'soldier/greeting_b.png',
      gwi: 'girl/walking_b.png',
      gzwi: 'greenZombie/walking_b.png',
      gzdi: 'greenZombie/dying_b.png',
      gzii: 'greenZombie/talking_b.png'
    });
    _ref = 3;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      zombie = new Creature({
        x: Math.random() * (gameWidth - 96),
        y: Math.random() * (gameHeight - 96),
        w: 96,
        h: 96,
        dx: 0.02 + Math.random() * 0.03,
        dy: 0.02 + Math.random() * 0.03,
        xStartVelocity: 0.02 + Math.random() * 0.03,
        yStartVelocity: 0.02 + Math.random() * 0.03,
        collisionRadius: 20
      });
      zombie.name = "z" + i;
      zombie.walkingAnims = zombie.createAnimations(8, 125, images.gzwi, 96, 96, 0);
      zombie.idleAnims = zombie.createAnimations(8, 125, images.gzii, 96, 96, 0);
      zombie.dyingAnims = zombie.createAnimations(9, 125, images.gzdi, 96, 96, 0);
      spriteList.push(zombie);
    }
    sprite = new Creature({
      x: 0,
      y: 0,
      w: 96,
      h: 96,
      dx: 0.2,
      dy: 0.2,
      xStartVelocity: 0.2,
      yStartVelocity: 0.2,
      collisionRadius: 20,
      name: 'player'
    });
    sprite.walkingAnims = sprite.createAnimations(8, 75, images.swi2, 96, 96, 0);
    sprite.dyingAnims = sprite.createAnimations(8, 75, images.swi2, 96, 96, 0);
    sprite.idleAnims = sprite.createAnimations(9, [3000, 150, 150, 150, 1000, 150, 150, 150, 3000], images.sgi, 96, 96, 0);
    girl = new Creature({
      x: 100,
      y: 200,
      w: 50,
      h: 50,
      dx: 0.15,
      dy: 0.12,
      xStartVelocity: 0.15,
      yStartVelocity: 0.12,
      collisionRadius: 20,
      walkingAnims: sprite.createAnimations(8, 75, images.gwi, 96, 96, 0),
      idleAnims: sprite.createAnimations(8, 75, images.gwi, 96, 96, 0),
      talkingAnims: sprite.createAnimations(8, 75, images.gwi, 96, 96, 0),
      name: 'girl'
    });
    soldier = new Creature({
      x: 10,
      y: 150,
      w: 80,
      h: 80,
      dx: 0.2,
      dy: 0.1,
      walkingAnims: sprite.createAnimations(8, 75, images.bwi, 96, 96, 0),
      idleAnims: sprite.createAnimations(8, 75, images.bwi, 96, 96, 0),
      talkingAnims: sprite.createAnimations(8, 75, images.bwi, 96, 96, 0),
      name: 'cw'
    });
    cm = new CanvasManager({
      canvasId: 'drawing'
    });
    game = new GameCore({
      canvasId: 'drawing',
      canvasManager: cm,
      height: gameHeight,
      width: gameWidth,
      resourceManager: rm,
      loadingBackground: '#000',
      loadingForeground: '#BADA55',
      initInput: function(im) {
        this.moveLeft = new GameAction({
          name: 'moveLeft'
        });
        this.moveRight = new GameAction({
          name: 'moveRight'
        });
        this.moveUp = new GameAction({
          name: 'moveUp'
        });
        this.moveDown = new GameAction({
          name: 'moveDown'
        });
        this.exit = new GameAction({
          name: 'exit',
          behavior: this.moveLeft.statics.DETECT_INITIAL_PRESS_ONLY
        });
        im.mapToKey(this.moveLeft, keys.LEFT_ARROW);
        im.mapToKey(this.moveRight, keys.RIGHT_ARROW);
        im.mapToKey(this.moveUp, keys.UP_ARROW);
        im.mapToKey(this.moveDown, keys.DOWN_ARROW);
        return im.mapToKey(this.exit, keys.ESCAPE);
      }
    });
    game.update = function(elapsedTime) {
      var otherS, playAnvil, s, _j, _k, _l, _len2, _len3, _len4;
      this.handleInput();
      for (_j = 0, _len2 = spriteList.length; _j < _len2; _j++) {
        s = spriteList[_j];
        s.hasCollided = false;
        s.hasHitWall = false;
        s.update(elapsedTime);
        if (handleWalls(s)) {
          playAnvil = true;
          s.hasHitWall = false;
        }
      }
      for (_k = 0, _len3 = spriteList.length; _k < _len3; _k++) {
        s = spriteList[_k];
        if (!s.hasCollided && !s.hasHitWall) {
          for (_l = 0, _len4 = spriteList.length; _l < _len4; _l++) {
            otherS = spriteList[_l];
            if (s !== otherS) {
              if (intersectSprite(s, otherS)) {
                s.hasCollided = true;
                otherS.hasCollided = true;
              }
            }
          }
        }
        if (s !== sprite && s.hasCollided && !s.hasHitWall) {
          flipX(s);
          flipY(s);
          s.update(elapsedTime);
        }
      }
      return spriteList.sort(function(a, b) {
        return a.y - b.y;
      });
    };
    game.draw = function(context) {
      var s, _j, _len2, _results;
      context.drawImage(backgroundImg, 0, 0);
      _results = [];
      for (_j = 0, _len2 = spriteList.length; _j < _len2; _j++) {
        s = spriteList[_j];
        _results.push(s.drawCurrentFrame(context));
      }
      return _results;
    };
    /*
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
    */
    return game.run();
  });
  jump = 5;
  playFart = false;
  handleWalls = function(s) {
    var hitWall;
    hitWall = false;
    if (s.x > gameWidth - s.w) {
      s.x = s.x - jump;
      flipX(s);
      hitWall = true;
    } else if (s.x < 0) {
      s.x = s.x + jump;
      flipX(s);
      hitWall = true;
    }
    if (s.y > gameHeight - s.h) {
      s.y = s.y - jump;
      flipY(s);
      hitWall = true;
    } else if (s.y < 0) {
      s.y = s.y + jump;
      flipY(s);
      hitWall = true;
    }
    return hitWall;
  };
  flipX = function(s) {
    return s.dx = s.dx * -1;
  };
  flipY = function(s) {
    return s.dy = s.dy * -1;
  };
  intersectSprite = function(s1, s2) {
    var distance_squared, radii_squared;
    distance_squared = Math.pow((s1.x + (s1.anim.width / 2)) - (s2.x + (s2.anim.width / 2)), 2) + Math.pow((s1.y + (s1.anim.height / 2)) - (s2.y + (s2.anim.height / 2)), 2);
    radii_squared = Math.pow(s1.collisionRadius + s2.collisionRadius, 2);
    return distance_squared < radii_squared;
  };
  return changeDirection = function() {
    sprite.dy = sprite.dy * -1;
    return sprite.dx = sprite.dx * -1;
  };
});
