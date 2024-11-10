local anim8 = require 'libraries/anim8'

local function animate(grid, col, row, framerate)
  return anim8.newAnimation(grid(col, row), framerate)
end

return animate
