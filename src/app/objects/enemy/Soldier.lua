local scheduler         = require("framework.scheduler")

local Soldier = class("Soldier", require("app.objects.BaseObject"))

function Soldier:ctor()
    self.facade = cc.Sprite:createWithSpriteFrameName("soldierJungle.png")
    self.facade:setScale(GC.scale)
    self:addChild(self.facade)
    self.def = 1
    self.isActive = true
    self.isShoting = false

end

function Soldier:fire()
    local p = self.facade:convertToWorldSpace(cc.p(0,0))
    local smoke = cc.Sprite:createWithSpriteFrameName("soldier_fire.png")
    smoke:setScale(GC.scale)
    smoke:setPosition(cc.p(p.x+10,p.y))
    local action = cc.Sequence:create(cc.DelayTime:create(0.05),cc.CallFunc:create(function()
        smoke:removeFromParent(true)
    end))
    smoke:runAction(action)
    m_GameLayer:addChild(smoke)

    local bullet = require("app.objects.item.EnemyNormalBullet").new()
    bullet:setPosition(cc.p(p.x+10,p.y))
    table.insert(m_GameLayer.enemyBullets,bullet)
    m_GameLayer:addChild(bullet)
end

function Soldier:dispose()
    self.isActive = false
    if self.fireTimer then
        scheduler.unscheduleGlobal(self.fireTimer)
    end
    self:removeFromParent(true)
end

function Soldier:enterFrame(delta)
    if not self.isShoting then
        local p = self.facade:convertToWorldSpace(cc.p(0,0))
        local posY = p.y
        if posY < display.height then
            self.isShoting = true
            self.fireTimer = scheduler.scheduleGlobal(handler(self,self.fire),1.0)
        end
    end
end

return Soldier