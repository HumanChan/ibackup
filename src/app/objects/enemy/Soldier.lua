local scheduler         = require("framework.scheduler")

local Soldier = class("Soldier", require("app.objects.BaseObject"))

function Soldier:ctor()
    self.facade = display.newSprite("#soldierJungle.png"):addTo(self)
    self.box = self.facade:getBoundingBox()
    self.def = 1
    self.isActive = true
    self.isShoting = false
end

function Soldier:fire()
    local p = self.facade:convertToWorldSpace(cc.p(0,0))
    local smoke = cc.Sprite:createWithSpriteFrameName("soldier_fire.png")
    smoke:setPosition(cc.p(p.x+18,p.y))
    local action = cc.Sequence:create(cc.DelayTime:create(0.05),cc.CallFunc:create(function()
        smoke:removeFromParent(true)
    end))
    smoke:runAction(action)
    m_GameLayer.layer:addChild(smoke)

    local bullet = require("app.objects.item.EnemyNormalBullet").new()
    bullet:setPosition(cc.p(p.x+18,p.y))
    table.insert(m_GameLayer.enemyBullets,bullet)
    m_GameLayer.layer:addChild(bullet)
end

function Soldier:dispose()
    self.isActive = false
    if self.fireTimer then
        scheduler.unscheduleGlobal(self.fireTimer)
    end
    self:removeFromParent(true)
end

function Soldier:stopAction()
    self.facade:stopAllActions()
    if self.fireTimer then
        scheduler.unscheduleGlobal(self.fireTimer)
    end
end

function Soldier:resumeAction()
    self.isShoting = false
end

function Soldier:enterFrame(delta)
    if self.isShoting == false then
        local p = self.facade:convertToWorldSpace(cc.p(0,0))
        local posY = p.y
        if posY < display.height then
            self.isShoting = true
            self.fireTimer = scheduler.scheduleGlobal(handler(self,self.fire),1.5)
        end
    end
end

return Soldier