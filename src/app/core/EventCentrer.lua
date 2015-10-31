--[[--

]]


local EventCentrer = {}

function EventCentrer:addEventProtocol(target)
    cc(target):addComponent("components.behavior.EventProtocol"):exportMethods()
end


EventCentrer.listeners_ = {}
EventCentrer.nextListenerHandleIndex_ = 0

--[[--
添加事件
@param eventName 事件名
@param listener 回掉函数
@param tag 回掉的父对象
@param a注意：如果回调函数是用local定义的局部变量，请不要设置tag值，如下：
local testCallFun = function()
    print("test_event")
end
EventCentrer:addEventListener("TEST_EVENT", testCallFun)
]]
function EventCentrer:addEventListener(eventName, listener, tag)
    if self.listeners_[eventName] == nil then
        self.listeners_[eventName] = {}
    end
    self.nextListenerHandleIndex_ = self.nextListenerHandleIndex_ + 1
    local handle = tostring(self.nextListenerHandleIndex_)
    self.listeners_[eventName][handle] = {listener, tag}
end

--[[--
调度事件
@param eventName 事件名
@param data调度事件后的回掉函数参数数据
]]
function EventCentrer:dispatchEvent(eventName, data)
    local newListeners = self.listeners_[eventName]
    if newListeners then
        local newData = {
            name = eventName,
            data = data
        }
        for handle, listener in pairs(newListeners) do
            if listener[2] then
                handler(listener[2], listener[1])(newData)
            else
                listener[1](newData) 	
            end
        end
    end
end

--[[--
删除指定事件对应的回掉
@param eventName 事件名
@param listener 回掉函数
]]
function EventCentrer:removeEventListener(eventName,listener)
    local newListeners = self.listeners_[eventName]
    if newListeners then
        for handle, value in pairs(newListeners) do
            if value[1] == listener then
                newListeners[handle] = nil
            end
        end
    end
end

--[[--
删除指定事件
@param eventName 事件名
]]
function EventCentrer:removeEventListenersByEvent(eventName)
    self.listeners_[eventName] = nil
end

--[[--
删除所有事件
]]
function EventCentrer:removeAllEventListeners()
    self.listeners_ = {}
end

--[[--
返回指定事件是否存在
@param eventName 事件名
]]
function EventCentrer:hasEventListener(eventName)
    local t = self.listeners_[eventName]
    for _, __ in pairs(t) do
        return true
    end
    return false
end

return EventCentrer