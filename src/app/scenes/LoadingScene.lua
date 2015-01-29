
local ResConst = require("app.const.ResConst")

local LoadingScene = class("LoadingScene", function()
    return display.newScene("LoadingScene")
end)

function LoadingScene:ctor()
    self:init()
end

function LoadingScene:init()
    self.resLoader = require("app.utils.ResLoader")
    print("LoadingScene init")
end

function LoadingScene:onEnter()
    self:startLoad()
end

function LoadingScene:onExit()
end

function LoadingScene:startLoad()

    local textureList = ResConst.texture
    local textureNum = #textureList
    local totalCount = textureNum
    local curNum = 0
    for i=1,textureNum do
        self.resLoader:loadSpriteFrames(textureList[i][1],textureList[i][2],function()
            curNum = curNum + 1
            if curNum == totalCount then
                self:onLoadEnded()
            end
        end)
    end

end

function LoadingScene:onLoadEnded()
    --    print("info { "..cc.Director:getInstance():getTextureCache():getCachedTextureInfo().." }")
    app:enterScene("MainScene")
end


return LoadingScene
