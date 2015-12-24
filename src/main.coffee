
svg = document.createElement "svg"
svg.style.left = "0px"
svg.style.top = "0px"
svg.style.overflow = "hidden"
svg.style.height = "100%"
svg.style.width = "100%"
svg.style.position = "absolute"
svg.style.zIndex = "9999999"
svg.style.pointerEvents = "none"
document.body.appendChild svg

B = require './Bunny'
window.b = new B svg
window.b.ActNatural()
