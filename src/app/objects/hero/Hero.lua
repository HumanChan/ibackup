local scheduler         = require("framework.scheduler")

local Hero = class("Hero", require("app.objects.BaseObject"))

function Hero:ctor(config)
    self.config = config or nil
    self.id = 0
    self.facade = cc.Sprite:createWithSpriteFrameName("hero_runA01.png")
    self.facade:setScale(GC.scale)
    self:addChild(self.facade)

    self.def = 1
    self.isActive = true

    self:setAnimation()
end

function Hero:shot()
    --烟雾效果
    local p = self.facade:convertToWorldSpace(cc.p(0,0))
    local smoke = cc.Sprite:createWithSpriteFrameName("fire_efx.png")
    smoke:setScale(GC.scale)
    smoke:setPosition(cc.p(p.x+22,p.y+50))
    local action = cc.Sequence:create(cc.DelayTime:create(0.05),cc.CallFunc:create(function()
        smoke:removeFromParent(true)
    end))
    smoke:runAction(action)
    m_GameLayer:addChild(smoke,20)

    local bullet = require("app.objects.item.HeroNormalBullet").new()
    bullet:setPosition(cc.p(p.x+22,p.y+53))
    table.insert(m_GameLayer.heroBullets,bullet)
    m_GameLayer:addChild(bullet)

end

function Hero:changeWeapon(weaponID)
    if self.shotTimer then
        scheduler.unscheduleGlobal(self.shotTimer)
    else
        self.shotTimer = scheduler.scheduleGlobal(handler(self,self.shot),1.0)
    end

end

function Hero:follow(delta)
    if self.id ~= 0 then


    else
        if m_GameLayer.pHeroCurX then
            local mainHero = m_GameLayer.heros[1]
            local disX = m_GameLayer.pHeroCurX - mainHero:getPositionX()
            if disX > 1 then
                mainHero:setPositionX(mainHero:getPositionX() + 15*delta*disX)
            elseif disX < -1 then
                mainHero:setPositionX(mainHero:getPositionX() - 15*delta*(-disX))
            end
        end
    end
end

function Hero:dispose()
    self.isActive = false
    if self.shotTimer then
        scheduler.unscheduleGlobal(self.shotTimer)
    end
    self:removeFromParent(true)
end

function Hero:enterFrame(delta)
    self:follow(delta)
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















