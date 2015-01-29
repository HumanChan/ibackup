local BaseButton = require("app.component.BaseButton")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    
    local btnStart = BaseButton:new()
    btnStart:setData({imgName="button_start.png" , callback=function()
        app:enterScene("FightScene")
    end})
    btnStart:setScale(GC.scale)
    btnStart:setPosition(display.cx,display.cy)
    self:addChild(btnStart)


end

function MainScene:onEnter()

end

function MainScene:onExit()
end

return MainScene
