
local BaseObject = class("BaseObject", function()
    return display.newNode()
end)

function BaseObject:ctor()
end

function BaseObject:getType()
    if self.type then
        return self.type
    end
end

function BaseObject:getBox()
    if self.box then
        return self.box
    end
end

function BaseObject:stopAction()
end

function BaseObject:resumeAction()
end

function BaseObject:enterFrame(delta)
end

return BaseObject