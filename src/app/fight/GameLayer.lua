m_GameLayer = nil

local scheduler = require("framework.scheduler")
local GameCache = require("app.cache.GameCache")

local GameLayer = class("GameLayer", function()
    return display.newLayer()
end)

function GameLayer:ctor(config)
    m_GameLayer = self
    self.config = config
    self.pHeroCurX = display.cx

    --背景
    self.background = require("app.fight.BackgroundLayer").new():addTo(self):align(display.LEFT_BOTTOM)
    self.layer = display.newLayer():addTo(self)
    self.layer:setLocalZOrder(2)

    --英雄
    self.heros = {}
    self.mode = self.config.walkMode
    for i=1,#self.config.heros do
        local heroConfig = self.config.heros[i]
        local hero = require("app.objects.Hero").new(heroConfig):addTo(self)
        hero:setLocalZOrder(4)
        hero:changeWeapon(1)
        table.insert(self.heros,hero)
        --队形
        if self.mode == GC.WALK_MODE.horizontal then
            --水平队形
            local d = -GC.basehorizontalDis
            local k = 0
            if (i-1)%2 == 0 then
                d = -d
                k = (i-1)/2
            else
                k = i/2
            end
            hero:setPosition(display.cx+k*d,display.height*GC.baseHeroY+(3-i/2)*10)
        elseif self.mode == GC.WALK_MODE.vertical then
            --垂直队形
            hero:setPosition(display.cx,display.height*GC.baseHeroY+(#self.config.heros - i)*GC.baseVerticalDis)
        end
    end

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
    self.terrain = require("app.fight.TerrainLayer").new():addTo(self):align(display.LEFT_BOTTOM)
    self.terrain:setLocalZOrder(1)

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
    if GameCache.pause ~= true and GameCache.over ~= true then
        self.pTouchBegan = touch:getLocation()
        self.pHeroBeganX = self.heros[1]:getPositionX()
        self.curTouchPoint = self.pTouchBegan
        return true
    else
        return false
    end
end

function GameLayer:onTouchMove(touch, event)
    local touchPoint = touch:getLocation()
    self.curTouchPoint = touchPoint
    if self.pTouchLast == nil then
        self.pTouchLast = self.pTouchBegan
    end
    local dx = touchPoint.x - self.pTouchLast.x
    local dy = touchPoint.y - self.pTouchLast.y

    if math.abs(dx) <= 1 and math.abs(dy) <= 1 then  --手指基本不动
        self.pTouchBegan = touchPoint
        self.pHeroBeganX = self.heros[1]:getPositionX()
    end
    local disX = touchPoint.x - self.pTouchBegan.x
    local disY = touchPoint.y - self.pTouchBegan.y
    self.pHeroCurX = disX + self.pHeroBeganX
    if #self.heros <= 1 then
        return
    end
    if math.abs(disX) < 15 and disY > 40 then
        if self.mode ~= GC.WALK_MODE.vertical then
            self:changeMode(GC.WALK_MODE.vertical)
        end
    elseif math.abs(disX) < 15 and disY < -40 then
        if self.mode ~= GC.WALK_MODE.horizontal then
            self:changeMode(GC.WALK_MODE.horizontal)
        end
    end
    self.pTouchLast = touchPoint
end

function GameLayer:onTouchEnded(touch, event)
    self.curTouchPoint = nil
end

function GameLayer:changeMode(mode,callback,check)
    local curMode = self.mode
    if curMode == mode and check ~= false then
        return
    end
    self.isChanging = true
    curMainX = self.heros[1]:getPositionX()
    if curMode == GC.WALK_MODE.vertical and check ~= false or curMode == GC.WALK_MODE.horizontal and check == false then  --竖转横
        for i=1,#self.heros do
            local px = self.heros[i]:getPositionX()
            local py = self.heros[i]:getPositionY()
            local d = -GC.basehorizontalDis
            local k = 0
            if (i-1)%2 == 0 then
                d = -d
                k = (i-1)/2
            else
                k = i/2
            end
            local aimPointX = curMainX + k*d
            local aimPointY = display.height*GC.baseHeroY+(3-i/2)*10
            local distance = cc.pGetDistance(cc.p(px,py),cc.p(aimPointX,aimPointY))
            local t = distance / 500
            if t > 0.5 then t = 0.5
            elseif t < 0.3 then t = 0.3 end
            local moveTo = cc.MoveTo:create(t,cc.p(aimPointX,aimPointY))

            if i == #self.heros then
                self.heros[i]:runAction(cc.Sequence:create(moveTo,cc.CallFunc:create(function()
                    self.isChanging = false
                    if callback then
                        callback()
                    end
                end)))
            else
                self.heros[i]:runAction(moveTo)
            end
    end
    self.mode = GC.WALK_MODE.horizontal
    elseif curMode == GC.WALK_MODE.horizontal and check ~= false or curMode == GC.WALK_MODE.vertical and check == false then --横转竖
        local aimPointX = curMainX
        for i=1,#self.heros do
            local px = self.heros[i]:getPositionX()
            local py = self.heros[i]:getPositionY()
            local aimPointY = display.height*GC.baseHeroY+(#self.heros - i)*GC.baseVerticalDis
            local distance = cc.pGetDistance(cc.p(px,py),cc.p(aimPointX,aimPointY))
            local t = distance / 500
            if t > 0.5 then t = 0.5
            elseif t < 0.3 then t = 0.3 end
            local moveTo = cc.MoveTo:create(t,cc.p(aimPointX,aimPointY))
            if i == #self.heros then
                self.heros[i]:runAction(cc.Sequence:create(moveTo,cc.CallFunc:create(function()
                    self.isChanging = false
                    if callback then
                        callback()
                    end
                end)))
            else
                self.heros[i]:runAction(moveTo)
            end
        end
        self.mode = GC.WALK_MODE.vertical
    end
end

function GameLayer:addHero(px,py)
    local heroConfig = {}
    heroConfig.id = #self.heros + 1
    heroConfig.weaponID = CONSTANT.WEAPON_ID.HAND_GUN
    local hero = require("app.objects.Hero").new(heroConfig):addTo(self)
    hero:setLocalZOrder(4)
    hero:changeWeapon(1)
    table.insert(self.heros,hero)
    hero:setPosition(px,py)
    self:changeMode(self.mode,nil,false)
end

function GameLayer:updateHeros(delta)
    for i=1,#self.heros do
        self.heros[i].id = i
    end
    if self.shouldChange == true then
        scheduler.performWithDelayGlobal(function()
            self:changeMode(self.mode,function()
                self.shouldChange = nil
            end)
        end,0.6) --0.6秒后整理队形
    end
    for i=1,#self.heros do
        if self.heros[i].isActive then
            self.heros[i]:enterFrame(delta)
        end
    end
end

function GameLayer:pause()
    GameCache.pause = true
    for i=1,#self.heros do
        if self.heros[i].isActive then
            self.heros[i]:stopAction()
        end
    end
    local terrainEnemies = self.enemyManager.terrainEnemys
    for j=1,#terrainEnemies do
        if terrainEnemies[j].isActive then
            terrainEnemies[j]:stopAction()
        end
    end
end

function GameLayer:resume()
    GameCache.pause = false
    for i=1,#self.heros do
        if self.heros[i].isActive then
            self.heros[i]:resumeAction()
        end
    end
    local terrainEnemies = self.enemyManager.terrainEnemys
    for j=1,#terrainEnemies do
        if terrainEnemies[j].isActive then
            terrainEnemies[j]:resumeAction()
        end
    end
end

function GameLayer:enterFrame(delta)
    if #self.heros < 1 and GameCache.pause ~= true then
        self:pause()
    end
    if GameCache.pause ~= true then

        --hero update
        for i=1,#self.heros do
            if self.heros[i] then
                if self.heros[i].isActive then
                else
                    self.shouldChange = true
                    table.remove(self.heros,i)
                    i = i - 1
                    if i == 0 then
                        break
                    end
                end
            end
        end
        self:updateHeros(delta)

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
        self.background:enterFrame(delta)

        self.collisionManager:enterFrame(delta)

    end
end

return GameLayer