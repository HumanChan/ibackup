local scheduler         = require("framework.scheduler")

local Hero = class("Hero", require("app.objects.BaseObject"))
local GameCache = require("app.cache.GameCache")

function Hero:ctor(config)
    self.config = config or nil
    self.id = self.config.id or 1
    self.weaponID = self.config.weaponID or CONSTANT.WEAPON_ID.HAND_GUN
    self.def = 1
    self.isActive = true
    self.facade = display.newSprite("#hero_runA01.png")
    self.box = self.facade:getBoundingBox()
    self:addChild(self.facade)
    self:setAnimation()
end

function Hero:shot()
    --烟雾效果
    local p = self.facade:convertToWorldSpace(cc.p(0,0))
    local smoke = cc.Sprite:createWithSpriteFrameName("fire_efx.png")
    smoke:setPosition(cc.p(p.x+50,p.y+110))
    local action = cc.Sequence:create(cc.DelayTime:create(0.05),cc.CallFunc:create(function()
        smoke:removeFromParent(true)
    end))
    smoke:runAction(action)
    m_GameLayer.layer:addChild(smoke,20)

    local bullet = require("app.objects.item.HeroNormalBullet").new()
    bullet:setPosition(cc.p(p.x+50,p.y+110))
    table.insert(m_GameLayer.heroBullets,bullet)
    m_GameLayer.layer:addChild(bullet)
end

function Hero:changeWeapon(weaponID)
--    print(weaponID)
    self.weaponID = weaponID
    if self.shotTimer then
        scheduler.unscheduleGlobal(self.shotTimer)
    end
    self.shotTimer = scheduler.scheduleGlobal(handler(self,self.shot),1.0)
end

function Hero:follow(delta)
    if self.id ~= 1 then
        local mode = m_GameLayer.mode
        if mode == GC.WALK_MODE.horizontal then
            local followID = self.id - 2
            if followID <= 0 then followID = 1 end
            local followHero = m_GameLayer.heros[followID]
            if followHero and followHero.isActive then
                local mainHero = m_GameLayer.heros[1]
                local followX = followHero:getPositionX()
                local disX = followHero:getPositionX() - self:getPositionX()
                local MainMoveX = m_GameLayer.pHeroCurX - mainHero:getPositionX()
                local aimX
                local isMoving = true
                if m_GameLayer.kao == nil then  --不靠墙
                    if MainMoveX < 3 and MainMoveX > -3 then
                        isMoving = false
                        if disX < GC.basehorizontalDis and disX > 0 then
                            local xx = delta*disX*disX/10
                            aimX = self:getPositionX() - xx
                            if aimX < followX-GC.basehorizontalDis then
                                aimX = followX-GC.basehorizontalDis
                            end
                        end
                        if disX > -GC.basehorizontalDis and disX < 0 then
                            local xx = delta*disX*disX/10
                            aimX = self:getPositionX() + xx
                            if aimX > followX+GC.basehorizontalDis then
                                aimX = followX+GC.basehorizontalDis
                            end
                        end
                end
                if isMoving then
                    if self.id%2  == 0 and disX < 0 then  --左边穿透
                        aimX = followX - GC.smallHorizontalDis
                    elseif self.id%2 == 1 and disX > 0 then  --右边穿透
                        aimX = followX + GC.smallHorizontalDis
                    else
                        if disX > GC.basehorizontalDis or  disX < -GC.basehorizontalDis then
                            local k = disX
                            if k < 0 then
                                k = -disX
                            end
                            local xx = delta*disX*k/10
                            if xx > GC.basehorizontalDis then xx = GC.basehorizontalDis end
                            if xx < -GC.basehorizontalDis then xx = -GC.basehorizontalDis end
                            aimX = self:getPositionX() + xx
                        end
                        if disX < GC.smallHorizontalDis and disX > 0 then
                            aimX = followX - GC.smallHorizontalDis
                        end
                        if disX > -GC.smallHorizontalDis and disX < 0 then
                            aimX = followX + GC.smallHorizontalDis
                        end
                    end
                end
                else
                    if m_GameLayer.kao == 0 then
                        aimX = GC.heroCX
                    elseif m_GameLayer.kao == 1 then
                        aimX = display.width - GC.heroCX
                    end
                end

                if aimX ~= nil then
                    if aimX - GC.heroCX < 0 then aimX = GC.heroCX end
                    if aimX > display.width - GC.heroCX then aimX = display.width - GC.heroCX end
                    self:setPositionX(aimX)
                end
            end
        elseif mode == GC.WALK_MODE.vertical then
            local followID = self.id - 1
            local followHero = m_GameLayer.heros[followID]
            if followHero and followHero.isActive then
                local disX = followHero:getPositionX() - self:getPositionX()
                local aimX = self:getPositionX()+12*delta*disX
                if aimX - GC.heroCX < 0 then aimX = GC.heroCX end
                if aimX > display.width - GC.heroCX then aimX = display.width - GC.heroCX end
                self:setPositionX(aimX)
            end
        end
    else  --第一个英雄跟随手指移动
        if m_GameLayer.pHeroCurX then
            local mainHero = m_GameLayer.heros[1]
            local disX = m_GameLayer.pHeroCurX - mainHero:getPositionX()
            local aimX = mainHero:getPositionX() + 20*delta*disX
            m_GameLayer.kao = nil
            if aimX - GC.heroCX < 0 then
                aimX = GC.heroCX
                --设置所有英雄向左靠墙
                m_GameLayer.kao = 0
            end
            if aimX > display.width - GC.heroCX then
                aimX = display.width - GC.heroCX
                --设置所有英雄向右靠墙
                m_GameLayer.kao = 1
            end
            mainHero:setPositionX(aimX)
    end
    end
end

function Hero:dispose()
    self.isActive = false
    if self.shotTimer then
        scheduler.unscheduleGlobal(self.shotTimer)
    end
    self:removeFromParent()
end

function Hero:enterFrame(delta)
    if m_GameLayer.isChanging ~= true then
        self:follow(delta)
    end
end

function Hero:stopAction()
    self.facade:stopAllActions()
    if self.shotTimer then
        scheduler.unscheduleGlobal(self.shotTimer)
    end
end

function Hero:resumeAction()
    self:setAnimation()
    self:changeWeapon(self.weaponID)
end

function Hero:setAnimation()
    local animFrames = {}
    for i=1,5 do
        local str = "hero_runA0"..i..".png"
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
        table.insert(animFrames,i,frame)
    end
    local animation = cc.Animation:createWithSpriteFrames(animFrames,0.1)
    local action = cc.RepeatForever:create(cc.Animate:create(animation))
    self.facade:runAction(action)
end


return Hero















