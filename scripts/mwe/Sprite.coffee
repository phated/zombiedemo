define [ 'dojo/_base/declare', 'mwe/Animation' ], (declare, Animation) ->
  declare 'Sprite', null, {
    # position (pixels)
    x: 0.0
    y: 0.0
    # velocity (pixels per millisecond)
    dx: 0.0
    dy: 0.0
    name: null
    collisionRadius: 40

    # Creates a new Sprite object
    constructor: (args) ->
      declare.safeMixin @, args

    # Updates this Sprite's Animation and its position based on the velocity
    update: (elapsedTime) ->
      @x += @dx * elapsedTime
      @y += @dy * elapsedTime
      @anim.update elapsedTime

    # Gets this Sprite's current x position
    getX: ->
      return @x

    # Gets this Sprite's current y position
    getY: ->
      return @y

    # Sets this Sprite's current x position
    setX: (x) ->
      @x = x

    # Sets this Sprite's current y position
    setY: (y) ->
      @y = y

    # Gets this Sprite's width, based on the size of the current image
    getWidth: ->
      return @anim.width

    # Gets this Sprite's height, based on the size of the current image
    getHeight: ->
      return @anim.height

    # Gets the horizontal velocity of this Sprite in pixels per millisecond
    getVelocityX: ->
      return @dx

    # Gets the vertical velocity of this Sprite in pixels per millisecond
    getVelocityY: ->
      return @dy
      
    setVelocityX: (dx) ->
      @dx = @limitSpeed dx
      
    setVelocityY: (dy) ->
      @dy = @limitSpeed dy

    limitSpeed: (v) ->
      if Math.abs v > @getMaxSpeed()
        if v isnt 0
          return @getMaxSpeed()
        else
          return 0
      else
        return v

    # Gets the maximum speed of this Creature
    getMaxSpeed: ->
      return 0

    # Gets this Sprite's current animation frame
    getCurrentFrame: ->
      return @anim.getCurrentFrame()

    drawCurrentFrame: (context) ->
      cf = @anim.getCurrentFrame()
      context.drawImage @anim.image, cf.imgSlotX * @anim.width, cf.imgSlotY * @anim.height, @anim.width, @anim.height, @x, @y, @anim.width, @anim.height

    clone: ->
      return new Sprite anim: @anim.clone()
  }
