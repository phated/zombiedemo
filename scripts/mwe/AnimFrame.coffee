define [ 'dojo/_base/declare' ], (declare) ->
  declare 'AnimFrame', null, {
    endTime: 0
    imgSlotX: 0
    imgSlotY: 0
    image: null
    
    constructor: (args) ->
      declare.safeMixin @, args
  }