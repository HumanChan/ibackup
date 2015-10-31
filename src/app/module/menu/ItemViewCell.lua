
local Font = require("app.component.MbmpFont")

local ItemViewCell = class("ItemViewCell",function()
    return display.newNode()
end)

function ItemViewCell:ctor()

    local bg = display.newScale9Sprite("#panel_item.png",264,0,cc.size(528,168)):addTo(self)

    self.itemTitle = Font.new({
        type="b",value=""
    }):addTo(self):pos(160,40):scale(0.65)

    self.useText = display.newTTFLabel({text="",size=16}):addTo(self):pos(150,0):align(display.LEFT_CENTER)
    self.useText:setColor(cc.c3b(0,0,0))

    local coinImg = display.newSprite("#icon_coins_small.png",200,-40):addTo(self)
    self.priceText = Font.new({
        type="aa",value=""
    }):addTo(self):pos(250,-40):scale(0.65)



end

function ItemViewCell:setData(data)

    local iconName
    if data == 1 then
        self.itemTitle:setValue("BACKUP")
        self.useText:setString("ADD 2 ALLIES")
        self.priceText:setValue("200")
        self.price = 200
        iconName = "#item_icon_2.png"
    elseif data == 2 then
        self.itemTitle:setValue("BULLETPROFF JACKET")
        self.useText:setString("INVISIBLE FOR 8.0 SECONDS")
        self.priceText:setValue("300")
        self.price = 300
        iconName = "#item_icon_3.png"
    elseif data == 3 then
        self.itemTitle:setValue("BOMB")
        self.useText:setString("DROP A BOMB")
        self.priceText:setValue("500")
        self.price = 500
        iconName = "#item_icon_1.png"
    end

    self.icon = display.newScale9Sprite(iconName,80,-5,cc.size(150,150)):addTo(self):scale(0.8)

    self.count = display.newTTFLabel({text="0",size=25}):addTo(self):pos(110,-43):align(display.LEFT_CENTER)
    self.count:setColor(cc.c3b(0,0,0))

    self.buttonBuy = cc.ui.UIPushButton.new("#button_empty_1.png")
        :pos(440,-40)
        :onButtonPressed(function(event)
            event.target:setScale(0.5)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(0.6)
        end)
        :onButtonClicked(function(event)
            end)
        :addTo(self):scale(0.6)

    local imgbuy = Font.new({
        type="aa",value="BUY"
    }):addTo(self.buttonBuy):pos(-30,0)

end




return ItemViewCell