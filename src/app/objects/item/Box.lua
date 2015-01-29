

local Box = class("Box", function()
    return cc.Sprite:createWithSpriteFrameName("box.png")
end)

function Box:ctor()
    self:setScale(GC.scale)
    self.type = CONSTANT.ITEM_TYPE.BOX
    self.def = 1
    self.isActive = true

end

function Box:open()
    
end

function Box:enterFrame(delta)

end


return Box