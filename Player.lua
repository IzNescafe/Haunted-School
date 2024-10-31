player = {}

function player.load()
  anim8 = requrie 'libraries/anim8'
  love.graphics.setDefaultFilter("nearest", "nearest") --dun do blurring when we scale the sprite
  
  player = {}
  player.x = 400
  player.y = 200
  player.speed = 5
  player.spriteSheet = love.graphics.newImage("IMG_6463.png")
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
  
end

function player.draw()
  player.anim:draw(player.spriteSheet, player.x, player.y, nil, 1 ) --posx, posy, nil-> no rotation, scale x factor-> y wil also adopt that effect
end

return player
