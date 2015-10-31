
local ViewMgr       = require("app.manager.ViewMgr")
local ViewConst     = require("app.const.ViewConst")
local Font = require("app.component.MbmpFont")

local SettingView = class("SettingView", require("app.core.BaseView"))

function SettingView:ctor(name)
    SettingView.super.ctor(self, name)
end

function SettingView:initView()

    local bg = display.newSprite("#panel_popup.png",display.cx,display.cy):addTo(self)

    self.buttonSound = cc.ui.UIPushButton.new("#button_empty_1.png")
        :pos(246,400)
        :onButtonPressed(function(event)
            event.target:setScale(0.9)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function(event)
            end)
        :addTo(bg):scale(1.0):align(display.CENTER)

    local imgSound = Font.new({
        type="c",value="SOUND  ON"
    }):addTo(self.buttonSound):pos(0,0):align(display.CENTER)
    imgSound:setPosition(-imgSound:getSize().width*0.5,0)

    self.buttonCredits = cc.ui.UIPushButton.new("#button_empty_1.png")
        :pos(246,250)
        :onButtonPressed(function(event)
            event.target:setScale(0.9)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function(event)
            end)
        :addTo(bg):scale(1.0):align(display.CENTER)

    local imgCredits = Font.new({
        type="c",value="CREDITS"
    }):addTo(self.buttonCredits):pos(0,0):align(display.CENTER)
    imgCredits:setPosition(-imgCredits:getSize().width*0.5,0)

    self.buttonBack = cc.ui.UIPushButton.new("#button_empty_red_2.png")
        :pos(246,100)
        :onButtonPressed(function(event)
            event.target:setScale(0.9)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function(event)
            ViewMgr:closeView(ViewConst.SettingView)
            ViewMgr:openView(ViewConst.MainMenu)
        end)
        :addTo(bg):scale(1.0)

    local imgback = Font.new({
        type="c",value="BACK"
    }):addTo(self.buttonBack)
    imgback:setPosition(-imgback:getSize().width*0.5,0)

end

function SettingView:data(value)
end

function SettingView:setBlack()
    self.colorLayer = display.newColorLayer(cc.c4b(0,0,0,0))--cc.LayerColor:create()
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


return SettingView