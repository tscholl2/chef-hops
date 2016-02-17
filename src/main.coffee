svg = document.createElement "svg"
svg.style.left = "0px"
svg.style.top = "0px"
svg.style.overflow = "hidden"
svg.style.height = "100%"
svg.style.width = "100%"
svg.style.backgroundColor = "green"
svg.style.position = "absolute"
svg.style.zIndex = "9999999"
svg.style.pointerEvents = "none"
document.body.appendChild svg

Bunny = require './Bunny'
b = new Bunny svg
b.ActNatural()

window.b = b

window.m = require './mouse'
