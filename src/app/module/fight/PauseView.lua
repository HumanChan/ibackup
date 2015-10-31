
local ViewMgr       = require("app.manager.ViewMgr")
local ViewConst     = require("app.const.ViewConst")
local Font = require("app.component.MbmpFont")

local PauseView = class("PauseView", require("app.core.BaseView"))

function PauseView:ctor(name)
    PauseView.super.ctor(self, name)
end

function PauseView:initView()

    local bg = display.newSprite("#panel_popup.png",display.cx,display.cy):addTo(self)

    self.buttonSound = cc.ui.UIPushButton.new("#button_empty_1.png")
        :pos(246,100)
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

    self.buttonResume = cc.ui.UIPushButton.new("#button_empty_1.png")
        :pos(246,400)
        :onButtonPressed(function(event)
            event.target:setScale(0.9)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function(event)
            EventCentrer:dispatchEvent(EventConst.FIGHT_PAUSE,"resume")
            ViewMgr:closeView(ViewConst.PauseView)
        end)
        :addTo(bg):scale(1.0):align(display.CENTER)

    local imgResume = Font.new({
        type="c",value="RESUME"
    }):addTo(self.buttonResume):pos(0,0):align(display.CENTER)
    imgResume:setPosition(-imgResume:getSize().width*0.5,0)

    self.buttonQuit = cc.ui.UIPushButton.new("#button_empty_red_1.png")
        :pos(246,250)
        :onButtonPressed(function(event)
            event.target:setScale(0.9)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function(event)
--            ViewMgr:closeView(ViewConst.PauseView)
            EventCentrer:dispatchEvent(EventConst.FIGHT_END,"GameEnd")
        end)
        :addTo(bg):scale(1.0)

    local imgQuit = Font.new({
        type="c",value="QUIT"
    }):addTo(self.buttonQuit)
    imgQuit:setPosition(-imgQuit:getSize().width*0.5,0)

end

function PauseView:data(value)
end


return PauseView