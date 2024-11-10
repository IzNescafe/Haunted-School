gameMap = {}

function gameMap.load()
    
    wf = require 'libraries/windfield'
    gameMap.world = wf.newWorld(0, 0)

    sti = require 'libraries/sti'
    gameMap.map = sti('maps/ground-floor.lua')

    walls = {}
    if gameMap.map.layers["walls"] then
    for i, obj in pairs(gameMap.map.layers["walls"].objects) do
      local wall = gameMap.world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
      wall:setType('static')
      table.insert(walls, wall)
    end
  end

end

function gameMap.update(dt)
    gameMap.world:update(dt)
end

function gameMap.draw()
    gameMap.map:drawLayer(gameMap.map.layers["main"])
    -- gameMap:drawLayer(gameMap.layers["road"])
    gameMap.map:drawLayer(gameMap.map.layers["doors"])
end

return gameMap