
local Cache = {}

Cache.music_flag = 1
Cache.bestScore = 0
Cache.coin = 0

--武器等级(默认为1级)
Cache.weaponLevel = {1,1,1,1,1,1}
--物品剩余数量(默认数量为1个)
Cache.items = {1,1,1}

function Cache:init()
    ---将公共表中数据初始化到Cache中，若数据中尚未存储该值，则使用默认值
    local data = SaveMgr:getTableData(SaveMgr.COMMON)
    if data then
        for key, var in ipairs(data) do
            self[var.key] = var.value
        end
    end
end

function Cache:getCoin()
    return self.coin
end

function Cache:getBestScore()
    return self.bestScore
end

function Cache:getMusicFlag()
    return self.music_flag
end

--改变金币
--如果不够钱则返回差额
function Cache:changeCoin(value)
    local newCoins = self.coin + value
    if newCoins < 0 then return false,-newCoins end
    self:updateValue("coin",newCoins)
    return true
end

function Cache:setScore(value)
    if value <= self.bestScore then return false end
    self:updateValue("bestScore",value)
    return true,value
end

function Cache:setMusicFlag(value)
    if self.music_flag == value then return end
    self:updateValue("music_flag",value)
    return true
end

--计算分数
function Cache:figureScore(miles,coin,enemies)
    return miles+10*coin+15*enemies
end

-----------------
--更新数据库中的值
--@function [parent=#Cache] updateValue
--@param self
--@param #string key 键名
--@param #object value 键值
function Cache:updateValue(key,value)
    self[key] = value
    SaveMgr:setData(key,value)
end

return Cache