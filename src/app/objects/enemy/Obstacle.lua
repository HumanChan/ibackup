
local Obstacle = class("Obstacle", require("app.objects.BaseObject"))

function Obstacle:ctor()
    self.facade = display.newSprite("#fence.png"):addTo(self)
    self.box = self.facade:getBoundingBox()
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