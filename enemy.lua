enemy = {}

local animate = require("helpers.animationHelper")
local gameMap = require("GameMap")

function enemy.load()

    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest") -- dun do blurring when we scale the sprite
    enemy.x, enemy.y = 400, 200

    enemy.collider = gameMap.world:newBSGRectangleCollider(enemy.x, enemy.y, 25, 80, 5)
    enemy.collider:setCollisionClass("Enemy")
    enemy.collider:setFixedRotation(true)
    enemy.speed = 200
    enemy.spriteSheet = love.graphics.newImage("res/Scary_Teacher-Sheet.png")
    enemy.grid = anim8.newGrid(64, 64, enemy.spriteSheet:getWidth(), enemy.spriteSheet:getHeight())

    enemy.animations = {
        down = animate(enemy.grid, '1-4', 1, 0.2), -- column 1 to 4, row 1, frame rate
    }
    enemy.anim = enemy.animations.down
end

function enemy.update(dt)
    enemy.collider:setLinearVelocity(10, 10)

    enemy.x = enemy.collider:getX()
    enemy.y = enemy.collider:getY()
    enemy.anim:update(dt)
end

function enemy.draw()
    enemy.anim:draw(enemy.spriteSheet, enemy.x, enemy.y, nil, 2, nil, 32, 32)
end
return enemy