
define(['dojo/_base/declare', 'mwe/Animation'], function(declare, Animation) {
  return declare('Sprite', null, {
    x: 0.0,
    y: 0.0,
    dx: 0.0,
    dy: 0.0,
    name: null,
    collisionRadius: 40,
    constructor: function(args) {
      return declare.safeMixin(this, args);
    },
    update: function(elapsedTime) {
      this.x += this.dx * elapsedTime;
      this.y += this.dy * elapsedTime;
      return this.anim.update(elapsedTime);
    },
    getX: function() {
      return this.x;
    },
    getY: function() {
      return this.y;
    },
    setX: function(x) {
      return this.x = x;
    },
    setY: function(y) {
      return this.y = y;
    },
    getWidth: function() {
      return this.anim.width;
    },
    getHeight: function() {
      return this.anim.height;
    },
    getVelocityX: function() {
      return this.dx;
    },
    getVelocityY: function() {
      return this.dy;
    },
    limitSpeed: function(v) {
      if (this.getMaxSpeed()) {
        if (Math.abs(v > this.getMaxSpeed())) {
          if (v !== 0) {
            return this.getMaxSpeed();
          } else {
            return 0;
          }
        } else {
          return v;
        }
      } else {
        return v;
      }
    },
    getMaxSpeed: function() {
      return this.maxSpeed;
    },
    getCurrentFrame: function() {
      return this.anim.getCurrentFrame();
    },
    drawCurrentFrame: function(context) {
      var cf;
      cf = this.anim.getCurrentFrame();
      return context.drawImage(this.anim.image, cf.imgSlotX * this.anim.width, cf.imgSlotY * this.anim.height, this.anim.width, this.anim.height, this.x, this.y, this.anim.width, this.anim.height);
    },
    clone: function() {
      return new mwe.Sprite({
        anim: this.anim.clone()
      });
    }
  });
});
