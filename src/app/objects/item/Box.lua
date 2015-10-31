local Item = require("app.objects.item.Item")

local Box = class("Box", require("app.objects.BaseObject"))

function Box:ctor()
    self.type = CONSTANT.ITEM_TYPE.BOX
    self.facade = display.newSprite("#box.png"):addTo(self)
    self.box = self.facade:getBoundingBox()
    self.def = 1
    self.isActive = true
end

function Box:open()
    self.isActive = false

    local randNum = math.random(1,100)
    local total = 0
    local k
    for i=1,#GC.WEAPON_CREATE_PROBABILITY do
        total = total + GC.WEAPON_CREATE_PROBABILITY[i]
        if total >= randNum then
            k = i
            break
        end
    end
    local itemName = GC.WEAPON_CREATE_ID[k]
    local item = Item.new(itemName)
    local e = self:convertToWorldSpace(cc.p(0,0))
    item:setPosition(e.x+25,e.y+25)
    m_GameLayer:addChild(item,3)
    table.insert(m_GameLayer.itemManager.screenItems,item)
    self:removeFromParent()
end

function Box:enterFrame(delta)

end


return Box