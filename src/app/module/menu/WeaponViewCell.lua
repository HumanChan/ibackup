
local Font = require("app.component.MbmpFont")

local WeaponViewCell = class("WeaponViewCell",function()
    return display.newNode()
end)

function WeaponViewCell:ctor()

    local bg = display.newScale9Sprite("#panel_item.png",264,0,cc.size(528,168)):addTo(self)

    self.itemTitle = Font.new({
        type="b",value=""
    }):addTo(self):pos(160,40):scale(0.65)

    local coinImg = display.newSprite("#icon_coins_small.png",200,-40):addTo(self)
    self.priceText = Font.new({
        type="aa",value=""
    }):addTo(self):pos(250,-40):scale(0.65)

end

function WeaponViewCell:setData(data)
    self.id = data
    local iconName
    if data == 1 then
        self.itemTitle:setValue("HAND GUN")
        self.priceText:setValue("200")
        self.price = 200
        iconName = "#weapon_icon_1.png"
    elseif data == 2 then
        self.itemTitle:setValue("MACHIN GUN")
        self.priceText:setValue("300")
        self.price = 300
        iconName = "#weapon_icon_2.png"
    elseif data == 3 then
        self.itemTitle:setValue("SHOT GUN")
        self.priceText:setValue("400")
        self.price = 400
        iconName = "#weapon_icon_3.png"
    elseif data == 4 then
        self.itemTitle:setValue("BAZOOKA")
        self.priceText:setValue("500")
        self.price = 500
        iconName = "#weapon_icon_4.png"
    elseif data == 5 then
        self.itemTitle:setValue("HOMING ROCKET")
        self.priceText:setValue("600")
        self.price = 600
        iconName = "#weapon_icon_5.png"
    elseif data == 6 then
        self.itemTitle:setValue("LASER")
        self.priceText:setValue("700")
        self.price = 700
        iconName = "#weapon_icon_6.png"
    end

    self.icon = display.newScale9Sprite(iconName,80,-5,cc.size(150,150)):addTo(self):scale(0.8)

    self.buttonUpgrade = cc.ui.UIPushButton.new("#button_empty_1.png")
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

    local imgUpgrade = Font.new({
        type="aa",value="UPGRADE"
    }):addTo(self.buttonUpgrade):pos(-80,0):align(display.LEFT_BOTTOM)

end



return WeaponViewCell