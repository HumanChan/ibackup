
local TerrainManager = class("TerrainManager",function()
    return {}
end)


function TerrainManager:ctor()
    self.sequence = {}
    table.insert(self.sequence,1,0)
    for i=2,30 do
        local randNum = math.random(1,10)
        table.insert(self.sequence,i,randNum)
    end
    self.curTmx = 1
    --    print("----------------")
    --    for j=1,#self.sequence do
    --        print("-> "..self.sequence[j])
    --    end
    --    print("----------------")
end

function TerrainManager:createSequence()
    self.sequence = nil
    self.sequence = {}
    for i=1,30 do
        local randNum = math.random(1,10)
        table.insert(self.sequence,i,randNum)
    end
    self.curTmx = 1
end

function TerrainManager:localEmptyMap()
    return cc.TMXTiledMap:create("res/terrain/terrain0.tmx")
end

function TerrainManager:loadNext()
    if self.curTmx > 30 then
        self:createSequence()
    end
    local map = cc.TMXTiledMap:create("res/terrain/terrain"..self.sequence[self.curTmx]..".tmx")
    self.curTmx = self.curTmx + 1

--    map:setScale(display.width/640,display.height/960)

    return map
end



return TerrainManager