
local ItemManager = class("ItemManager",function()
    return {}
end)


function ItemManager:ctor()
    self.terrainItems = {}
    self.screenItems = {}
end


function ItemManager:enterFrame(delta)
    for i=1,#self.terrainItems do
        local item = self.terrainItems[i]
        if item and item.isActive then
            local e = item:convertToWorldSpace(cc.p(0,0))
            if e.y < -10 then
                table.remove(self.terrainItems,i)
                i = i - 1
            elseif e.y < display.height + 50 then
                item:enterFrame(delta)
            end
        else
            table.remove(self.terrainItems,i)
            i = i - 1
        end
    end

    for j=1,#self.screenItems do
        local item = self.screenItems[j]
        if item and item.isActive then
            local e = item:convertToWorldSpace(cc.p(0,0))
            if e.y < -10 then
                table.remove(self.screenItems,j)
                j = j - 1
            elseif e.y < display.height + 50 then
                item:enterFrame(delta)
            end
        else
            table.remove(self.screenItems,j)
            j = j - 1
        end
    end

end



return ItemManager