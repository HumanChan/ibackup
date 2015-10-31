
local Cage = class("Cage", require("app.objects.BaseObject"))

function Cage:ctor()
    self.type = CONSTANT.ITEM_TYPE.CAGE
    self.facade = display.newSprite("#cage.png"):addTo(self):scale(0.8)
    self.box = self.facade:getBoundingBox()
    self.sign = display.newSprite("#help.png",self.box.width*0.5,self.box.height*0.8):addTo(self.facade):scale(0.8)
    self:setAnimation()
    self.def = 1
    self.isActive = true
end

function Cage:dispose()
    self.isActive = false
    self:removeFromParent()
end

function Cage:setAnimation()
    local animFrames = {}
    local frame1 = cc.SpriteFrameCache:getInstance():getSpriteFrame("help.png")
    table.insert(animFrames,1,frame1)

    local frame2 = cc.SpriteFrameCache:getInstance():getSpriteFrame("help02.png")
    table.insert(animFrames,2,frame2)

    local animation = cc.Animation:createWithSpriteFrames(animFrames,0.5)
    local action = cc.RepeatForever:create(cc.Animate:create(animation))
    self.sign:runAction(action)
end

function Cage:enterFrame(delta)

end


return Cage