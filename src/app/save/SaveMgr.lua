--[[

-- 假如表COMMON有键：key,value;
-- 两行数据：
-- line1:   copper, 1000
-- line2:   gold, 1000
-- value可以是  number、string、table 不能是函数或class创建的类
--
-- 保存：SaveMgr:setSqlData(SaveMgr.COMMON,"key","copper",{"value"},{1000})
-- 读取：SaveMgr:getSqlData(SaveMgr.COMMON,"key","copper","value") return 1000
-- 删除行：SaveMgr:removeSqlData(SaveMgr.COMMON,"key","copper") 删除这条数据
-- 删除表：SaveMgr:removeSqlData(SaveMgr.COMMON) 删除这个表所有数据
--
-- 读取整个表：SaveMgr:getTableData(SaveMgr.COMMON)
-- return data = { {key="copper",value=1000},{key="gold",data=1000} }
--
-- 读取一行数据：SaveMgr:getLineData(SaveMgr.COMMON,"key","copper")
-- return data = {key="copper",value=1000}
--
-- 公共表common的key值有：
-- gold 金币

]]

--------------------------------
-- @module SaveMgr

local DataBase = require("app.save.DataBase")
local SaveMgr = {}
SaveMgr.COMMON = "common" --公共表，存储简单的key、value

---
--打开sql数据库
--@function [parent=#SaveMgr] openDataBase
--@param self
function SaveMgr:openDataBase()
    DataBase:initDataBase()
end

---
--关闭sql数据库
--@function [parent=#SaveMgr] closeDataBase
--@param self
function SaveMgr:closeDataBase()
    DataBase:closeDataBase()
end

---
--存储数据到公共表中
--@function [parent=#SaveMgr] setData
--@param self
--@param #string key 存到公共表中的key
--@param #object value 存到公共表中的数据
function SaveMgr:setData(key, value)
    SaveMgr:setSqlData(SaveMgr.COMMON,"key",key,{"value"},{value})
end

---
--从公共表中获取数据
--@function [parent=#SaveMgr] getData
--@param self
--@param #string key 存到公共表中的key
--@return object#object 返回存储数据
function SaveMgr:getData(key)
    return SaveMgr:getSqlData(SaveMgr.COMMON,"key",key,"value")
end

---
--保存数据到sql表 table_name
--@function [parent=#SaveMgr] setSqlData
--@param self
--@param #string table_name sql数据表名字
--@param #string key 数据表主键名
--@param #object value 插入或更新主键值为value的数据行
--@param #array keys 需更新键名为keys({key1,key2...})的数据
--@param #array values 键名keys对应的数据values({val1,val2...})
function SaveMgr:setSqlData(table_name,key,value,keys,values)
    local err = DataBase:update(table_name,key,value,keys,values)
    if not err then
        DataBase:createTable(table_name,key)
        DataBase:update(table_name,key,value,keys,values)
    end
end

---
--获取sql中的数据
--@function [parent=#SaveMgr] getSqlData
--@param self
--@param #string table_name sql表名
--@param #string key 主键名
--@param #string value 主键名对应的值
--@param #string key_target 需获取数据对应的key
--@return object#object nil或者value
function SaveMgr:getSqlData(table_name,key,value,key_target)
    return DataBase:getData(table_name,key,value,key_target)
end

---
--获取sql表的所有数据
--@function [parent=#SaveMgr] getTableData
--@param self
--@param #string table_name sql表名
--@return array#array nil或array  data={行1，行2，行3...} --> 每行 = {key1=value1,key2=value2...}
function SaveMgr:getTableData(table_name)
    local data = nil
    if table_name then
        local sql = "select * from " .. table_name
        local names,values = DataBase:do_query(sql)
        if values and #values > 0 then
            data = {}
            for i=1, #values do
                data[i] = {}
                local val = values[i]
                for j=1, #val do
                    data[i][names[j]] = val[j] and json.decode(val[j])
                end
            end
        end
    end
    return data
end

---
--获取sql表一行的所有数据
--@function [parent=#SaveMgr] getLineData
--@param self
--@param #string table_name sql表名
--@param #string key 主键名
--@param #string value 主键名对应的值
--@return table#table nil或table data值为{key1=value1,key2=value2...}
function SaveMgr:getLineData(table_name,key,value)
    local sql = "select * from " .. table_name .. " where " .. key.. " = '" .. value .. "'"
    local names,values = DataBase:do_query(sql)
    local data = nil
    if values and #values > 0 then
        data = {}
        local val = values[1]
        for i=1, #val do
            data[names[i]] = val[i] and json.decode(val[i])
        end
    end

    return data
end

---
--删除sql表table_name中的行
--@function [parent=#SaveMgr] removeSqlData
--@param self
--@param #string table_name
--@param #string key
--@param #object value
function SaveMgr:removeSqlData(table_name,key,value)
    DataBase:removeTable(table_name,key,value)
end

return SaveMgr