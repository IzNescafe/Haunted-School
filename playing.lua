playing = {}

local player = require("Player")
local enemy = require("enemy")
local timer = require("Timer")
local gameMap = require("GameMap")
require("sword")

function playing.load()

    camera = require 'libraries/camera'
    cam = camera()

    gameMap.load()
    player.load()
    enemy.load()
    timer.load()
end

function playing.update(dt)
    player.update(dt)
    enemy.update(dt)
    sword:update(dt)
    timer.update(dt)
    gameMap.update(dt) --update physics world

    cam:lookAt(player.x, player.y)

    -- only use after resizing sprite and map
  
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
  
    if cam.x < w/2 then
      cam.x = w/2
    end
  
    if cam.y < h/2 then
      cam.y = h/2
    end
  
    local mapW = gameMap.map.width * gameMap.map.tilewidth
    local mapH = gameMap.map.height * gameMap.map.tileheight
  
    if cam.x > (mapW - w/2) then
      cam.x = (mapW - w/2)
    end
  
    if cam.y > (mapH - h/2) then
      cam.y = (mapH - h/2)
    end
end

function playing.draw()
    cam:attach()
      gameMap.draw()
      timer.draw()
      enemy.draw()
      sword:draw()
      player.draw()
    --   gameMap.world:draw() --to check the colliders/hitboxes of the world
  cam:detach()
end

return playing