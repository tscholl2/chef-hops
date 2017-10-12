const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
svg.innerHTML = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 805 462">
<style type="text/css">
@keyframes walk {
  0% {
    transform: rotate(-10deg)
  }
  50% {
    transform: rotate(20deg)
  }
  100% {
    transform: rotate(-10deg)
  }
}

#legs > path {
  transform-box: fill-box;
  transform-origin: 0% 0%;
}

#legs.walk #front-right-leg {
  animation: walk 2s linear 0s infinite reverse;
}

#legs.walk #front-left-leg {
  animation: walk 2s linear 1s infinite reverse;
}

#legs.walk #back-right-leg {
  animation: walk 2s linear 0s infinite;
}

#legs.walk #back-left-leg {
  animation: walk 2s linear 1s infinite;
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

#legs > path {
  transform-box: fill-box;
  transform-origin: 0% 0%;
}

@keyframes wiggle {
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
  animation: wiggle 0.5s linear 0s;
}



</style>
  <g id="group">
    <path id="left-ear" d="M426.5 229.5s-9.7-131.8-50.4-133.2c-40.8-1.4-83-8.2-85-8.2-1.9 0-44.6 28.5-21.1 59.8 23.5 31.3 138.3-19 142.6 81.5" stroke-width="5" stroke="#000" fill="#aa00d3"/>
    <path id="right-ear" d="M427.5 223.3s9.8-125.6 51.1-126.9c41.3-1.3 84.2-7.8 86.1-7.8 1.9 0 45.2 27.2 21.4 57-23.8 29.8-140.2-18.1-144.5 77.7" stroke-width="5" fill="#aa00d3" stroke="#000"/>
    <ellipse id="tail" cx="780.4" cy="271.1" rx="25" ry="25" stroke-width="5" stroke="#000" fill="#aa00d3"/>
    <g id="legs" stroke="#000" stroke-width="7" class="walk">
      <path id="front-right-leg" d="M432.2 405.8l-6 55"/>
      <path id="front-left-leg" d="M458.2 406.8l9 52"/>
      <path id="back-right-leg" d="M617.4 414.6l-12 47"/>
      <path id="back-left-leg" d="M635.4 413.6l14 45"/>
    </g>
    <ellipse id="body" cx="547.4" cy="303.85" rx="216" ry="132.25" stroke-width="5" stroke="#000" fill="#aa00d3"/>
    <path id="nose" d="M414.4 283.6l42.6.4c.4.6-20.6 28.6-21 28-.4-.6-21.6-28.4-21.6-28.4z" stroke-width="5" stroke="#000" fill="#f05"/>
    <g id="eyes">
      <circle id="right-eye" cx="465" cy="255" r="20" stroke-width="5" stroke="#000" fill="#fff"/>
      <circle id="right-pupil" cx="465" cy="255" r="5" fill="#000"/>
      <path id="right-eye-closed" stroke-width="5" stroke="#000" d="M485 255h-40"/>
      <circle id="left-eye" cx="400" cy="255" r="20" stroke-width="5" stroke="#000" fill="#fff"/>
      <circle id="left-pupil" cx="400" cy="255" r="5" fill="#000"/>
      <path id="left-eye-closed" stroke-width="5" stroke="#000" d="M380 255h40"/>
    </g>
    <path id="left-tooth" stroke-width="5" stroke="#000" fill="#fff" d="M421 317h13.8v32.5H421z"/>
    <path id="right-tooth" stroke-width="5" stroke="#000" fill="#fff" d="M434.8 317.3h14.8v26.3h-14.8z"/>
    <path id="left-mouth" d="M437.8 310.2c0 4.6-9 8.3-20.1 8.3-11.1 0-20.1-3.7-20.1-8.3 4.7 2.6 12.2 4.1 20.1 4.1 7.9 0 15.4-1.5 20.1-4.1z" stroke="#000"/>
    <path id="right-mouth" d="M475.6 311.5c0 4.6-9 8.3-20.117 8.3-11.11 0-20.12-3.694-20.12-8.25 4.7 2.6 12.2 4.1 20.1 4.1 7.9 0 15.4-1.5 20.1-4.1z" stroke="#000"/>
    <g id="hat" stroke-width="5" stroke="#000" fill="#fff">
      <path id="hat-base" d="M354.896 160.002l113.465-24.118 17.57 82.654-113.46 24.117z"/>
      <path id="hat-top" d="M409.058 78.74l-1.174.25c-6.08 1.7-10.954 5.702-12.8 10.49l-.78 3.54c.065-1.138.325-2.318.802-3.442-5.66-2.58-12.98-2.864-19.66-.626s-11.884 6.615-14.212 12.017c-10.047-2.06-21.45.57-29.297 6.94-7.867 6.27-10.997 15.11-7.846 22.73l1.67 3.02c-.6-.9-1.22-1.89-1.66-3.02l-.034.31c-7.603 2.23-12.95 7.86-13.405 13.89-.456 6.03 4.215 11.17 11.49 12.69l10.84-.47c-3.577.964-7.32 1.147-10.84.463-4.213 5.19-4.196 11.525.31 15.883 4.483 4.26 12.345 5.657 19.633 3.392l4.41-1.858c-1.383.702-2.787 1.31-4.41 1.856 5.393 4.682 13.308 7.293 21.955 7.09 8.67-.104 17.168-2.93 23.797-7.817 7.4 5.48 18.81 6.736 29.126 3.317 10.414-3.44 17.914-10.963 19.38-19.454l.16-4.533c.118 1.51.136 3.04-.16 4.535 8.064 1.866 17.3.107 24.167-4.624 6.866-4.73 10.314-11.6 9.02-18.172l-4.8-9.104-12.15-4.267c9.006 1.97 15.473 6.425 16.85 13.39 9.8-1.98 16.925-9.834 19.187-17.47 2.263-7.637-.79-15.27-8.103-19.848 1.61-4.944.354-9.89-3.3-13.61-3.654-3.724-9.426-5.87-15.86-5.833-2.574-5.38-9.224-8.77-16.97-8.66-7.746.116-15.372 3.68-19.425 9.14l-2.262 4.265c.493-1.535 1.22-2.917 2.264-4.263-4.27-2.774-10.26-3.545-15.99-2.123z"/>
    </g>
    <g id="speech">
      <path id="speech-bubble" d="M338.8 39c0-16.9-16.9-30.6-37.8-30.6H46.9c-10 0-19.6 3.2-26.7 8.9C13.1 23 9.1 30.8 9.1 38.9v122.2c0 16.9 16.9 30.6 37.8 30.6h154.5L309 269.4l-25.2-77.7H301c20.9 0 37.8-13.7 37.8-30.6V38.9z" stroke-width="5" stroke="#000" fill="#fff"/>
    </g>
  </g>
</svg>
`;
svg.style.cssText =
  "left:0;top:0;margin:0;overflow:hidden;height:100vh;width:100vw;position:absolute;z-index:9999999;pointer-events:none;";
document.body.appendChild(svg);

function toggleClass(el, className, milliseconds) {
  if (el.length === undefined) {
    el = [el];
  }
  el.forEach(e => e.classList.add(className));
  setTimeout(() => el.forEach(e => e.classList.remove(className)), milliseconds);
}

const Bunny = function() {
  return {
    startWalking: () => svg.querySelector("#legs").classList.add("walk"),
    stopWalking: () => svg.querySelector("#legs").classList.remove("walk"),
    blink: () => toggleClass(svg.querySelector("#eyes"), "blink", 200),
    wiggleNose: () => toggleClass(svg.querySelector("#nose"), "wiggle", 500),
    wiggleTail: () => toggleClass(svg.querySelector("#tail"), "wiggle", 750),
    wiggleEars: () => toggleClass(svg.querySelector("#ears"),"wiggle", 500),
  };
};

window.b = Bunny();
