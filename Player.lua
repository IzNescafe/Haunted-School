player = {}

function player.load()
  wf = require 'libraries/windfield'
  world = wf.newWorld(0, 0)

  camera = require 'libraries/camera'
  cam = camera()

  anim8 = require 'libraries/anim8'
  love.graphics.setDefaultFilter("nearest", "nearest") --dun do blurring when we scale the sprite

  sti = require 'libraries/sti'
  gameMap = sti('maps/ground-floor.lua')
  
  player = {}
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

  player.anim = player.animations.left --to track player animation

  walls = {}
  if gameMap.layers["walls"] then
    for i, obj in pairs(gameMap.layers["walls"].objects) do
      local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
      wall:setType('static')
      table.insert(walls, wall)
    end
  end
  
end

function player.update(dt)
  local isMoving = false

  local vx = 0
  local vy = 0
  
  if love.keyboard.isDown("right") then
    vx =  player.speed
    player.anim = player.animations.right
    isMoving = true
  end

  if love.keyboard.isDown("left") then
    vx = player.speed * -1
    player.anim = player.animations.left
    isMoving = true
  end

  if love.keyboard.isDown("down") then
    vy = player.speed
    player.anim = player.animations.down
    isMoving = true
  end

  if love.keyboard.isDown("up") then
    vy = player.speed * -1
    player.anim = player.animations.up
    isMoving = true
  end

  player.collider:setLinearVelocity(vx, vy)

  if isMoving == false then
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

  local mapW = gameMap.width * gameMap.tilewidth
  local mapH = gameMap.height * gameMap.tileheight

  if cam.x > (mapW - w/2) then
    cam.x = (mapW - w/2)
  end

  if cam.y > (mapH - h/2) then
    cam.y = (mapH - h/2)
  end
  
end

function player.draw()
  cam:attach()
    gameMap:drawLayer(gameMap.layers["main"])
    -- gameMap:drawLayer(gameMap.layers["road"])
    gameMap:drawLayer(gameMap.layers["doors"])
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 1.5, nil, 32, 32) --posx, posy, nil-> no rotation, scale x factor-> y wil also adopt that effect
    --offset of camera must take half of width and half of height of sprite (to go directly in the center)
  cam:detach()
end

return player
