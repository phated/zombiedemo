###
This type of sprite is based off of the excellent images from Reiner's tilesets: http://www.reinerstilesets.de/

creatures have walking, idle, and dying animations in 8 isometric directions
The animations directions are in E,N,NE,NW,S,SE,SW,W (alphabetical) order simply because that's
how i stitched them together using ImageMagick.
###

define [ 'dojo/_base/declare', 'mwe/Sprite', 'mwe/Animation' ], (declare, Sprite, Animation) ->
  declare 'Creature', Sprite, {
    statics: {
      EAST: 0
      NORTH: 1
      NORTHEAST: 2
      NORTHWEST: 3
      SOUTH: 4
      SOUTHEAST: 5
      SOUTHWEST: 6
      WEST: 7
      STATE_WALKING: 0
      STATE_DYING: 1
      STATE_IDLE: 2
    }
    state: 0
    walkingAnims: []
    dyingAnims: []
    idleAnims: []
    direction: 5

    constructor: (args) ->
      @state = @statics.STATE_IDLE
      @direction = @statics.SOUTH
      declare.safeMixin @, args

    update: (elapsedTime) ->
      @x += @dx * elapsedTime
      @y += @dy * elapsedTime
      if @state isnt @statics.STATE_DYING
        if @dx > 0 and @dy is 0
          @direction = @statics.EAST
        else if @dx is 0 and @dy < 0
          @direction = @statics.NORTH
        else if @dx > 0 and @dy < 0
          @direction = @statics.NORTHEAST
        else if @dx < 0 and @dy < 0
          @direction = @statics.NORTHWEST
        else if @dx is 0 and @dy > 0
          @direction = @statics.SOUTH
        else if @dx > 0 and @dy > 0
          @direction = @statics.SOUTHEAST
        else if @dx < 0 and @dy > 0
          @direction = @statics.SOUTHWEST
        else if @dx < 0 and @dy is 0
          @direction = @statics.WEST
        if @dx is 0 and @dy is 0
          @state = @statics.STATE_IDLE
        else
          @state = @statics.STATE_WALKING

      if @state is @statics.STATE_WALKING
        @anim = @walkingAnims[@direction]
      else if @state is @statics.STATE_DYING
        @anim = @dyingAnims[@direction]
      else
        @anim = @idleAnims[@direction]

      @anim.update elapsedTime

    createAnimations: (frameCount, frameTimes, img, h, w, ySlot) ->
      anims = []
      isFTArray = Array.isArray frameTimes
      currentFrameTime = 1
      ySlot = 0 if not ySlot
      for i in [0..7]
        anims[i] = new Animation {
          height: h
          width: w
          image: img
        }
        for j in [0..frameCount-1]
          if isFTArray
            currentFrameTime = frameTimes[j]
          else
            currentFrameTime = frameTimes
          anims[i].addFrame currentFrameTime, j + frameCount * i, ySlot
      return anims
      
    ### Contra's version
    createAnimations: (frameCount, frameTimes, img, h, w, ySlot=0) ->
      anims = []
      currentFrameTime = 1
      for i in [0..7]
        anims[i] = new Animation
          height: h
          width: w
          image: img
        for j, item in Array(frameTime-1)
          currentFrameTime = (if Array.isArray frameTimes then frameTimes[j] else frameTimes)
          anims[i].addFrame currentFrameTime, (j + frameCount * i), ySlot
      return anims
    ###
  }
