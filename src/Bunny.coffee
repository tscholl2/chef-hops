SVG = require 'svg.js'

window.SV = SVG

class Bunny
  constructor: (@dom_svg_element) ->
    # scaled size
    @scale = 0.5
    #variable for speed, about ~ number of leg movements/second
    @leg_actions_per_second = 1.08
    #movment, about ~ 1px / second
    @pixels_per_second = 30.14
    #time for blink in ms
    @blink_speed = 200
    #also ms
    @ear_twitch_speed = 200
    #also ms
    @tail_twitch_speed = 200
    #animating monitor
    @in_motion = false
    @keep_moving = true
    @walking = false
    #svg element functions
    @draw = SVG @dom_svg_element
    @gp = @draw.group()
    # load svg
    @draw.svg '
  <g id="bunny">
    <path id="left-ear" style="fill:#aa00d3;stroke:#000;stroke-width:5;" d="m206.5,146.5c0,0 -9.65402,-131.81711 -50.41534,-133.17738c-40.76135,-1.35909 -83.02449,-8.15304 -84.95639,-8.15304c-1.92969,0 -44.62294,28.53739 -21.13054,59.79414c23.49153,31.25549 138.26692,-19.02534 142.55757,81.53629"/>
    <path id="right-ear" style="fill:#aa00d3;stroke:#000;stroke-width:5;" d="m220.77,120.553c0,0 9,-104.461 47,-105.539c38,-1.077 77.4,-6.461 79.20102,-6.461c1.79898,0 41.6,22.615 19.69901,47.385c-21.9,24.769 -128.9,-15.077 -132.9,64.615"/>
    <ellipse id="tail" style="fill:#aa00d3;stroke:#000;stroke-width:5;" cx="560.4" cy="183.1" rx="25" ry="25"/>
    <line id="front-right-leg" style="stroke:#000;stroke-width:5;" y2="372.8" x2="206.2" y1="317.8" x1="212.2"/>
    <line id="front-left-leg" style="stroke:#000;stroke-width:5;" y2="370.8" x2="247.2" y1="318.8" x1="238.2"/>
    <line id="back-right-leg" style="stroke:#000;stroke-width:5;" y2="373.6" x2="385.4" y1="326.6" x1="397.4"/>
    <line id="back-left-leg" style="stroke:#000;stroke-width:5;" y2="370.6" x2="429.4" y1="325.6" x1="415.4"/>
    <ellipse id="body" style="fill:#aa00d3;stroke:#000;stroke-width:5;" cx="327.4" cy="215.85001" rx="216" ry="132.24999"/>
    <path id="nose" style="fill:#ff0055;stroke:#000;stroke-width:5;" d="m194.4,195.6l42.6,0.4c0.4,0.6 -20.6,28.6 -21,28c-0.4,-0.6 -21.6,-28.4 -21.6,-28.4z"/>
    <ellipse id="right-eye" style="fill:#fff;stroke:#000;stroke-width:5;" cx="243.4" cy="154.6" rx="14" ry="13"/>
    <ellipse id="left-eye" style="fill:#fff;stroke:#000;stroke-width:5;" cx="181.4" cy="158.6" rx="14" ry="13"/>
    <line id="right-eye-closed" style="stroke:#000;stroke-width:5;" y2="155.1" x2="224.50969" y1="155.1" x1="262.65"/>
    <line id="left-eye-closed" style="stroke:#000;stroke-width:5;" x1="161.7" y1="157.95" x2="201.825" y2="157.95"/>
    <rect id="left-tooth" style="fill:#fff;stroke:#000;stroke-width:5;" height="32.5" width="13.75" y="229" x="201" />
    <rect id="right-tooth" style="fill:#fff;stroke:#000;stroke-width:5;" height="26.25" width="14.75" y="229.25" x="214.75"/>
    <path id="left-mouth" style="fill:#000;stroke:#000;stroke-width:1;" d="m201.78802,246.43767l0,0c-4.55635,0 -8.25,-9.00677 -8.25,-20.11748c0,-11.11052 3.69365,-20.11821 8.25,-20.11821l0,0c-2.59677,4.74933 -4.12495,12.20262 -4.12495,20.11821c0,7.91501 1.52818,15.3683 4.12495,20.11748z" transform="rotate(-90 197.663,226.32)"/>
    <path id="right-mouth" style="fill:#000;stroke:#000;stroke-width:1;" d="m239.625,247.71785l0,0c-4.55635,0 -8.25,-9.00677 -8.25,-20.11748c0,-11.11052 3.69365,-20.11821 8.25,-20.11821l0,0c-2.59677,4.74933 -4.12495,12.20262 -4.12495,20.11821c0,7.91501 1.52818,15.3683 4.12495,20.11748z" transform="rotate(-90 235.5,227.6)"/>
    <g id="hat" style="fill:#fff;stroke:#000;stroke-width:5;">
      <rect id="hat-base" x="142.43777" y="59.01887" width="116.07743" height="84.5104" transform="rotate(-12 200.47648620605466,101.27407073974605) "/>
      <path id="hat-top" d="m199.89313,-6.32598c-0.39308,0.00887 -0.77303,0.03254 -1.16768,0.06061c-6.31784,0.4493 -11.89331,3.31197 -14.72612,7.57754l-1.50169,3.22804c0.3239,-1.11866 0.82164,-2.20358 1.50169,-3.22804c-5.05145,-3.73704 -12.14139,-5.4619 -19.14746,-4.6526c-7.00578,0.8093 -13.09013,4.05494 -16.41527,8.75963c-9.38655,-4.128 -21.0876,-3.87799 -30.13929,0.65166c-9.05254,4.52967 -13.8771,12.54979 -12.41093,20.64121l0.95968,3.28865c-0.43382,-1.07739 -0.75715,-2.17345 -0.95968,-3.28865l-0.14598,0.30309c-7.86842,0.61228 -14.32182,4.97156 -15.99786,10.80556c-1.67638,5.83406 1.80916,11.82014 8.63536,14.83684l10.65836,1.84893c-3.72173,0.21873 -7.43742,-0.42536 -10.65836,-1.84893c-5.2652,4.21118 -6.47686,10.44576 -3.00336,15.59459c3.47268,5.1488 10.88985,8.11351 18.54233,7.44107l4.65134,-0.87897c-1.49653,0.44727 -3.05069,0.73836 -4.65134,0.87897c4.34411,5.71018 11.5472,9.87553 20.00281,11.53304c8.45547,1.6575 17.43643,0.6779 24.92491,-2.71273c6.10928,6.87891 16.95181,10.49203 27.82465,9.27486c10.87265,-1.21719 19.84149,-7.05375 23.02728,-14.97321l1.10498,-4.42524c-0.16533,1.50338 -0.52449,2.98146 -1.10498,4.42524c7.47829,3.50181 16.88496,3.6991 24.61223,0.51529c7.7265,-3.18383 12.54837,-9.25501 12.61896,-15.86737l-2.77,-9.87977l-10.91284,-6.6847c8.43834,3.77422 13.75818,9.52462 13.68285,16.56447c10.03357,0.07511 18.55652,-6.06371 22.38046,-13.1091c3.82425,-7.04539 2.3775,-15.07754 -3.79636,-21.11101c2.56116,-4.49218 2.40912,-9.60201 -0.41684,-14.00329c-2.82632,-4.40129 -8.03897,-7.67253 -14.30841,-8.95665c-1.40297,-5.83335 -7.18668,-10.52566 -14.83026,-12.06343c-7.64319,-1.53779 -15.7821,0.35843 -20.89951,4.87993l-3.10783,3.74331c0.79404,-1.35367 1.8311,-2.61541 3.10783,-3.74331c-3.60754,-3.55356 -9.26573,-5.55871 -15.16368,-5.42552l0,-0.0l0.0,0.0z" transform="rotate(-12 180.37095642089847,43.84471130371094) "/>
    </g>
    <g id="speech">
      <path id="speech-bubble" style="fill:#fff;stroke:#000;stroke-width:5;" d="m118.82401,-48.98154l0,0c0,-16.87277 -16.90808,-30.55244 -37.76694,-30.55244l-17.16771,0l0,0l-82.4024,0l-154.50606,0c-10.01721,0 -19.62421,3.21989 -26.7061,8.94915c-7.08371,5.72889 -11.06294,13.50082 -11.06294,21.60329l0,76.38033l0,0l0,45.828l0,0c0,16.87402 16.90967,30.55183 37.76904,30.55183l154.50606,0l107.64925,77.68738l-25.24684,-77.68738l17.16771,0c20.85886,0 37.76694,-13.67781 37.76694,-30.55183l0,0l0,-45.828l0,0l0,-76.38033z"/>
      <text id="speech-text" style="fill:#000;" font-weight="normal" xml:space="preserve" text-anchor="middle" font-family="serif" font-size="30" y="-25" x="-55"></text>
    </g>
  </g>
