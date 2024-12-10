-- local menu = require("Menu")
-- local player = require("Player")
local playing = require("playing")

function love.load()
  --menu.load()
  playing.load()
end

function love.update(dt)
  playing.update(dt)
end

function love.draw()
  --menu.draw()
    playing.draw()
end
