
local HeroNormalBullet = class("HeroNormalBullet", require("app.objects.BaseObject"))

function HeroNormalBullet:ctor()
    self.facade = display.newSprite("#bullet1.png"):addTo(self)
    self.facade:setRotation(-90)
    self.box = self.facade:getBoundingBox()
    self.power = 1
    self.isActive = true
end

function HeroNormalBullet:dispose()
    self.isActive = false
    self:removeFromParent(true)
end

function HeroNormalBullet:enterFrame(delta)
    local posY = self:getPositionY()
    if posY > display.height - 70 then
        self:dispose()
    else
        self:setPositionY(posY + delta*GC.HERO_BULLET_SPEED.HAND_GUN)
    end
end

return HeroNormalBullet