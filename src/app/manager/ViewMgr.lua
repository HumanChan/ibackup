--[[--
场景管理和窗口管理
]]
local ViewMgr = {}
local ViewConst = require("app.const.ViewConst")

---------------------------
--@function 当前运行场景
function ViewMgr:getRunningScene()
    local scene = cc.Director:getInstance():getRunningScene()
    return scene
end

---------------------------
--@function 切换场景|处理切换场景的一些清场和加载过度
--@param sId 场景id
function ViewMgr:changeScene(sId)
    --新场景
    --    local sInfo = ViewConst.scene[sId]
    --    local newScene = require(sInfo.path).new()
    --    --过渡场景
    --    local transScene = require("app.scenes.TransitionScene").new()
    --
    --    display.replaceScene(newScene)
    self.openList = {}
    self.sortOpenList = {}
end

ViewMgr.openList = {}
ViewMgr.sortOpenList = {}

---------------------------
--打开窗口
--@function [parent=#ViewMgr] openView
--@param self
--@param #string name 模块名字
--@param #table data 传入模块的数据
--@param #number index 窗口索引
function ViewMgr:openView(name, data, index)
    local win = self.openList[name]
    if win and win.getParent then
        print("窗口已打开：", name)
        return
    end
    local info = ViewConst.win[name]
    if not info then
        print("没配置模块名为：",name)
        return
    end
    local function dataLoaded(texture)
        local win = require(info.path).new(name)
        win:data(data)
        local parent = self:getRunningScene()
        if parent then
            parent.winLayer:addChild(win)
        else
            print("[ViewMgr-Error]:打开窗口失败，父窗口不存在")
            return
        end
        win:updatePosition()
        self.openList[name] = win
        self:showList(name,true)
        EventCentrer:dispatchEvent(EventConst.OPEN_WINDOW, name)
    end
    ---加入缓存
    if info.source and type(info.source) == "table" then

    else
        dataLoaded()
    end
end

---------------------------
--关闭窗口
--@function [parent=#ViewMgr] closeView
--@param self
--@param #string name 模块名字
function ViewMgr:closeView(name)
    self:showList(name,false)
    if self.openList[name] then
        local win = self.openList[name]
        if win:getParent() then
            win:removeFromParent()
        end
        self.openList[name] = nil
        EventCentrer:dispatchEvent(EventConst.CLOSE_WINDOW, name)
    else
        print("[ViewManager-Warning]:窗口已经关闭")
    end
end

function ViewMgr:showList(name, show)
    for key, var in pairs(self.sortOpenList) do
        if var == name then
            table.remove(self.sortOpenList,key)
            break
        end
    end
    if show then
        self.sortOpenList[#self.sortOpenList+1] = name
    end
end

---------------------------
--获取顶层窗口
function ViewMgr:getTopWin()
    local name = self.sortOpenList[#self.sortOpenList]
    return self.openList[name],name
end

--获取顶层窗口名
function ViewMgr:getTopWinName()
    return self.sortOpenList[#self.sortOpenList]
end

--窗口是否打开
function ViewMgr:isOpen(name)
    return self.openList[name]
end

return ViewMgr