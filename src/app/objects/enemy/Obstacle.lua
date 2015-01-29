
local Obstacle = class("Obstacle", require("app.objects.BaseObject"))

function Obstacle:ctor()
    self.facade = cc.Sprite:createWithSpriteFrameName("fence.png")
    self.facade:setScale(GC.scale)
    self:addChild(self.facade)
    self.def = 2
    self.isActive = true
end

function Obstacle:dispose()
    self.isActive = false
    self:removeFromParent(true)
end

function Obstacle:enterFrame(delta)

end

return Obstacle