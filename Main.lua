local menu = require("Menu")

local player = {}
player.x = 100
player.y = 100

function love.load()
  menu.load()
end

function love.update(dt)

end

function love.draw()
  menu.draw()
end
