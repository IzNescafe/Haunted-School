player = {}
local gameMap = require("GameMap")

player.isAttacking = false
player.isMoving = false

function player.load()
  gameMap.load()
  wf = require 'libraries/windfield'
  world = wf.newWorld(0, 0)

  camera = require 'libraries/camera'
  cam = camera()

  anim8 = require 'libraries/anim8'
  love.graphics.setDefaultFilter("nearest", "nearest") --dun do blurring when we scale the sprite
  
  player.collider = world:newBSGRectangleCollider(1000, 1000, 25, 50, 5)
  player.collider:setFixedRotation(true)
  player.x = 400
  player.y = 200
  player.speed = 300
  player.spriteSheet = love.graphics.newImage("res/Girl_Sprite-Sheet.png")
  player.grid = anim8.newGrid(64, 64, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

  player.animations = {}
  player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2) --column 1 to 4, row 1, frame rate
  player.animations.left = anim8.newAnimation( player.grid('1-4', 2), 0.2)
  player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
  player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)
  player.animations.downatk = anim8.newAnimation(player.grid('1-4', 5), 0.1)
  player.animations.leftatk = anim8.newAnimation(player.grid('1-4', 6), 0.1)
  player.animations.rightatk = anim8.newAnimation(player.grid('1-4', 7), 0.1)
  player.animations.upatk = anim8.newAnimation(player.grid('1-4', 8), 0.1)

  player.anim = player.animations.left --to track player animation
  player.attack = "left"

  walls = {}
    if gameMap.map.layers["walls"] then
    for i, obj in pairs(gameMap.map.layers["walls"].objects) do
      local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
      wall:setType('static')
      table.insert(walls, wall)
    end
  end
  
end

function player.update(dt)
  player.isMoving = false

  local vx = 0
  local vy = 0
  
  if love.keyboard.isDown("right") then
    vx =  player.speed
    player.anim = player.animations.right
    player.attack = 'right'
    player.isMoving = true
  end

  if love.keyboard.isDown("left") then
    vx = player.speed * -1
    player.anim = player.animations.left
    player.attack = 'left'
    player.isMoving = true
  end

  if love.keyboard.isDown("down") then
    vy = player.speed
    player.anim = player.animations.down
    player.attack = 'down'
    player.isMoving = true
  end

  if love.keyboard.isDown("up") then
    vy = player.speed * -1
    player.anim = player.animations.up
    player.attack = 'up'
    player.isMoving = true
  end

    if love.keyboard.isDown("a") then
    player.isMoving = true
    if player.attack == 'down' then
      player.anim = player.animations.downatk
      player.isAttacking = true
    
    elseif player.attack == 'left' then
      player.anim = player.animations.leftatk
      player.isAttacking = true

    elseif player.attack == 'right' then
      player.anim = player.animations.rightatk
      player.isAttacking = true

    elseif player.attack == 'up' then
      player.anim = player.animations.upatk
      player.isAttacking = true
    end
  end

  player.collider:setLinearVelocity(vx, vy)

  if player.isMoving == false then
    player.anim:gotoFrame(1) --go to standing still frame -> column number
  end

  --collisions
  world:update(dt)
  player.x = player.collider:getX()
  player.y = player.collider:getY()

  player.anim:update(dt)

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

function player.draw()
  cam:attach()
    gameMap.draw()
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 1.5, nil, 32, 32) --posx, posy, nil-> no rotation, scale x factor-> y wil also adopt that effect
    --offset of camera must take half of width and half of height of sprite (to go directly in the center)
  cam:detach()
end

return player
