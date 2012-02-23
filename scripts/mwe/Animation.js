
define(['dojo/_base/declare', 'mwe/AnimFrame'], function(declare, AnimFrame) {
  return declare('Animation', null, {
    currFrameIndex: 0,
    animTime: 0,
    totalDuration: 0,
    height: 64,
    width: 64,
    image: null,
    constructor: function(args) {
      declare.safeMixin(this, args);
      return this.start();
    },
    createFromTile: function(frameCount, frameTimes, img, h, w, ySlot) {
      var anim, currentFrameTime, isFTArray, j, _i, _len;
      anim = new Animation({
        image: img,
        height: h,
        width: w
      });
      isFTArray = Array.isArray(frameTimes);
      currentFrameTime = 1;
      if (!ySlot) ySlot = 0;
      for (_i = 0, _len = frameCount.length; _i < _len; _i++) {
        j = frameCount[_i];
        if (isFTArray) {
          currentFrameTime = frameTimes[j];
        } else {
          currentFrameTime = frameTimes;
        }
        anim.addFrame(currentFrameTime, j, ySlot);
      }
      return anim;
    },
    clone: function() {
      return new Animation({
        image: this.image,
        frames: this.frames,
        totalDuration: this.totalDuration
      });
    },
    addFrame: function(duration, imageSlotX, imageSlotY) {
      if (!this.frames) this.frames = [];
      this.totalDuration += duration;
      return this.frames.push(new AnimFrame({
        endTime: this.totalDuration,
        image: this.image,
        imgSlotX: imageSlotX,
        imgSlotY: imageSlotY
      }));
    },
    start: function() {
      this.animTime = 0;
      return this.currFrameIndex = 0;
    },
    update: function(elapsedTime) {
      var _results;
      if (this.frames.length > 1) {
        this.animTime += elapsedTime;
        if (this.animTime >= this.totalDuration) {
          this.animTime = this.animTime % this.totalDuration;
          this.currFrameIndex = 0;
        }
        _results = [];
        while (this.animTime > this.getFrame(this.currFrameIndex).endTime) {
          _results.push(this.currFrameIndex++);
        }
        return _results;
      }
    },
    getImage: function() {
      return this.image;
    },
    getFrame: function(i) {
      return this.frames[i];
    },
    getCurrentFrame: function() {
      if (this.frames.length === 0) return null;
      return this.getFrame(this.currFrameIndex);
    }
  });
});
