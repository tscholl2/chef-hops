svg = document.createElement "svg"
svg.style.left = "25%"
svg.style.top = "25%"
svg.style.overflow = "hidden"
svg.style.height = "50%"
svg.style.width = "50%"
svg.style.backgroundColor = "green"
svg.style.position = "absolute"
svg.style.zIndex = "9999999"
svg.style.pointerEvents = "none"
document.body.appendChild svg

Bunny = require './Bunny'
b = new Bunny svg
b.Scale(0.33)
#b.ActNatural()

window.b = b

window.m = require './mouse'
