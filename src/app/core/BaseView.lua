--[[--
窗口基类
]]

local ViewMgr = require("app.manager.ViewMgr")
local BaseView = class("BaseView", function()
    return display.newNode()
end)

function BaseView:ctor(name)
    self.winName = name
    self:setBlack()
    self:setSize(display.size)
    self:initWinBg()
    self:initView()
    self:initCloseBtn()
    self:allowNodeEvent()
end

function BaseView:initView()

end

function BaseView:data(value)

end

---------------------------
-- 设置窗口位置
function BaseView:updatePosition()
    local viewSize = self:getContentSize()
    local gameSize = display.size
    self:setPosition((gameSize.width-viewSize.width)/2, (gameSize.height-viewSize.height)/2)
    if self.colorLayer then
        self.colorLayer:setPosition((viewSize.width-gameSize.width)/2,(viewSize.height-gameSize.height)/2)
    end
    if self.touchNode then
        self.touchNode:setPosition((viewSize.width-gameSize.width)/2,(viewSize.height-gameSize.height)/2)
    end
end

function BaseView:setSize(size)
    self:setContentSize(size)
    if self.closeBtn then
        self.closeBtn:pos(50,self:getContentSize().height+40)
    end
end

---------------------------
-- 初始化窗口背景
function BaseView:initWinBg()

end

---------------------------
--@function 暗黑背景 | 如果无需黑色背景子类覆盖该方法
function BaseView:setBlack()
    self.colorLayer = display.newColorLayer(cc.c4b(0,0,0,150))--cc.LayerColor:create()
    self.colorLayer:setLocalZOrder(-2)
    self:addChild(self.colorLayer)

    self.touchNode = display.newNode():addTo(self):size(display.width,display.height)
    self.touchNode:setLocalZOrder(-2)
    self.touchNode:setTouchEnabled(true)
    self.touchNode:setTouchSwallowEnabled(true) 
    self.touchNode:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        if event.name == "began" then
            return true
        elseif event.name == "moved" then
        elseif event.name == "ended" then
            local rect = cc.rect(self:getPositionX(),self:getPositionY(),self:getContentSize().width,self:getContentSize().height)
            self:onTouch(event)
            if not cc.rectContainsPoint(rect,cc.p(event.x,event.y)) then
                self:backClick()
            end
        elseif event.name == "cancelled" then
        end
    end)
end

---------------------------
--点击界面
function BaseView:onTouch(event)
	
end

---------------------------
--@function [parent=#BaseView] backClick
--@param self
function BaseView:backClick()

end

---------------------------
-- 初始化关闭按钮
function BaseView:initCloseBtn()
--    local viewSize = self:getContentSize()
--    self.closeBtn = cc.ui.UIPushButton.new("#return_bg.png",nil,{scale9=true})
--        :setButtonSize(100,100):addTo(self)
--        :onButtonPressed(function(event)
--            event.target:setScale(1.2)
--        end)
--        :onButtonRelease(function(event)
--            event.target:setScale(1.0)
--        end)
--        :onButtonClicked(function()
--            self:close()
--        end)
--        :pos(49,viewSize.height-60)
end

---------------------------
-- 关闭窗口
function BaseView:close()
    ViewMgr:closeView(self.winName)
end

---------------------------
--@function 设置节点事件 |onEnter/onExit
function BaseView:allowNodeEvent()
    self:registerScriptHandler(function(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end)
end

function BaseView:onEnter()

end

function BaseView:onExit()
    print("exit......")
end

return BaseView