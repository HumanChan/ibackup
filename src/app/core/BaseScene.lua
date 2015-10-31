--[[--
场景基类
]]
local BaseScene = class("BaseScene", function()
    return display.newScene("BaseScene")
end)

function BaseScene:ctor()
    self:createAppExit()
    --基础底层
    self.baseLayer = display.newNode()
    self:addChild(self.baseLayer)
    --自身UI层
    self.uiLayer = display.newNode()
    self:addChild(self.uiLayer)
    --窗口层
    self.winLayer = display.newNode()
    self:addChild(self.winLayer)
    --引导
    self.guideLayer = display.newNode()
    self:addChild(self.guideLayer)
end

function BaseScene:createAppExit()
--    local keyListener = cc.EventListenerKeyboard:create()
--    local function onrelease(code, event)
--        if code == cc.KeyCode.KEY_BACK then
--            --app:exit()
--            local ViewMgr = require("app.manager.ViewMgr")
--            local ViewConst = require("app.const.ViewConst")
--            local winName = ViewMgr:getTopWinName()
--            if winName then
--                ViewMgr:closeView(winName)
--            else
--            end
--        end
--    end
--    keyListener:registerScriptHandler(onrelease,cc.Handler.EVENT_KEYBOARD_RELEASED)
--    local eventDispatch = self:getEventDispatcher()
--    eventDispatch:addEventListenerWithSceneGraphPriority(keyListener,self)
end

function BaseScene:onEnter()

end

function BaseScene:onExit()

end

return BaseScene