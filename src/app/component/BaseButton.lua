
local BaseButton = class("BaseButton", function()
    return display.newNode()
end)

function BaseButton:ctor()
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self,self.onTouch)) 
end

function BaseButton:setData(params)
    self.image = cc.Sprite:createWithSpriteFrameName(params.imgName)
    self:addChild(self.image)
    --按钮回调    
    self.callback = params.callback
end

function BaseButton:onTouch(event)
    if event.name == "began" then
        return true
    end
    if event.name == "moved" then
    end
    if event.name == "ended" then   
        self.callback()
    end
end

return BaseButton