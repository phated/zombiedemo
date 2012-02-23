###
Copyright 2011 Luis Montes

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
###
define [ 'dojo/_base/declare' ], (declare) ->
  declare 'GameAction', null, {
    name: null
    behavior: 0
    amount: 0
    state: 0
    statics: {
      # Normal behavior. isPressed() returns true as long as the key is held down
      NORMAL: 0
      # Initial press behavior. isPressed() returns true only after the key is first pressed, and not again until the key is released and pressed again
      DETECT_INITIAL_PRESS_ONLY: 1
      STATE_RELEASED: 0
      STATE_PRESSED: 1
      STATE_WAITING_FOR_RELEASE: 2
    }
    
    # Creates new game action
    constructor: (args) ->
      declare.safeMixin @, args
      @reset()
      
    # Gets the name of this GameAction
    getName: ->
      return @name
      
    # Resets this GameAction so that it appears like it hasn't been pressed
    reset: ->
      @state = @statics.STATE_RELEASED
      @amount = 0
      
    # Taps this GameAction. Same as calling press() followed by release()
    tap: ->
      @press()
      @release()
      
    # Signals that the key was pressed
    press: ->
      @state = @statics.STATE_PRESSED
      
    # Signals that the key was pressed a specified number of times, or that the mouse was moved a specified distance
    pressAmt: (amount) ->
      if @state isnt @statics.STATE_WAITING_FOR_RELEASE
        @amount += amount
        @state = @statics.STATE_PRESSED
        
    # Signals that the key was released
    release: ->
      @state = @statics.STATE_RELEASED
      
    # Returns whether the key was pressed or not since last checked
    isPressed: ->
      return true if @state is @statics.STATE_PRESSED
      return false
      
    # For keys, this is the number of times the key was pressed since it was last checked.
    # For mouse movement, this is the distance moved.
    getAmount: ->
      retVal = @amount
      if retVal isnt 0
        if @state is @statics.STATE_RELEASED
          amount = 0
        else if @behavior is @statics.DETECT_INITIAL_PRESS_ONLY
          @state = @statics.STATE_WAITING_FOR_RELEASE
          @amount = 0
      return retVal
  }