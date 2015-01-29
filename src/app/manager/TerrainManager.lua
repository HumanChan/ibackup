
local TerrainManager = class("TerrainManager",function()
    return {}
end)


function TerrainManager:ctor()
    self.sequence = {}
    
    
end


function TerrainManager:loadNext()
    local map = cc.TMXTiledMap:create("res/terrain/terrain1.tmx")
    
    return map
end













return TerrainManager