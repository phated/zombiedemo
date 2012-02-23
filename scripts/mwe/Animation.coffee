define [ 'dojo/_base/declare', 'mwe/AnimFrame' ], (declare, AnimFrame) ->
  declare 'Animation', null, {
    currFrameIndex: 0
    animTime: 0
    totalDuration: 0
    height: 64
    width: 64
    image: null
    
    # Creates a new Animation
    constructor: (args) ->
      declare.safeMixin @, args
      @start()

    # Adds an image to the animation with the specified duration (time to display the image)
    addFrame: (duration, imageSlotX, imageSlotY) ->
      @frames = [] if not @frames
      @totalDuration += duration
      @frames.push new AnimFrame {
        endTime: @totalDuration
        image: @image
        imgSlotX: imageSlotX
        imgSlotY: imageSlotY
      }

    # Starts this animation over from the beginning
    start: ->
      @animTime = 0
      @currFrameIndex = 0

    # Updates this animation's current image (frame), if neccesary
    update: (elapsedTime) ->
      if @frames.length > 1
        @animTime += elapsedTime
        if @animTime >= @totalDuration
          @animTime = @animTime % @totalDuration
          @currFrameIndex = 0
        while @animTime > @frames[@currFrameIndex].endTime
          @currFrameIndex++

    getCurrentFrame: ->
      return null if @frames.length is 0
      return @frames[@currFrameIndex]
  }
