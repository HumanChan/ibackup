
local sharedTextureCache     = cc.Director:getInstance():getTextureCache()
local sharedSpriteFrameCache = cc.SpriteFrameCache:getInstance()

local ResLoader = class("ResLoader",function()
    return {}
end)


function ResLoader:ctor()
end

function ResLoader:loadSpriteFrames(plistFilename, image, handler)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(plistFilename, image)
    handler(plistFilename, image)
end


function ResLoader:loadBigImg(strPath,handler)
    return sharedTextureCache:addImageAsync(strPath, handler)
end

return ResLoader