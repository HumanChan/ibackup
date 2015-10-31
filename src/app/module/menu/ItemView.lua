
local ItemViewCell = require("app.module.menu.ItemViewCell")
local Font = require("app.component.MbmpFont")
local ViewMgr       = require("app.manager.ViewMgr")
local ViewConst     = require("app.const.ViewConst")

local ItemView = class("ItemView", require("app.core.BaseView"))

function ItemView:ctor(name)
    ItemView.super.ctor(self, name)
end

function ItemView:initView()

    self.listView = cc.ui.UIListView.new {
        bgScale9 = true,
        viewRect = cc.rect(display.cx-264, display.cy-200, 528, 168*3),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        alignment = cc.ui.UIListView.ALIGNMENT_LEFT}
        :addTo(self)

    for i=1,3 do
        local item = self.listView:newItem()
        item:setItemSize(self.listView:getViewRect().width, self.listView:getViewRect().height/3)
        local content = ItemViewCell.new()
        content:setData(i)
        item:addContent(content)
        self.listView:addItem(item)
    end

    self.listView:reload()

    self.buttonBack = cc.ui.UIPushButton.new("#button_empty_red_1.png")
        :pos(display.cx,175)
        :onButtonPressed(function(event)
            event.target:setScale(0.7)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(0.8)
        end)
        :onButtonClicked(function(event)
            ViewMgr:closeView(ViewConst.ItemView)
            ViewMgr:openView(ViewConst.MainMenu)
        end)
        :addTo(self):scale(0.8)

    local imgback = Font.new({
        type="c",value="BACK"
    }):addTo(self.buttonBack):pos(-38,0)

end

function ItemView:data(value)
end

function ItemView:setBlack()
    self.colorLayer = display.newColorLayer(cc.c4b(0,0,0,0))--cc.LayerColor:create()
    self.colorLayer:setLocalZOrder(-2)
    self:addChild(self.colorLayer)

    self.touchNode = display.newNode():addTo(self):size(display.width,display.height)
    self.touchNode:setLocalZOrder(-2)
    self.touchNode:setTouchEnabled(true)
    self.touchNode:setTouchSwallowEnabled(true) 
    self.touchNode:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        if event.name == "began" then
            return true
        elseif event.name == "moved" then
        elseif event.name == "ended" then
            local rect = cc.rect(self:getPositionX(),self:getPositionY(),self:getContentSize().width,self:getContentSize().height)
            self:onTouch(event)
            if not cc.rectContainsPoint(rect,cc.p(event.x,event.y)) then
                self:backClick()
            end
        elseif event.name == "cancelled" then
        end
    end)
end

return ItemView