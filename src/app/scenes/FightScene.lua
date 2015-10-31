--[[--
战斗场景
]]
local scheduler         = require("framework.scheduler")

local FightScene = class("FightScene", require("app.core.BaseScene"))

function FightScene:ctor()
    FightScene.super.ctor(self)
    self:init()
end

function FightScene:init()
    self.gameCache = require("app.cache.GameCache")
    --战斗层
    local config = {}
    config.level = 1
    config.walkMode = GC.WALK_MODE.horizontal
    config.heros = {}
    for i=1,2 do
        local heroConfig = {}
        heroConfig.id = i
        heroConfig.weaponID = CONSTANT.WEAPON_ID.HAND_GUN
        table.insert(config.heros,heroConfig)
    end
    self.gameLayer = require("app.fight.GameLayer").new(config):addTo(self.baseLayer):align(display.LEFT_BOTTOM)
    self.gameUI = require("app.fight.GameUI").new():addTo(self.uiLayer):align(display.LEFT_BOTTOM)

    self:initEvents()
end

function FightScene:initEvents()
    EventCentrer:addEventListener(EventConst.FIGHT_PAUSE, self.onFightPause, self)
    EventCentrer:addEventListener(EventConst.FIGHT_END, self.onFightEnd, self)
end

function FightScene:removeEvents()
    EventCentrer:removeEventListener(EventConst.FIGHT_PAUSE, self.onFightPause)
    EventCentrer:removeEventListener(EventConst.FIGHT_END, self.onFightEnd)
end

function FightScene:onEnter()
    self.fightTimer = scheduler.scheduleGlobal(function(dt)
        if self.gameCache.pause ~= true then
            self.gameLayer:enterFrame(dt)
        end
    end,0)
end

function FightScene:onFightPause(value)
    if value.data == "pause" then
        self.gameCache.pause = true
        self.gameLayer:pause()
    elseif value.data == "resume" then
        self.gameCache.pause = false
        self.gameLayer:resume()
    end
end

--战斗结束
function FightScene:onFightEnd()
    scheduler.unscheduleGlobal(self.fightTimer)
    app:enterScene("MainScene")
end

function FightScene:onExit()
    self:removeEvents()
    --    self:fightEnd()
    --    require("app.utils.LoadUtils"):clearSource("FightScene")
end

return FightScene
