class Bun {
  /**
   * Bunny class. Draws and controls a bunny on an SVG element.
   * It appends it in the given container.
   * @param {HTMLElement} container
   */
  constructor(container) {
    container.innerHTML = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="-500 -500 1700 800">
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
  animation: rotate10 1.5s linear 0s infinite reverse;
}
#legs.walk #front-left-leg {
  animation: rotate10 1.5s linear 1s infinite reverse;
}
#legs.walk #back-right-leg {
  animation: rotate10 1.5s linear 0s infinite;
}
#legs.walk #back-left-leg {
  animation: rotate10 1.5s linear 1s infinite;
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

#speech {
  font-family: monospace;
  font-size: 7em;
  font-weight: 100;
}
#speech>foreignObject {
  border: 2px solid black;
  border-radius: 15%;
  padding: 50px;
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
      <foreignObject x="500" y="-475" width="675" height="600">
        <p id="speech-text" xmlns="http://www.w3.org/1999/xhtml">Text goes here</p>
      </foreignObject>
    </g>
  </g>
</svg>
`;
    const svg = container.children[0];
    svg.style.cssText = "height:100%;width:100%;margin:0;padding:0;display:block;";
    this.svg = svg;
    this.transform1 = this.svg.createSVGTransform();
    this.transform2 = this.svg.createSVGTransform();
    this.transform3 = this.svg.createSVGTransform();
    this.stransform1 = this.svg.createSVGTransform();
    this.stransform2 = this.svg.createSVGTransform();
    this.svg.querySelector("#group").transform.baseVal.appendItem(this.transform1);
    this.svg.querySelector("#group").transform.baseVal.appendItem(this.transform2);
    this.svg.querySelector("#group").transform.baseVal.appendItem(this.transform3);
    this.svg.querySelector("#speech").transform.baseVal.appendItem(this.stransform1);
    this.svg.querySelector("#speech").transform.baseVal.appendItem(this.stransform2);
    this.speed = 0.1; // units/ms
    this.animation = undefined;
    this.destination = [0, 0];
    this.position = [0, 0];
    this.facing = 1; // 1 for right -1 for left
    this.acting = false;
  }
  flip() {
    this.facing = -1 * this.facing;
    this.transform2.setScale(this.facing, 1);
    this.stransform2.setTranslate(this.facing === -1 ? -1675 : 0, 0);
    this.stransform1.setScale(this.facing, 1);
  }
  scale(sx = 1, sy) {
    sy = sy || sx;
    this.transform3.setScale(sx, sy);
  }
  startWalking() {
    this.svg.querySelector("#legs").classList.add("walk");
  }
  stopWalking() {
    this.svg.querySelector("#legs").classList.remove("walk");
  }
  blink() {
    toggleClass(this.svg.querySelector("#eyes"), "blink", 200);
  }
  wiggleNose() {
    toggleClass(this.svg.querySelector("#nose"), "wiggle", 500);
  }
  wiggleTail() {
    toggleClass(this.svg.querySelector("#tail"), "wiggle", 750);
  }
  wiggleEars() {
    toggleClass(this.svg.querySelector("#ears"), "wiggle", 500);
  }
  openMouth() {
    this.svg.querySelector("#mouth").classList.add("open");
  }
  closeMouth() {
    this.svg.querySelector("#mouth").classList.remove("open");
  }
  pageCoordinatesToSVGCoordinatesTransformation() {
    const { left, width, top, height } = this.svg.getBoundingClientRect();
    const P = [[left, left + width], [top, top + height]];
    const { x, y, width: svgw, height: svgh } = this.svg.viewBox.baseVal;
    const Q = [[x, x + svgw], [y, y + svgh]];
    return A => [
      (Q[0][1] - Q[0][0]) / (P[0][1] - P[0][0]) * (A[0] - P[0][0]) + Q[0][0],
      (Q[1][1] - Q[1][0]) / (P[1][1] - P[1][0]) * (A[1] - P[1][0]) + Q[1][0],
    ];
  }
  pageCoordinatesToSVGCoordinates(P) {
    return this.pageCoordinatesToSVGCoordinatesTransformation()(P);
  }
  startMoving(Q) {
    [this.destination[0], this.destination[1]] = Q;
    if ((Q[0] - this.position[0]) * this.facing < 0) {
      this.flip();
    }
    this.updatePosition.lastUpdate = undefined;
    this.animation = window.requestAnimationFrame((...args) => this.step(...args));
    this.startWalking();
  }
  stopMoving() {
    window.cancelAnimationFrame(this.animation)
  }
  startActingNatural() {
    this.acting = true;
    const foo = () => {
      this.naturalAction()();
      if (this.acting) {
        setTimeout(foo, Math.random() * 1000 + 750);
      }
    };
    foo();
  }
  stopActingNatural() {
    this.acting = false;
  }
  naturalAction() {
    const x = Math.random();
    if (x < 0.2) {
      return () => this.wiggleNose();
    }
    if (x < 0.3) {
      return () => this.blink();
    }
    if (x < 0.5) {
      return () => this.wiggleTail();
    }
    if (x < 0.7) {
      return () => this.wiggleEars();
    }
    if (x < 0.8) {
      return () => this.startMoving(this.pageCoordinatesToSVGCoordinates(getRandomPosition()));
    }
    return () => this.startMoving(this.pageCoordinatesToSVGCoordinates(getMousePosition()));
  }
  step(timestamp) {
    if (this.position[0] != this.destination[0] || this.position[1] != this.destination[1]) {
      this.updatePosition(timestamp);
      this.animation = window.requestAnimationFrame((...args) => this.step(...args));
    } else {
      this.stopWalking();
      this.animation = undefined;
    }
  }
  updatePosition(now) {
    const then = this.updatePosition.lastUpdate || now;
    const v = [this.destination[0] - this.position[0], this.destination[1] - this.position[1]];
    const s = (now - then) * this.speed;
    const d = Math.sqrt(v[0] ** 2 + v[1] ** 2);
    const m = Math.max(d, s);
    if (m > 0 && !(v[0] == 0 && v[1] == 0)) {
      this.position[0] += s * v[0] / m;
      this.position[1] += s * v[1] / m;
      this.transform1.setTranslate(this.position[0], this.position[1]);
    }
    this.updatePosition.lastUpdate = now;
  }
  speak(msg = "") {
    if (msg === "") {
      this.svg.querySelector("#speech").style.display = "none";
    } else {
      this.svg.querySelector("#speech").style.display = "";
      this.svg.querySelector("#speech-text").innerText = msg;
    }
  }
}

function toggleClass(el, className, milliseconds) {
  if (el.length === undefined) { el = [el]; }
  el.forEach(e => e.classList.add(className));
  setTimeout(() => el.forEach(e => e.classList.remove(className)), milliseconds);
}
function getRandomPosition() {
  return [
    document.body.offsetWidth * Math.random(),
    document.body.offsetHeight * Math.random()
  ];
}

function MouseHandler(event) {
  MouseHandler.P[0] = event.pageX;
  MouseHandler.P[1] = event.pageY;
}
MouseHandler.P = [0, 0];
document.addEventListener("mousemove", MouseHandler);
function getMousePosition() {
  return MouseHandler.P;
}

const div = document.createElement("div");
document.body.appendChild(div);
window.b = new Bun(div);
// pointerEvents: "none"
const styles = { width: "100vw", height: "100vh", top: "0", left: "0", overflow: "hidden", position: "absolute", zIndex: "9999" };
for (let k in styles) {
  div.style[k] = styles[k];
}
b.scale(0.5)
b.startMoving([500, 0])
// document.onclick = () => b.startMoving(b.pageCoordinatesToSVGCoordinates(getMousePosition()));
// b.startActingNatural()

