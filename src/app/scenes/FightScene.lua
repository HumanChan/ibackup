local scheduler         = require("framework.scheduler")

local FightScene = class("FightScene", function()
    return display.newScene("FightScene")
end)

function FightScene:ctor()

    self.cache = require("app.cache.GameCache")
    
    --背景
    self.background = require("app.terrain.BackgroundLayer").new()
    self:addChild(self.background)

    --战斗层
    self.gameLayer = require("app.fight.GameLayer").new(self.cache)
    self:addChild(self.gameLayer)

    --UI
    self.ui = require("app.ui.FightUI").new()
    self:addChild(self.ui)

end

function FightScene:restart()
    self.cache:clear()
    self:removeAllChildren(true)
    self:onExit()
    app:enterScene("FightScene")
end

function FightScene:enterNextLevel()

end

function FightScene:onEnter()
    self.fightTimer = scheduler.scheduleGlobal(function(dt)
        self.background:enterFrame(dt)
        self.gameLayer:enterFrame(dt)
    end,0)
end

--战斗结束
function FightScene:fightEnd()
    scheduler.unscheduleGlobal(self.fightTimer)
end

function FightScene:onExit()
    self:fightEnd()
end

return FightScene
