
local MbmpFont = class("MbmpFont",function()
    return display.newNode()
end)

--创建图片
--@param {value(值)，type(图片类型，默认numA),spacing(图片间距)}
function MbmpFont:ctor(params)
    self.type = params.type or "a"
    self.spacing = params.spacing or 0
    self:createImg(params.value)
end


--创建图片
function MbmpFont:createImg(value)
    if value then
        if self.charList then
            for key, var in pairs(self.charList) do
                var:removeFromParent()
            end
        end
        self.charList = {}
        local imgWidth = 0
        local newValue = value .. ""
        local length = string.len(newValue)
        for i=1, length do
            local newTag = string.sub(newValue,i,i)

            local asciiTag = string.byte(newTag)
            if asciiTag ~= 32 and asciiTag ~= 9 then
                local newName = "#" .. self.type .. "_" .. asciiTag .. ".png"
                local newCharImg = display.newSprite(newName)
                self:addChild(newCharImg)
                if imgWidth == 0 then
                    imgWidth = newCharImg:getContentSize().width + self.spacing
                end
                newCharImg:setPosition(imgWidth*(i-1),0)
                table.insert(self.charList, newCharImg)
            end
        end
    end
end

--设置数据
function MbmpFont:setValue(value)
    self:createImg(value)
end


function MbmpFont:setString(value)
    self:createImg(value)
    self:center()
end

--设置数字类型
function MbmpFont:setType(value)
    self.type = value
end

--设置间距
function MbmpFont:setSpacing(value)
    self.spacing = value
end

--获取大小
--return width,height
function MbmpFont:getSize()
    local target = self.charList[#self.charList]
    local targetSize = target:getContentSize()
    return {width = targetSize.width + target:getPositionX(), height = targetSize.height}
end

function MbmpFont:center()
    local width = -self.spacing
    local height = 0
    for i = 1, #self.charList do
        local img = self.charList[i]
        img:align(display.LEFT_CENTER)
        img:setPositionX(width)
        local size = img:getContentSize()
        if height == 0 then
            height = size.height
        end
        if i == #self.charList then
            width = width + size.width
        else
            width = width + size.width + self.spacing
        end
    end
    self:setContentSize(cc.size(width,height))
end

return MbmpFont