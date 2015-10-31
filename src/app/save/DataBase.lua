--[[

数据库

]]

--------------------------------
-- @module DataBase
local sqlite3 = require("lsqlite3")

local DataBase = {}

-- 打开数据库
function DataBase:initDataBase(id)
    local url = cc.FileUtils:getInstance():getWritablePath()
    self.db = sqlite3.open(url.."database.db")
    if not self.db then
        print("打开数据库失败")
        return
    end
    print("打开数据库成功",url.."database.db")
    -- self.db:exec('VACUUM')
end

-- 关闭数据库并删除数据库日志
function DataBase:closeDataBase()
    if self.db then
        self.db:exec('VACUUM') --清除数据库日志
        self.db:close()
        self.db = nil
        print("关闭数据库成功")
    end
end

-- 删除数据库
function DataBase:removeDataBase()
--os.remove('res/database.db')
end

-- 创建表名（tn）及 主键名字
function DataBase:createTable(tn, primary_key)
    if not self.db then
        return false
    end
    local str = tn.."("..primary_key.." primary key)"
    local code = self.db:exec("CREATE TABLE "..str)
    if code == sqlite3.OK then
        print("创建成功 表：",tn)
        return true
    end
    return false
end

-- 清除表(某些行)
function DataBase:removeTable(tn,key,value)
    if not self.db then
        return
    end
    if key and value then
        self.db:exec("delete from "..tn.." where "..key.."='"..value.."'")
    else
        self.db:exec("delete from "..tn)
    end
end

-- 更新表(包括插入行，插入列，更新数据)
-- select * from tn where key = value
-- insert into tn(key1,key2,...) values(value1,value2,...)
-- keys(key1,key2...) values(value1,value2..)
-- create table t as select * from package
function DataBase:update(tn,key,value,keys,values)
    local str_value = value
    if type(value) == "string" then
    	str_value = "\"" .. value .. "\""
    end
    local names,query = self:do_query("select * from "..tn.." where "..key.."='"..str_value.."'")
    if not names then
        print("------------数据库更新失败")
        return
    end
    if #query <= 0 then
        self:insertKey(tn, key, value)
    end
    local cols = {}
    for i=1,#keys do
        local index = table.indexof(names,keys[i])
        if not index then
            table.insert(cols,keys[i])
        end
    end
    if #cols > 0 then
        self:alterCols(tn,cols)
    end

    return self:updateTable(tn, key, value, keys, values)
end

-- 返回values值可能为: nil 或者 value
-- key为主键   key_target为要查找的内容
function DataBase:getData(tn,key,value,key_target)
    local str_value = value
    if type(value) == "string" then
        str_value = "\"" .. value .. "\""
    end
    local sql = "select "..key_target.." from "..tn.." where "..key.."='"..str_value.."'"
    local names,values = self:do_query(sql)
    local rv = nil
    if values and #values > 0 then
        if type(values[1]) == "table" and #values[1] > 0 then
            rv = values[1][1] and json.decode(values[1][1])
        end
    end
    return rv
end

-- 添加多列
-- 表名：tn，列名：colnames = {col1,col2...}
function DataBase:alterCols(tn,colnames)
    self.db:exec('begin')
    for i=1,#colnames do
        local colname = colnames[i]
        self.db:exec("alter table "..tn.." add "..colname)
    end
    self.db:exec('commit')
end

-- 插入一行数据 主键key = value,其他为nil
-- 将value转为json文件格式字符串存储
function DataBase:insertKey(tn,key,value)
    local str_value = json.encode(value)
    return self.db:exec("insert into "..tn.." ("..key..") " .. "values('"..str_value.."')")
end

-- 更新表
function DataBase:updateTable(tn,key,value,keys,values)
    local errorCode = sqlite3.OK
    local k,v
    self.db:exec('begin')
    for i=1,#keys do
        k,v = keys[i], json.encode(values[i])
        v = v or ""
        -- print("K___V:",k,v,keys[i],values[i])
        local str_value = value
        if type(value) == "string" then
            str_value = "\"" .. value .. "\""
        end
        local sql = "update "..tn.." set "..k.."= '"..v.."' where "..key.."='"..str_value.."'"
        local err = self.db:exec(sql)
        if err ~= sqlite3.OK then
            errorCode = err
            print("数据库更新失败 error:"..sql)
        end
    end
    self.db:exec('commit')
    return errorCode
end

-- 查询队列
-- 返回 names,values,error-codes
-- values值为 {{v1,v2,...}, {}, ...}
-- sql:SQL语句
function DataBase:do_query(sql)
    if not self.db then
        return
    end
    local vm = self.db:prepare(sql)
    if not vm then
        return nil,nil,self.db:errmsg()
    end
    local names = vm:get_names()
    local r = vm:step()
    local values = {}
    while r == sqlite3.ROW do
        local temp_value = vm:get_values() --table:{value1,value2}
        values[#values+1] = temp_value
        r = vm:step()
    end
    vm:finalize()
    return names,values,r
end

return DataBase