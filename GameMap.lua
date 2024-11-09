gameMap = {}

function gameMap.load()
    
    wf = require 'libraries/windfield'
    world = wf.newWorld(0, 0)

    sti = require 'libraries/sti'
    gameMap.map = sti('maps/ground-floor.lua')

end

-- function gameMap.update(dt)
-- end

function gameMap.draw()
    gameMap.map:drawLayer(gameMap.map.layers["main"])
    -- gameMap:drawLayer(gameMap.layers["road"])
    gameMap.map:drawLayer(gameMap.map.layers["doors"])
end

return gameMap