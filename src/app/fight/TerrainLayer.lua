local Box = require("app.objects.item.Box")
local Cage = require("app.objects.item.Cage")

local TerrainLayer = class("TerrainLayer", function()
    return display.newLayer()
end)

function TerrainLayer:ctor()
    self.terrainManager = require("app.manager.TerrainManager").new()
    self:setContentSize(display.size)
    self.scaleX = display.width/640

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

    local Objects = map:getObjectGroup("treeLayer")
    if not Objects then
        return
    end
    local objects = Objects:getObjects()
    for i=1,#objects do
        local treeObject = objects[i]
        local tree = display.newSprite("#tree_top.png"):scale(0.6)
        tree:setPosition(cc.p((treeObject["x"]+treeObject["width"]*0.5)*self.scaleX,treeObject["y"]+treeObject["height"]*0.5))
        map:addChild(tree,4)
    end

    local itemObjects = map:getObjectGroup("itemLayer")
    if not itemObjects then
        return
    end
    local items = itemObjects:getObjects()
    for i=1,#items do
        local itemObject = items[i]
        local item = Box.new()
        item:setPosition(cc.p((itemObject["x"]+itemObject["width"]*0.5)*self.scaleX,itemObject["y"]+itemObject["height"]*0.5))
        map:addChild(item,3)
        table.insert(m_GameLayer.itemManager.terrainItems,item)
    end

    local peopleObjects = map:getObjectGroup("peopleLayer")
    if not peopleObjects then
        return
    end
    local people = peopleObjects:getObjects()
    for i=1,#people do
        if #m_GameLayer.heros >= 5 then break end
        local peopleObject = people[i]
        local cage = Cage.new()
        cage:setPosition(cc.p((peopleObject["x"]+peopleObject["width"]*0.5)*self.scaleX,peopleObject["y"]+peopleObject["height"]*0.5))
        map:addChild(cage,3)
        table.insert(m_GameLayer.itemManager.terrainItems,cage)
    end

    local enemyObjects = map:getObjectGroup("enemyLayer")
    if not enemyObjects then
        return
    end
    local enemies = enemyObjects:getObjects()
    for i=1,#enemies do
        local enemyObject = enemies[i]
        local enemy
        local k
        if CONSTANT.ENEMY_TYPE.Obstacle == enemyObject["name"] then
            enemy = require("app.objects.enemy.Obstacle").new()
            k = 2
        elseif CONSTANT.ENEMY_TYPE.Soldier == enemyObject["name"] then
            enemy = require("app.objects.enemy.Soldier").new()
            k = 1
        end
        if enemy ~= nil then
            enemy:setPosition(cc.p((enemyObject["x"]+enemyObject["width"]*0.5)*self.scaleX,enemyObject["y"]+enemyObject["height"]*0.5))
            map:addChild(enemy,k)
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
        self.tileMap1:removeFromParent()
        local map = self.terrainManager:loadNext()
        self:addChild(map)
        self:setupMapAfterMap(self.tileMap2,map)
    end
end

return TerrainLayer











