local BaseButton = require("app.component.BaseButton")

local FightUI = class("FightUI",function()
    return display.newLayer()
end)

function FightUI:ctor()
    self:init()
end

function FightUI:init()
    
    local btnRestart = BaseButton:new()
    btnRestart:setData({imgName="arrow.png" , callback=function()
        cc.Director:getInstance():getRunningScene():restart()
    end})
    btnRestart:setScale(GC.scale)
    btnRestart:setPosition(display.width - 30,display.height - 30)
    self:addChild(btnRestart)
    
end










return FightUI