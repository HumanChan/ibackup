m_GameLayer = nil

local GameLayer = class("GameLayer", function()
    return display.newLayer()
end)

function GameLayer:ctor(cache)
    m_GameLayer = self
    --关卡配置
    self.cache = cache

    --英雄子弹
    self.heroBullets = {}
    --敌人子弹
    self.enemyBullets = {}

    --敌人管理
    self.enemyManager = require("app.manager.EnemyManager").new()

    --物品管理
    self.itemManager = require("app.manager.ItemManager").new()

    --碰撞检测管理
    self.collisionManager = require("app.manager.CollisionManager").new()

    --背景
    self.terrain = require("app.terrain.TerrainLayer").new()
    self:addChild(self.terrain)

    --英雄
    self.heros = {}
    local hero = require("app.objects.hero.Hero").new()
    hero:changeWeapon(1)
    hero:setPosition(cc.p(display.cx,GC.baseHeroY))
    table.insert(self.heros,hero)
    self:addChild(hero)


    --Node Event
    local function onNodeEvent(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

function GameLayer:onEnter()
    self:initEvents()
end

function GameLayer:onExit()
    if #self.heros ~= 0 then
        for i=1,#self.heros do
            self.heros[i]:dispose()
        end
    end
    self.enemyManager:clearAll()
    self:removeEvents()
end

--初始化触摸事件
function GameLayer:initEvents()
    self.touchListener = cc.EventListenerTouchOneByOne:create()
    self.touchListener:registerScriptHandler(handler(self,self.onTouchBegan),cc.Handler.EVENT_TOUCH_BEGAN )
    self.touchListener:registerScriptHandler(handler(self,self.onTouchMove),cc.Handler.EVENT_TOUCH_MOVED )
    self.touchListener:registerScriptHandler(handler(self,self.onTouchEnded),cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.touchListener, self)
end

function GameLayer:removeEvents()
    self:getEventDispatcher():removeEventListener(self.touchListener)
end

function GameLayer:onTouchBegan(touch, event)
    if self.cache.over then
        return false
    else
        self.pTouchBegan = touch:getLocation()
        self.pHeroBeganX = self.heros[1]:getPositionX()
        return true
    end
    
end

function GameLayer:onTouchMove(touch, event)
    local touchPoint = touch:getLocation()
    local disX = touchPoint.x - self.pTouchBegan.x
    local disY = touchPoint.y - self.pTouchBegan.x
    self.pHeroCurX = disX + self.pHeroBeganX
end

function GameLayer:onTouchEnded(touch, event)
end

function GameLayer:enterFrame(delta)

    if #self.heros == 0 then
        self.cache.over = true
        return
    end

    --hero update
    for i=1,#self.heros do
        if self.heros[i].isActive then
            self.heros[i]:enterFrame(delta)
        else
            table.remove(self.heros,i)
            i = i - 1
            if i == 0 then
                break
            end
        end
    end

    --英雄子弹更新
    for i=1,#self.heroBullets do
        local bullet = self.heroBullets[i]
        if bullet and bullet.isActive then
            bullet:enterFrame(delta)
        else
            table.remove(self.heroBullets,i)
            i = i - 1
        end
    end

    --敌人子弹更新
    for i=1,#self.enemyBullets do
        local bullet = self.enemyBullets[i]
        if bullet and bullet.isActive then
            bullet:enterFrame(delta)
        else
            table.remove(self.enemyBullets,i)
            i = i - 1
        end
    end

    self.itemManager:enterFrame(delta)
    self.enemyManager:enterFrame(delta)
    self.terrain:enterFrame(delta)
    self.collisionManager:enterFrame(delta)

end


return GameLayer