SVG = require 'svg.js'
RAW_SVG = require 'raw!../resources/bunny.svg'
MousePosition = require './mouse'

module.exports = class Bunny
  constructor: (@el) ->
    # scaled size
    @scale = 0.5 # use .Scale() method to change
    # variable for speed, about ~ number of leg movements/second
    @leg_actions_per_second = 1.08
    # movment, about ~ 1px / second
    @pixels_per_second = 30.14
    # timing in ms
    @blink_speed = 200
    @ear_twitch_speed = 200
    @nose_wiggle_speed = 200
    @tail_twitch_speed = 200
    # animating monitoring
    @action_timer = null
    # svg element functions
    @draw = SVG @el
    @gp = @draw.group()
    # load svg
    @draw.svg RAW_SVG
    @gp = SVG.get "group"
    @inner_gp = SVG.get "inner-group"
    @outer_gp = SVG.get "outer-group"
    # body parts
    @left_ear = SVG.get 'left-ear'
    .style "pointer-events: visiblefill;"
    @right_ear = SVG.get 'right-ear'
    .style "pointer-events: visiblefill;"
    @tail = SVG.get 'tail'
    .style "pointer-events: visiblefill;"
    @body = SVG.get 'body'
    .style "pointer-events: visiblefill;"
    @nose = SVG.get 'nose'
    @left_mouth = SVG.get 'left-mouth'
    @right_mouth = SVG.get 'right-mouth'
    @left_tooth = SVG.get 'left-tooth'
    @right_tooth = SVG.get 'right-tooth'
    @right_eye = SVG.get 'right-eye'
    @left_eye = SVG.get 'left-eye'
    @front_left_leg = SVG.get 'front-left-leg'
    @front_right_leg = SVG.get 'front-right-leg'
    @back_left_leg = SVG.get 'back-left-leg'
    @back_right_leg = SVG.get 'back-right-leg'
    @right_eye_closed = SVG.get 'right-eye-closed'
    .hide()
    @left_eye_closed = SVG.get 'left-eye-closed'
    .hide()
    @speech = SVG.get 'speech'
    .hide()
    @speechText = SVG.get 'speech-text'
    @chef_hat = SVG.get 'hat'
    @gp.scale @scale
    .style "display: block"
    # bounding box
    @w = @tail.bbox().x + @tail.bbox().w
    @h = @front_left_leg.bbox().y + @front_left_leg.bbox().h

  onClick: (callback) ->
    @gp.click callback

  Scale: (s) ->
    if not s? then return @scale
    @scale = s
    @gp.scale s

  regularActions: -> [
    (callback) => @Blink callback
    (callback) => @Blink callback
    (callback) => @Blink callback
    (callback) => @TwitchTail callback
    (callback) => @TwitchTail callback
    (callback) => @WiggleNose callback
    (callback) => @WiggleNose callback
    (callback) => @TwitchEars callback
    (callback) => @TwitchEars callback
    (callback) => @Walk callback
  ]

  ActNatural: () ->
    @regularActions()[Math.floor (Math.random() * @regularActions().length)]()
    @action_timer = setTimeout (=> @ActNatural()), Math.random() * 1000 + 750

  Stop: ->
    clearTimeout @action_timer

  Say: (msg, callback, audioFile) ->
    @speechText.text msg
    @speech.show()
    if audioFile?
      a = new Audio audioFile
      a.play()
      a.onended = => @speech.hide() and callback?()
    else
      setTimeout (=> @speech.hide() and callback?()), 5000

  Blink: (callback) ->
    @right_eye_closed.show()
    @left_eye_closed.show()
    @right_eye.hide()
    @left_eye.hide()
    setTimeout (=> @Unblink callback), @blink_speed

  Unblink: (callback) ->
    @right_eye_closed.hide()
    @left_eye_closed.hide()
    @right_eye.show()
    @left_eye.show()
    return callback?()

  WiggleNose: (callback) ->
    angle = if Math.random() < 0.5 then -10 else 10
    anchor = [@nose.bbox().cx,@nose.bbox().h+@nose.bbox().y]
    @nose.animate @nose_wiggle_speed, '-'
    .during (v,m) =>
      @nose.transform {rotation:m(0,angle),cx:anchor[0],cy:anchor[1],relative:false}
    .after =>
      # -: linear, <>: ease in/out, =: external, or a function for easing
      @nose.animate @nose_wiggle_speed, '-'
      .during (v,m) =>
        @nose.transform {rotation:m(angle,0),cx:anchor[0],cy:anchor[1],relative:false}
      .after ->
        return callback?()

  TwitchEars: (callback) ->
    dir = if Math.random() < 0.5 then -1 else 1
    @TwitchEar @left_ear, dir
    @TwitchEar @right_ear, -1 * dir, callback

  TwitchEar: (e,dir,callback) ->
    if not e?
      e = if Math.random() < 0.5 then @left_ear else @right_ear
    anchor = [e.bbox().cx,e.bbox().cy]
    angle = 10 * (dir or if Math.random()<0.5 then 1 else -1)
    e.animate @ear_twitch_speed
    .during (v,m) => e.transform {rotation:m(0,angle),cx:anchor[0],cy:anchor[1],relative:false}
    .after =>
      e.animate @ear_twitch_speed, '-' # -: linear, <>: ease in/out, =: external, or a function for easing
      .during (v,m) => e.transform {rotation:m(angle,0),cx:anchor[0],cy:anchor[1],relative:false}
      .after ->
        return callback?()

  TwitchTail: (callback) ->
    angle = if Math.random() < 0.5 then 10 else -10
    anchor = [@tail.bbox().x,@tail.bbox().cy]
    @tail.animate 150
    .during (v,m) => @tail.transform {rotation:m(0,angle),cx:anchor[0],cy:anchor[1],relative: false}
    .rotate if Math.random() < 0.5 then 10 else -10
    .after =>
      @tail.animate @tail_twitch_speed, '-'
      .during (v,m) => @tail.transform {rotation:m(angle,0),cx:anchor[0],cy:anchor[1],relative: false}
      .after ->
        return callback?()

  randomPosition: ->
    x = Math.random() * (@el.clientWidth - @w*@Scale())
    y = Math.random() * (@el.clientHeight - @h*@Scale())
    return [x,y]

  setHeading: (x) ->
    x0 =  @gp.transform().x
    facingRight = @outer_gp.transform().skewY isnt 0
    if (x0 > x and facingRight) or (x0 < x and not facingRight)
      @outer_gp.flip "x"
      @speechText.flip "x"

  Walk: (callback, towardsMouse) ->
    if towardsMouse
      x = MousePosition().x - @w/2
      y = MousePosition().y - @h/2
    else
      [x,y] = @randomPosition()
    return @WalkTo x, y, null, callback

  # walks to the given position
  # treat like center = (x,y)
  WalkTo: (x,y,duration,callback) ->
    if not duration?
      d = Math.sqrt (x - @gp.x())*(x - @gp.x())+(y - @gp.y())*(y - @gp.y())
      duration = 1000 * d * 1.0 / @pixels_per_second
    @setHeading x
    @gp.animate duration
    .transform x: x, y: y
    .after ->
      @walking = false
      return callback?()
    @Run duration

  Run: (duration,callback) ->
    if not duration?
      duration = 1000
    i = parseInt(@leg_actions_per_second * duration * 1.0 / 1000)
    leg_speed = 1000 * 1.0 / @leg_actions_per_second
    @_run1 i,leg_speed/2, callback

  _run1: (i,leg_speed,callback) ->
    if i <= 0
      return callback?()
    @front_left_leg.animate leg_speed, '-'
    .during (v,m) => @front_left_leg.transform {rotation: 20*v, relative: false}
    @front_right_leg.animate leg_speed, '-'
    .during (v,m) => @front_right_leg.transform {rotation: -20*v, relative: false}
    @back_left_leg.animate leg_speed, '-'
    .during (v,m) => @back_left_leg.transform {rotation: 20*v, relative: false}
    @back_right_leg.animate leg_speed, '-'
    .during (v,m) => @back_right_leg.transform {rotation: -20*v, relative: false}
    .after =>
      @_run2 i,leg_speed, callback

  _run2: (i,leg_speed,callback) ->
    if i <= 0
      return callback?()
    @front_left_leg.animate leg_speed, '-'
    .during (v,m) => @front_left_leg.transform {rotation: 20-20*v, relative: false}
    @front_right_leg.animate leg_speed, '-'
    .during (v,m) => @front_right_leg.transform {rotation: -20+20*v, relative: false}
    @back_left_leg.animate leg_speed, '-'
    .during (v,m) => @back_left_leg.transform {rotation: 20-20*v, relative: false}
    @back_right_leg.animate leg_speed, '-'
    .during (v,m) => @back_right_leg.transform {rotation: -20+20*v, relative: false}
    .after =>
      @_run1 i-1,leg_speed, callback