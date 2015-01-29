
local BaseObject = class("BaseObject", function()
    return display.newNode()
end)

function BaseObject:ctor()
end

function BaseObject:enterFrame(delta)
end

return BaseObject