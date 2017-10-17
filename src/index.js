const container = document.createElement("div");
container.innerHTML = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="-500 -500 2000 800">
<style type="text/css">
@keyframes rotate10 {
  0% {
    transform: rotate(0deg)
  }
  25% {
    transform: rotate(10deg)
  }
  75% {
    transform: rotate(-10deg)
  }
  100% {
    transform: rotate(0deg)
  }
}

#legs > path {
  transform-box: fill-box;
  transform-origin: 0% 0%;
}
#legs.walk #front-right-leg {
  animation: rotate10 2s linear 0s infinite reverse;
}
#legs.walk #front-left-leg {
  animation: rotate10 2s linear 1s infinite reverse;
}
#legs.walk #back-right-leg {
  animation: rotate10 2s linear 0s infinite;
}
#legs.walk #back-left-leg {
  animation: rotate10 2s linear 1s infinite;
}
#legs > path {
  transform-box: fill-box;
  transform-origin: 0% 0%;
}

#eyes>path {
  display: none;
}
#eyes.blink>path {
  display: inherit;
}
#eyes.blink>circle {
  display: none;
}

@keyframes rotate20 {
  0% {
    transform: rotate(0deg)
  }
  25% {
    transform: rotate(20deg)
  }
  75% {
    transform: rotate(-20deg)
  }
  100% {
    transform: rotate(0deg)
  }
}

#nose {
  transform-box: fill-box;
  transform-origin: 50% 50%;
}
#nose.wiggle {
  animation: rotate20 0.5s linear 0s;
}


#tail {
  transform-box: fill-box;
  transform-origin: 62% 50%;
}
#tail.wiggle {
  animation: rotate20 0.75s linear 0s infinite;
}

#ears>path {
  transform-box: fill-box;
  transform-origin: 50% 100%;
}
#ears.wiggle>path {
  animation: rotate10 0.5s linear 0s;
}

#mouth>ellipse {
  display:none;
}
#mouth.open>path {
  display:none;
}
#mouth.open>ellipse {
  display:inherit;
}

#speech>text {
  font-family: monospace;
  font-size: 6em;
}

</style>
  <g id="group" stroke-width="10" stroke="#000">
    <g id="ears">
      <path id="right-ear" d="M 200 -150 l 250 -250 a 50 50 0 0 0 -100 -50 z" fill="#a0d"/>
      <path id="left-ear" d="M 200 -150 l -250 -250 a 50 50 0 0 1 100 -50 z" fill="#a0d"/>
    </g>
    <circle id="tail" cx="-440" cy="0" r="50" fill="#a0d"/>
    <g id="legs">
      <path id="front-right-leg" d="M 200 200 l 0 75"/>
      <path id="front-left-leg" d="M 150 200 l 0 75"/>
      <path id="back-right-leg" d="M -150 200 l 0 75"/>
      <path id="back-left-leg" d="M -200 200 l 0 75"/>
    </g>
    <ellipse id="body" cx="0" cy="0" rx="400" ry="250" fill="#a0d"/>
    <g id="eyes">
      <circle id="right-eye" cx="255" cy="-100" r="45" fill="#fff"/>
      <circle id="right-pupil" cx="255" cy="-100" r="5" fill="#000"/>
      <path id="right-eye-closed" d="M 210 -100 h 90"/>
      <circle id="left-eye" cx="145" cy="-100" r="45" fill="#fff"/>
      <circle id="left-pupil" cx="145" cy="-100" r="5" fill="#000"/>
      <path id="left-eye-closed" d="M 100 -100 h 90"/>
    </g>
    <path id="nose" d="M175 -40 h 50 l -25 25 z" fill="#f05"/>
    <g id="hat" fill="#fff">
      <rect id="hat-base" x="100" y="-375" width="200" height="200" />
      <ellipse id="hat-top-1" cx="200" cy="-375" rx="200" ry="75" />
    </g>
    <g id="mouth">
      <ellipse id="mouth-open" cx="200" cy="30" rx="80" ry="20" />
      <path id="mouth-closed" d="M 145 20 h 110 " />
    </g>
    <g id="speech">
      <text x="500" y="-200">
        <!--tspan>hello world</tspan-->
      </text>
    </g>
  </g>
