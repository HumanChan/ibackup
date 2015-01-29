
local EnemyNormalBullet = class("EnemyNormalBullet", require("app.objects.BaseObject"))

function EnemyNormalBullet:ctor()
    self.facade = cc.Sprite:createWithSpriteFrameName("bullet1.png")
    self.facade:setRotation(90)
    self.facade:setScale(GC.scale)
    self:addChild(self.facade)
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
        self:setPositionY(posY - 0.45*delta*GC.HERO_BULLET_SPEED.HAND_GUN)
    end
end

return EnemyNormalBullet