'
    @gp = SVG.get "bunny"
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

  Click: (callback) ->
    @gp.click callback

  ActNatural: (forever) ->
    @in_motion = true
    actions = [
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
    if forever? and forever == true
      @keep_moving = true
    actions[Math.floor (Math.random() * actions.length)] =>
      @in_motion = false
    if @keep_moving
      _f = =>
        @ActNatural()
      setTimeout _f, Math.random() * 1000 + 750

  Stop: ->
    @keep_moving = false

  Say: (msg, cb) ->
    @speechText.text msg
    @speech.show()
    setTimeout (=> @speech.hide()), 5000

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
    @nose.animate @tail_twitch_speed
    .during (v,m) => @nose.transform {rotation:m(0,angle),cx:210,cy:215,relative:false}
    .after =>
      @nose.animate @ear_twitch_speed, '-' #-: linear, <>: ease in/out, =: external, or a function for easing
      .during (v,m) => @nose.transform {rotation:m(angle,0),cx:210,cy:215,relative:false}
      .after ->
        return callback?()

  TwitchEars: (callback) ->
    dir = if Math.random() < 0.5 then -1 else 1
    @TwitchEar @left_ear, dir
    @TwitchEar @right_ear, -1 * dir, callback

  TwitchEar: (e,dir,callback) ->
    if not e?
      e = if Math.random() < 0.5 then @left_ear else @right_ear
    angle = 10 * (dir or if Math.random()<0.5 then 1 else -1)
    e.animate @ear_twitch_speed
    .during (v,m) => e.transform {rotation:m(0,angle),cx:200,cy:100,relative:false}
    .after =>
      e.animate @ear_twitch_speed, '-' #-: linear, <>: ease in/out, =: external, or a function for easing
      .during (v,m) => e.transform {rotation:m(angle,0),cx:200,cy:100,relative:false}
      .after ->
        return callback?()

  TwitchTail: (callback) ->
    angle = if Math.random() < 0.5 then 10 else -10
    @tail.animate 150
    .during (v,m) => @tail.transform {rotation:m(0,angle),cx:541,cy:200,relative: false}
    .rotate if Math.random() < 0.5 then 10 else -10
    .after =>
      @tail.animate @tail_twitch_speed, '-'
      .during (v,m) => @tail.transform {rotation:m(angle,0),cx:541,cy:200,relative: false}
      .after ->
        return callback?()

  Walk: (callback) ->
    if @walking
      return callback?()
    x = Math.random() * window.innerWidth #document.getElementById("main-screen").scrollHeight
    y = Math.random() * window.innerHeight #document.getElementById("main-screen").scrollWidth
    d = Math.sqrt (x - @gp.cx())*(x - @gp.cx())+(y - @gp.cy())*(y - @gp.cy())
    duration = 1000 * d * 1.0 / @pixels_per_second
    return @WalkTo x, y, duration, callback

  #walks to the given position
  #treat like center = (x,y)
  WalkTo: (x,y,duration,callback) ->
    if not x? or not y?
      x = Math.random() * window.innerWidth
      y = Math.random() * window.innerHeight
    if not duration?
      d = Math.sqrt (x - @gp.cx())*(x - @gp.cx())+(y - @gp.cy())*(y - @gp.cy())
      duration = 1000 * d * 1.0 / @pixels_per_second
    #console.log "moving to #{x}, #{y} time taken: #{d}"
    @gp.animate duration
    .dmove x - @gp.cx(), y - @gp.cy()
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

module.exports = Bunny
