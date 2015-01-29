local Box = require("app.objects.item.Box")

local TerrainLayer = class("TerrainLayer", function()
    return display.newLayer()
end)

function TerrainLayer:ctor()
    self.terrainManager = require("app.manager.TerrainManager").new()

    local map1 = self.terrainManager:loadNext()
    self:addChild(map1)
    self:setupMapAfterMap(nil,map1)

    local map2 = self.terrainManager:loadNext()
    self:addChild(map2)
    self:setupMapAfterMap(map1,map2)

end

function TerrainLayer:setupMapAfterMap(preMap, nextMap)
    local mapHeight = 0
    if preMap then
        mapHeight = preMap:getMapSize().height * preMap:getTileSize().height - 2
        self.tileMap1 = preMap
        self.tile1Height = mapHeight
    end

    nextMap:setAnchorPoint(cc.p(0,0))
    nextMap:setPosition(cc.p(0,mapHeight))
    self.tileMap2 = nextMap
    self.tile2Height = nextMap:getMapSize().height * nextMap:getTileSize().height - 2

    self:initTileMap(nextMap)
end

function TerrainLayer:initTileMap(map)
    local itemObjects = map:getObjectGroup("itemLayer")
    if not itemObjects then
        return
    end

    local items = itemObjects:getObjects()
    for i=1,#items do
        local itemObject = items[i]
        --for key in pairs(itemObject) do
        --  print("key = "..key.."   ->  "..itemObject[key].."\n")
        --end
        local item = Box.new()
        item:setPosition(cc.p(itemObject["x"],itemObject["y"]))
        map:addChild(item)
        table.insert(m_GameLayer.itemManager.terrainItems,item)
    end

    local enemyObjects = map:getObjectGroup("enemyLayer")
    if not enemyObjects then
        return
    end
    local enemies = enemyObjects:getObjects()
    for i=1,#enemies do
        local enemyObject = enemies[i]
        local enemy = nil
        if CONSTANT.ENEMY_TYPE.Obstacle == enemyObject["name"] then
            enemy = require("app.objects.enemy.Obstacle").new()
        elseif CONSTANT.ENEMY_TYPE.Soldier == enemyObject["name"] then
            enemy = require("app.objects.enemy.Soldier").new()
        end
        if enemy ~= nil then
            enemy:setPosition(cc.p(enemyObject["x"],enemyObject["y"]))
            map:addChild(enemy)
            m_GameLayer.enemyManager:addEnemy(enemy)
        end
    end

end


function TerrainLayer:enterFrame(delta)
    local posY = self.tileMap1:getPositionY()
    posY = posY - delta * GC.background_speed
    if posY > -self.tile1Height then
        self.tileMap1:setPositionY(posY)
        self.tileMap2:setPositionY(posY+self.tile1Height)
    else
        self.tileMap1:removeFromParent(true)
        local map = self.terrainManager:loadNext()
        self:addChild(map)
        self:setupMapAfterMap(self.tileMap2,map)
    end
end

return TerrainLayer











