
local BackgroundLayer = class("BackgroundLayer", function()
    return display.newLayer()
end)

function BackgroundLayer:ctor(config)
    self.mainLayer = display.newLayer():addTo(self):align(display.LEFT_BOTTOM):scale(display.width/640)
    self.config = config or GC.level[1]
    self.bgList = {}
    for i=1,10 do
        local bg = display.newSprite("#"..self.config[2],0,(i-1)*200):addTo(self.mainLayer):align(display.LEFT_BOTTOM)
        table.insert(self.bgList,i,bg)
    end
end

function BackgroundLayer:enterFrame(delta)
    for i=1,10 do
        local bg = self.bgList[i]
        local posY = bg:getPositionY()
        local height = bg:getContentSize().height
        if posY < -height then
            table.remove(self.bgList,i)
            bg:setPosition(cc.p(0,8*200))
            table.insert(self.bgList,10,bg)
            i = i - 1
        else
            bg:setPositionY(posY - delta * GC.background_speed)
        end
    end
end


return BackgroundLayer