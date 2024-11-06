local menu = require("Menu")
local player = require("Player")

function love.load()
  --menu.load()
  player.load()
end

function love.update(dt)
  player.update(dt)
end

function love.draw()
  --menu.draw()
  player.draw()
end
