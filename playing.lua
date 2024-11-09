playing = {}

local player = require("Player")
-- local enemy = require("enemy")
local timer = require("Timer")

function playing.load()
    player.load()
    -- enemy.load()
    timer.load()
end

function playing.update(dt)
    timer.update(dt)
    player.update(dt)
end

function playing.draw()
    player.draw()
    timer.draw()
    -- enemy.draw()
end

return playing