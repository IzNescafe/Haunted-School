local gameMap = require("GameMap")
local anim8 = require 'libraries/anim8'
local animate = require("helpers.animationHelper")

player = {}
player.isAttacking = false
player.isMoving = false

function player.load()

  anim8 = require 'libraries/anim8'
  love.graphics.setDefaultFilter("nearest", "nearest") -- dun do blurring when we scale the sprite

  player.x, player.y = 400, 200
  player.collider = gameMap.world:newBSGRectangleCollider(player.x, player.y, 25, 50, 5)
  player.collider:setCollisionClass("Player")
  player.collider:setFixedRotation(true)
  player.speed = 300
  player.spriteSheet = love.graphics.newImage("res/Girl_Sprite-Sheet.png")
  player.grid = anim8.newGrid(64, 64, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

  player.animations = {
    down = animate(player.grid, '1-4', 1, 0.2), -- column 1 to 4, row 1, frame rate
    left = animate(player.grid, '1-4', 2, 0.2),
    right = animate(player.grid, '1-4', 3, 0.2),
    up = animate(player.grid, '1-4', 4, 0.2),
    downatk = animate(player.grid, '1-4', 5, 0.1),
    leftatk = animate(player.grid, '1-4', 6, 0.1),
    rightatk = animate(player.grid, '1-4', 7, 0.1),
    upatk = animate(player.grid, '1-4', 8, 0.1)
  }

  player.anim = player.animations.left -- to track player animation
  player.attack = "left"

end

function player.update(dt)
  player.isMoving = false

  local vx = 0
  local vy = 0

  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    vx = player.speed
    player.anim = player.animations.right
    player.attack = 'right'
    player.isMoving = true
  end

  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    vx = player.speed * -1
    player.anim = player.animations.left
    player.attack = 'left'
    player.isMoving = true
  end

  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    vy = player.speed
    player.anim = player.animations.down
    player.attack = 'down'
    player.isMoving = true
  end

  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    vy = player.speed * -1
    player.anim = player.animations.up
    player.attack = 'up'
    player.isMoving = true
  end

  if love.mouse.isDown(1) then
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

  -- Normalize the vector if moving diagonally
  if vx ~= 0 and vy ~= 0 then
    local magnitude = math.sqrt(vx ^ 2 + vy ^ 2)
    vx = (vx / magnitude) * player.speed
    vy = (vy / magnitude) * player.speed
  end

  player.collider:setLinearVelocity(vx, vy)

  if player.isMoving == false then
    player.anim:gotoFrame(1) -- go to standing still frame -> column number
  end

  -- collisions
  player.x = player.collider:getX()
  player.y = player.collider:getY()

  player.anim:update(dt)

end

function player.draw()
  gameMap.world:draw()
  player.anim:draw(player.spriteSheet, player.x, player.y, nil, 2, nil, 32, 32) -- posx, posy, nil-> no rotation, scale x factor-> y wil also adopt that effect
  -- offset of camera must take half of width and half of height of sprite (to go directly in the center)
end

return player
