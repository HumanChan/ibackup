--[[--

]]
local ResConst          = require("app.const.ResConst")

local LoadUtils = {}

function LoadUtils:loadCommonSource(onCallFun)
    local addIndex = 0
    local resList = ResConst.common
    local totalNum = #resList
    for key, var in pairs(resList) do
        display.addSpriteFrames(var[1], var[2], function(var1,var2)
            addIndex = addIndex + 1
            if addIndex == totalNum then
                onCallFun()
            end
        end)
    end
end

function LoadUtils:getResList(type)
    local resList
    if type == "MainScene" then
        resList = ResConst.main_ui
    elseif type == "FightScene" then
        resList = ResConst.fight
    elseif type == "Over" then
        resList = ResConst.over
    end
    return resList
end

function LoadUtils:loadSource(type,onCallFun)
    local addIndex = 0
    local resList = self:getResList(type)
    if resList then
        local totalNum = #resList
        for key, var in pairs(resList) do
            display.addSpriteFrames(var[1], var[2], function(var1,var2)
                addIndex = addIndex + 1
                if addIndex == totalNum then
                    local scheduler = require("framework.scheduler")
                    scheduler.performWithDelayGlobal(function()
                        onCallFun()
                    end,0.1)
                end
            end)
        end
    end
end

function LoadUtils:clearSource(type)
    local resList = self:getResList(type)
    if resList then
        for key, var in pairs(resList) do
            display.removeSpriteFramesWithFile(var[1], var[2])
        end
    end
end



return LoadUtils