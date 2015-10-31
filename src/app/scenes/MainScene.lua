--[[--
主场景
]]

local ViewMgr       = require("app.manager.ViewMgr")
local ViewConst     = require("app.const.ViewConst")
local LoadUtils     = require("app.utils.LoadUtils")
local scheduler         = require("framework.scheduler")
local Font = require("app.component.MbmpFont")

local MainScene = class("MainScene", require("app.core.BaseScene"))

function MainScene:ctor()
    mainRunScene = self
    MainScene.super.ctor(self)
end

function MainScene:init()

    --background
    self.background = require("app.fight.BackgroundLayer").new():addTo(self.baseLayer):align(display.LEFT_BOTTOM)

    --TopBar
    local scoreBar = display.newSprite("#panel_score.png",display.cx - 145,display.height-65):addTo(self.uiLayer):scale(0.9)
    self.scoreText = display.newTTFLabel({text="SCORE",size=30}):addTo(scoreBar):pos(110,80):align(display.LEFT_CENTER)
    self.scoreText:setColor(cc.c3b(0,0,0))
    self.bestScore = Font.new({
        type="aa",value="400800"
    }):addTo(scoreBar):pos(115,35):align(display.LEFT_BOTTOM):scale(0.9)

    local coinBar = display.newSprite("#panel_coins_2.png",display.cx + 145,display.height-65):addTo(self.uiLayer):scale(0.9)
    self.coinText = Font.new({
        type="aa",value="1000"
    }):addTo(coinBar):pos(85,65):align(display.LEFT_BOTTOM):scale(0.9)
    local buttonAdd = cc.ui.UIPushButton.new("#panel_button_add_2.png")
        :pos(275,60)
        :onButtonPressed(function(event)
            event.target:setScale(0.9)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function(event)
            end)
        :addTo(coinBar):scale(1.0)

    self.panel_bottom = display.newScale9Sprite("#panel_bottom.png",display.cx,80,cc.size(640,160)):addTo(self.uiLayer)
    local buttonLeft = cc.ui.UIPushButton.new("#panel_bottom_button_ranking.png")
        :pos(display.cx-180,115)
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(0.9)
        end)
        :onButtonClicked(function(event)
            end)
        :addTo(self.uiLayer):scale(0.9)
    local buttonRight = cc.ui.UIPushButton.new("#panel_bottom_button_setting.png")
        :pos(display.cx+180,115)
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(0.9)
        end)
        :onButtonClicked(function(event)
            ViewMgr:closeView(ViewConst.MainMenu)
            ViewMgr:openView(ViewConst.SettingView)
        end)
        :addTo(self.uiLayer):scale(0.9)


    ViewMgr:openView(ViewConst.MainMenu)

end

function MainScene:onEnter()
    self:init()
    self.backgroundTimer = scheduler.scheduleGlobal(function(dt)
        self.background:enterFrame(dt)
    end,0)
end

function MainScene:onExit()
    scheduler.unscheduleGlobal(self.backgroundTimer)
--    require("app.utils.LoadUtils"):clearSource("MainScene")
end

return MainScene
