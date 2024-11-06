player = {}

function player.load()
  camera = require 'libraries/camera'
  cam = camera()

  anim8 = require 'libraries/anim8'
  love.graphics.setDefaultFilter("nearest", "nearest") --dun do blurring when we scale the sprite

  sti = require 'libraries/sti'
  gameMap = sti('maps/testMap.lua')
  
  player = {}
  player.x = 400
  player.y = 200
  player.speed = 5
  player.spriteSheet = love.graphics.newImage("res/Player_Sprite.png")
  player.grid = anim8.newGrid(64, 64, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

  player.animations = {}
  player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2) --column 1 to 4, row 1, frame rate
  player.animations.left = anim8.newAnimation( player.grid('1-4', 2), 0.2)
  player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
  player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

  player.anim = player.animations.left --to track player animation
  
end

function player.update(dt)
  local isMoving = false
  
  if love.keyboard.isDown("right") then
    player.x = player.x + player.speed
    player.anim = player.animations.right
    isMoving = true
  end

  if love.keyboard.isDown("left") then
    player.x = player.x - player.speed
    player.anim = player.animations.left
    isMoving = true
  end

  if love.keyboard.isDown("down") then
    player.y = player.y + player.speed
    player.anim = player.animations.down
    isMoving = true
  end

  if love.keyboard.isDown("up") then
    player.y = player.y - player.speed
    player.anim = player.animations.up
    isMoving = true
  end

  if isMoving == false then
    player.anim:gotoFrame(2) --go to standing still frame -> column number
  end

  player.anim:update(dt)

  cam:lookAt(player.x, player.y)

  -- only use after resizing sprite and map

  -- local w = love.graphics.getWidth()
  -- local h = love.graphics.getHeight()

  -- if cam.x < w/2 then
  --   cam.x = w/2
  -- end

  -- if cam.y < h/2 then
  --   cam.y = h/2
  -- end

  -- local mapW = gameMap.width * gameMap.tilewidth
  -- local mapH = gameMap.height * gameMap.tileheight

  -- if cam.x > (mapW - w/2) then
  --   cam.x = (mapW - w/2)
  -- end

  -- if cam.y > (mapH - h/2) then
  --   cam.y = (mapH - h/2)
  -- end
  
end

function player.draw()
  cam:attach()
    gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
    gameMap:drawLayer(gameMap.layers["road"])
    gameMap:drawLayer(gameMap.layers["door"])
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 0.5, nil, 0.25, 0.3 ) --posx, posy, nil-> no rotation, scale x factor-> y wil also adopt that effect
    --offset of camera must take half of width and half of height of sprite (to go directly in the center)
  cam:detach()
end

return player
