
require("cocos.init")
require("framework.init")
require("app.init")

local LoadUtils     = require("app.utils.LoadUtils")

local GameApp = class("GameApp", cc.mvc.AppBase)

function GameApp:ctor()
    GameApp.super.ctor(self)
end

function GameApp:run()
    SaveMgr:openDataBase()
    require("app.cache.Cache"):init()
    LoadUtils:loadCommonSource(function()
        LoadUtils:loadSource("MainScene",function()
            self:enterScene("MainScene")
        end)
    end)
end

function GameApp:enterScene(name,...)
    require("app.manager.ViewMgr"):changeScene()
    GameApp.super.enterScene(self,name,...)
end

function GameApp:enterFightScene()
    LoadUtils:loadSource("FightScene",function()
        self:enterScene("FightScene")
    end)
end

--应用进入后台
function GameApp:onEnterBackground()
    GameApp.super.onEnterBackground(self)
end

--应用从后台恢复运行
function GameApp:onEnterForeground()
    GameApp.super.onEnterForeground(self)
end

return GameApp
