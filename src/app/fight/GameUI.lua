
local ViewMgr       = require("app.manager.ViewMgr")
local ViewConst     = require("app.const.ViewConst")

local GameUI = class("GameUI", function()
    return display.newLayer()
end)

function GameUI:ctor()

    local buttonPause = cc.ui.UIPushButton.new("#button_pause.png")
        :pos(60,display.height - 95)
        :onButtonPressed(function(event)
            event.target:setScale(0.8)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(0.9)
        end)
        :onButtonClicked(function(event)
            EventCentrer:dispatchEvent(EventConst.FIGHT_PAUSE,"pause")
            ViewMgr:openView(ViewConst.PauseView)
        end)
        :addTo(self):scale(0.9)

end

function GameUI:enterFrame(delta)

end


return GameUI