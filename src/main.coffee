svg = document.createElement "svg"
svg.id = "svg1"
svg.style.left = "0px"
svg.style.top = "0px"
svg.style.margin = "0px"
svg.style.overflow = "hidden"
svg.style.height = "100%"
svg.style.width = "100%"
svg.style.position = "absolute"
svg.style.zIndex = "9999999"
svg.style.pointerEvents = "none"
document.body.appendChild svg

Bunny = require './bunny'
b = new Bunny svg
b.Scale 0.5
#b.ActNatural()

window.b = b