</svg>
`;
const svg = container.children[0];
svg.style.cssText = "left:0;top:0;margin:0;overflow:hidden;height:100vh;width:100vw;position:absolute;z-index:9999999;pointer-events:none;";
document.body.appendChild(svg);

const Bunny = function (svg) {

  const position = [0, 0];
  const destination = [0, 0];
  const transform1 = svg.createSVGTransform();
  const transform2 = svg.createSVGTransform();
  const transform3 = svg.createSVGTransform();
  svg.querySelector("#group").transform.baseVal.appendItem(transform1);
  svg.querySelector("#group").transform.baseVal.appendItem(transform2);
  svg.querySelector("#group").transform.baseVal.appendItem(transform3);

  const self = {
    // attributes
    speed: 0.1, // units/ms
    animation: undefined,
    svg,
    destination,
    position,
    transform1,
    transform2,
    transform3,
    // methods
    flip: (() => { let t = 1; return () => transform2.setScale(t = -t, 1) })(),
    scale: (sx = 1, sy) => {
      sy = sy || sx;
      transform3.setScale(sx, sy);
    },
    startWalking: () => svg.querySelector("#legs").classList.add("walk"),
    stopWalking: () => svg.querySelector("#legs").classList.remove("walk"),
    blink: () => toggleClass(svg.querySelector("#eyes"), "blink", 200),
    wiggleNose: () => toggleClass(svg.querySelector("#nose"), "wiggle", 500),
    wiggleTail: () => toggleClass(svg.querySelector("#tail"), "wiggle", 750),
    wiggleEars: () => toggleClass(svg.querySelector("#ears"), "wiggle", 500),
    openMouth: () => svg.querySelector("#mouth").classList.add("open"),
    closeMouth: () => svg.querySelector("#mouth").classList.remove("open"),
    startMoving: (x, y) => {
      [destination[0], destination[1]] = [x, y];
      updatePosition.lastUpdate = undefined;
      animation = window.requestAnimationFrame(step);
    },
    stopMoving: () => window.cancelAnimationFrame(animation),
    naturalAction: () => {
      const x = Math.random()
      if (x < 0.3) {
        return self.blink;
      }
      if (x < 0.5) {
        return self.wiggleTail;
      }
      if (x < 0.7) {
        return self.wiggleEars;
      }
      return self.startWalking;
    },
  };
  return self;


  function step(timestamp) {
    if (distance(position, destination) != 0) {
      updatePosition(timestamp);
      self.animation = window.requestAnimationFrame(step);
    } else {
      self.animation = undefined;
    }
  }

  function updatePosition(now) {
    const then = updatePosition.lastUpdate || now;
    const v = [
      destination[0] - position[0],
      destination[1] - position[1],
    ];
    const s = (now - then) * self.speed
    const m = Math.max(distance(v, [0, 0]), s);
    if (m > 0 && !(v[0] == 0 && v[1] == 0)) {
      position[0] += s * v[0] / m;
      position[1] += s * v[1] / m;
      transform1.setTranslate(position[0], position[1]);
    }
    updatePosition.lastUpdate = now;
  }

  function toggleClass(el, className, milliseconds) {
    if (el.length === undefined) {
      el = [el];
    }
    el.forEach(e => e.classList.add(className));
    setTimeout(() => el.forEach(e => e.classList.remove(className)), milliseconds);
  }

  function distance(P, Q) {
    return Math.sqrt((P[0] - Q[0]) ** 2 + (P[1] - Q[1]) ** 2);
  }

};


/**
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

 */

window.b = Bunny(svg);
