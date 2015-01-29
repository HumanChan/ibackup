
require("config")
require("cocos.init")
require("framework.init")
require("app.init")

local GameApp = class("GameApp", cc.mvc.AppBase)

function GameApp:ctor()
    app = self
    GameApp.super.ctor(self)
end

function GameApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("LoadingScene")
end

return GameApp
