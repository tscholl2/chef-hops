SVG = require 'svg.js'

window.SV = SVG

module.exports = class Dino
  constructor: (@dom_svg_element) ->
    #colors for body elements
    @body_color = "#aa00d3"
    #svg element functions
    @draw = SVG @dom_svg_element
    @gp = @draw.group()
    pencil_options =
        fill: "none"
        stroke: "#000000"
        "stroke-width": 5
    #body parts
    console.log @gp
    @body = @gp.svg '
      <g>
      	<path fill="#698000" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="M-381.898,318.115
      		c0.006,25.82-20.925,46.756-46.744,46.755c-25.82-0.001-46.749-20.938-46.739-46.76c-0.007-25.82,20.924-46.754,46.744-46.753
      		S-381.888,292.296-381.898,318.115z"/>
      	<path fill-opacity="0.3137" d="M-384.721,302.08c0.031,0.717-0.004,1.45,0.053,2.174c2.83,36.477-20.939,54.841-46.742,54.84
      		c-20.168-0.001-39.93-18.749-43.925-38.814c1.131,24.799,21.621,44.581,46.698,44.582c25.801,0.002,46.739-20.936,46.741-46.737
      		C-381.896,312.49-382.893,307.083-384.721,302.08z"/>
      </g>'
    .attr pencil_options
    .fill @body_color
    .style "pointer-events: visiblefill"
    console.log @body

  Click: (callback) ->
    @gp.click callback

  ActNatural: (forever) ->
    console.log "hi"
