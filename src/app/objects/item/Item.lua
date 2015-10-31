
local Item = class("Item", require("app.objects.BaseObject"))

function Item:ctor(type)
    self.isActive = true
    self.id = type
    if type == CONSTANT.WEAPON_ID.MACHINE_GUN then
        self.facade = display.newSprite("#drop_weapon01.png"):addTo(self)
    elseif type == CONSTANT.WEAPON_ID.SHOT_GUN then
        self.id = 3
        self.facade = display.newSprite("#drop_weapon02.png"):addTo(self)
    elseif type == CONSTANT.WEAPON_ID.BAZOOKA then
        self.id = 4
        self.facade = display.newSprite("#drop_weapon03.png"):addTo(self)
    elseif type == CONSTANT.WEAPON_ID.HOMING_ROCKET then
        self.facade = display.newSprite("#drop_weapon04.png"):addTo(self)
    elseif type == CONSTANT.WEAPON_ID.LASER then
        self.facade = display.newSprite("#drop_weapon05.png"):addTo(self)
    end
    self.facade:setScale(0.8)
    self.box = self.facade:getBoundingBox()
end

function Item:getInfo()
    return self.id
end

function Item:dispose()
    self.isActive = false
    self:removeFromParent()
end

function Item:enterFrame(delta)
    local positionY = self:getPositionY() - delta*GC.background_speed
    if positionY > -10 then
        self:setPositionY(positionY)
    else
        self.isActive = false
        self:removeFromParent()
    end
end


return Item