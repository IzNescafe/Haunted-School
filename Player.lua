local gameMap = require("GameMap")
local anim8 = require 'libraries/anim8'
local animate = require("helpers.animationHelper")
require("sword")

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
  player.spriteSheet = love.graphics.newImage("res/Girl_Sprite-Sheet1.png")
  player.grid = anim8.newGrid(64, 64, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

  player.animations = {
    down = animate(player.grid, '1-4', 1, 0.2), -- column 1 to 4, row 1, frame rate
    left = animate(player.grid, '1-4', 2, 0.2),
    right = animate(player.grid, '1-4', 3, 0.2),
    up = animate(player.grid, '1-4', 4, 0.2),
    downatk = animate(player.grid, '1-2', 5, {0.3, 0.2}, playerAttackComplete),
    leftatk = animate(player.grid, '1-2', 6, {0.3, 0.2}, playerAttackComplete),
    rightatk = animate(player.grid, '1-2', 7, {0.3, 0.2}, playerAttackComplete),
    upatk = animate(player.grid, '1-2', 8, {0.3, 0.2}, playerAttackComplete)
  }

  player.anim = player.animations.left -- to track player animation
  player.dir = "left"

end

function player.update(dt)
  player.isMoving = false

  local vx = 0
  local vy = 0

  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    vx = player.speed
    player.anim = player.animations.right
    player.dir = 'right'
    player.isMoving = true
  end

  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    vx = player.speed * -1
    player.anim = player.animations.left
    player.dir = 'left'
    player.isMoving = true
  end

  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    vy = player.speed
    player.anim = player.animations.down
    player.dir = 'down'
    player.isMoving = true
  end

  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    vy = player.speed * -1
    player.anim = player.animations.up
    player.dir = 'up'
    player.isMoving = true
  end

  if love.mouse.isDown(1) and not player.isAttacking then
    player.attack()
    player.anim:update(dt)
    player.isAttacking = false
  end

  -- Normalize the vector if moving diagonally
  if vx ~= 0 and vy ~= 0 then
    local magnitude = math.sqrt(vx ^ 2 + vy ^ 2)
    vx = (vx / magnitude) * player.speed
    vy = (vy / magnitude) * player.speed
  end

  if player.isMoving == false then
    player.collider:setLinearVelocity(0, 0)
    player.anim:gotoFrame(1) -- go to standing still frame -> column number
  end

  -- collisions
  player.x = player.collider:getX()
  player.y = player.collider:getY()

  if player.isMoving then
    player.collider:setLinearVelocity(vx, vy)
    player.anim:update(dt)
  end

  
  player.isMoving = false
end

function player.draw()
  player.anim:draw(player.spriteSheet, player.x, player.y, nil, 2, nil, 32, 32) -- posx, posy, nil-> no rotation, scale x factor-> y wil also adopt that effect
  -- offset of camera must take half of width and half of height of sprite (to go directly in the center)
end

function player.attack()
  player.isMoving = false
  player.isAttacking = true
  player.collider:setLinearVelocity(0, 0)
  if player.dir == "down" then
      player.anim = player.animations.downatk
  elseif player.dir == "left" then
      player.anim = player.animations.leftatk
  elseif player.dir == "right" then
      player.anim = player.animations.rightatk
  elseif player.dir == "up" then
      player.anim = player.animations.upatk
  end
  sword:attack(player.dir, player.collider:getX(), player.collider:getY())
end

function playerAttackComplete()

  if player.isAttacking then
      player.isAttacking = false
      player.anim = player.animations[player.dir]
      player.moving = true

      if player.dir == "down" then
          player.anim = player.animations.down
      elseif player.dir == "left" then
          player.anim = player.animations.left
      elseif player.dir == "right" then
          player.anim = player.animations.right
      elseif player.dir == "up" then
          player.anim = player.animations.up
      end
      player.anim:gotoFrame(1) -- go to standing frame
  end

end

return player
