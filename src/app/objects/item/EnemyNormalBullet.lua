
local EnemyNormalBullet = class("EnemyNormalBullet", require("app.objects.BaseObject"))

function EnemyNormalBullet:ctor()
    self.facade = display.newSprite("#bullet1.png"):addTo(self)
    self.facade:setRotation(90)
    self.box = self.facade:getBoundingBox()
    self.power = 1
    self.isActive = true
end

function EnemyNormalBullet:dispose()
    self.isActive = false
    self:removeFromParent(true)
end

function EnemyNormalBullet:enterFrame(delta)
    local posY = self:getPositionY()
    if posY < -50 then
        self:dispose()
    else
        self:setPositionY(posY - 0.6*delta*GC.HERO_BULLET_SPEED.HAND_GUN)
    end
end

return EnemyNormalBullet