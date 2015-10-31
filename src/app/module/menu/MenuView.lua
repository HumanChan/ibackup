
local ViewMgr       = require("app.manager.ViewMgr")
local ViewConst     = require("app.const.ViewConst")

local MenuView = class("MenuView", require("app.core.BaseView"))

function MenuView:ctor(name)
    MenuView.super.ctor(self, name)
end

function MenuView:initView()
    local buttonStart = cc.ui.UIPushButton.new("#button_start.png")
        :pos(display.cx,display.cy + 180)
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(0.9)
        end)
        :onButtonClicked(function(event)
            require("app.cache.GameCache"):init()
            app:enterScene("FightScene")
        end)
        :addTo(self):scale(0.9)
    local buttonWeapon = cc.ui.UIPushButton.new("#button_weapons.png")
        :pos(display.cx,display.cy)
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(0.9)
        end)
        :onButtonClicked(function(event)
            ViewMgr:closeView(ViewConst.MainMenu)
            ViewMgr:openView(ViewConst.WeaponView)
        end)
        :addTo(self):scale(0.9)
    local buttonItem = cc.ui.UIPushButton.new("#button_items.png")
        :pos(display.cx,display.cy-180)
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(0.9)
        end)
        :onButtonClicked(function(event)
            ViewMgr:closeView(ViewConst.MainMenu)
            ViewMgr:openView(ViewConst.ItemView)
        end)
        :addTo(self):scale(0.9)
end

function MenuView:data(value)
end

function MenuView:setBlack()
end

return MenuView