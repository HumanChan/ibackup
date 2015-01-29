

local BackgroundLayer = class("BackgroundLayer", function()
    return display.newLayer()
end)

function BackgroundLayer:ctor(config)
    self.cf = config or GC.level[1]

    self.bgList = {}
    for i=1,10 do
        local bg = cc.Sprite:createWithSpriteFrameName(self.cf[2])
        bg:setAnchorPoint(cc.p(0,0))
        bg:setScale(GC.scaleBg)
        bg:setPosition(cc.p(0,(i-1)*120))
        self:addChild(bg)
        table.insert(self.bgList,i,bg)
    end

end

function BackgroundLayer:enterFrame(delta)
    for i=1,10 do
        local bg = self.bgList[i]
        local posY = bg:getPositionY()
        local height = bg:getContentSize().height
        if i == 1 and posY < -height then
            table.remove(self.bgList,i)
            local bg = cc.Sprite:createWithSpriteFrameName(self.cf[2])
            bg:setAnchorPoint(cc.p(0,0))
            bg:setScale(GC.scaleBg)
            bg:setPosition(cc.p(0,6*120))
            self:addChild(bg)
            table.insert(self.bgList,10,bg)
            i = i - 1
        else
            bg:setPositionY(posY - delta * GC.background_speed)
        end
    end
end


return BackgroundLayer