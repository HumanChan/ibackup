--[[--

游戏工具集

]]

local GameUtils = {}

function GameUtils.getFightConfig(id)
    id = checkint(id)
    local newName
    if id == 39001 then
        newName = "config.EndlessConfig"
    elseif id == 39999 then
        newName = "config.EjectionConfig"
        local info = require(newName)[id .. ""]
        local index = math.random(1, #info)
        return info[index]
    else
    	local index = math.ceil((id-30000)/50)
    	newName = "config.FightConfig" .. index
    end
    return require(newName)[id .. ""]
end

GameUtils.JsonCache = {}
--[[--
获取json文件数据
@param name json文件名<默认存放在res/config目录下>
]]
function GameUtils.getJsonData(name)
    if GameUtils.JsonCache[name] == nil then
        local jsonData = cc.FileUtils:getInstance():getStringFromFile("config/" .. name .. ".json")
        if jsonData and jsonData ~= "" then
            GameUtils.JsonCache[name] = json.decode(jsonData)
        end
    end
    return GameUtils.JsonCache[name]
end

--[[--
获取字符串
@param id 字符串id
]]
function GameUtils.getWords(id)
--     local language = cc.Application:getInstance():getCurrentLanguage()
--     if language == cc.LANGUAGE_CHINESE then
--     
--     end
    return require("app.const.WordsConst")[id]
end

--[[--

]]
function GameUtils.getRate(data)
    --math.newrandomseed()
    return math.random(1,100) <= data*100
end

--[[--
在一定范围内获取指定个数的不同随机数
@param min   范围最小值
@param max   范围最大值
@param num   获取随机数的个数   
@param rule  排除的rule列表
]] 
function GameUtils:getRandom(min, max, num, rule) 
    local list = {}
    for var=min, max do
        table.insert(list, var)
    end 
    for var=1, #list do
        local tmp1 = math.random(min, max)
        local tmp2 = list[var] 
        list[var] = list[tmp1] 
        list[tmp1]=tmp2; 
    end 

    if num and num > 1 then
        local newList = {}
        if type(rule) == "table" then
            local isSame
            for key, var in pairs(list) do
                isSame = false
                for k, v in pairs(rule) do
            		if var == v then
            			isSame = true
            			break
            		end
            	end
                if isSame == false then
                    if #newList < num then
                    	table.insert(newList, var)
                    else
                        break
                    end
                end 
            end
        else
            for var=1, num do
                table.insert(newList, list[var])
            end
        end
        return newList
    else
        return {list[1]}
    end
end

--[[--
获取两点之间的夹角角度
@param x1 
@param y1
@param x2
@param y2
]]
function GameUtils.getAngle(x1,y1,x2,y2)
    return -math.atan2((y2 - y1),(x2 - x1)) * 180 / math.pi
    --return math.deg(cc.pGetAngle(cc.p(x1,y1),cc.p(x2,y2)))
end

--查找敏感字符
--@敏感字符会被替换为**
--@敏感字符库在KeywordFilter.lua中
function GameUtils.KeyWorldFilter(str)
    local KeyWordConst = require("app.const.KeyWordConst")
    local function getMatchKeyWord(str1,str2)
        local isFind = string.find(str2,str1)
        return isFind
    end

    local function replaceString(key,str)
        local replaceStr = "**"
        local isFind = getMatchKeyWord(key,str)
        if isFind then
            str = string.gsub(str,key,replaceStr)
        end
        return str
    end

    local function getMatchKeyTerm(str1,str2)
        local sign = "|"
        local signLen = string.len(sign)
        local tempStr = str1
        local startIndex = 1
        local EndIndex = 1
        while startIndex do
            startIndex,EndIndex = string.find(tempStr,sign)
            if startIndex~=nil and EndIndex~=nil then
                local key = string.sub(tempStr,1,EndIndex-signLen)
                str2 = replaceString(key,str2)

                local strlen = string.len(tempStr)
                local newStr =  string.sub(tempStr,EndIndex+signLen,strlen)
                tempStr = newStr
                local dfdf = 0
            else
                str2 = replaceString(tempStr,str2)
            end
        end
        return  str2
    end

    local bIsChange = false
    for i,v in pairs(KeyWordConst) do
        --比较KeyWord
        local keyWord = v.keyWord
        if getMatchKeyWord(keyWord,str)~=nil then
            --keyTerm
            local keyTerm = v.keyTerm
            str,bIsChange = getMatchKeyTerm(keyTerm,str)
        end
    end
    return str,bIsChange
end

local time1
function GameUtils.testTime()
    local socket = require "socket"
    if time1 == nil then
        time1 = socket.gettime()
        print("开始时间：",time1)
        return time1
    end
    local time2 = socket.gettime()
    print("结束时间：",time2)
    print("时间差: ",time2 - time1)
    time1 = nil
end

--获取类型
function GameUtils.getItemType(id)
    if id then
        local cid = id .. ""
        return cid:sub(1,1)
    else
        return 0
    end
end

--显示时分秒00:00:00
function GameUtils.getTimeFormat(time)
    local str = ""
    local function addTime(n)
        local ss = ""
        if n >= 10 then
            ss = ss..n
        elseif n > 0 then
            ss = ss.."0"..n
        else
            ss = ss.."00"
        end
        return ss
    end
    local num = math.floor(time/3600)
    str = str..addTime(num)..":"
    num = math.floor((time%3600)/60)
    str = str..addTime(num)..":"
    num = (time%3600)%60
    str = str..addTime(num)
    return str
end

--显示时分秒00:00
function GameUtils.getTimeFormat2(time)
    local str = ""
    local function addTime(n)
        local ss = ""
        if n >= 10 then
            ss = ss..n
        elseif n > 0 then
            ss = ss.."0"..n
        else
            ss = ss.."00"
        end
        return ss
    end
    local num = math.floor((time%3600)/60)
    str = str..addTime(num)..":"
    num = (time%3600)%60
    str = str..addTime(num)
    return str
end

-- 参数:待分割的字符串,分割字符
-- 返回:子串表.(含有空串)
function GameUtils.lua_string_split(str, split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end

    return sub_str_tab;
end


--创建背景
function GameUtils:createFullScreenBg(fileName,target)
    local spriteBg = display.newSprite(fileName)
        :addTo(target)
        :align(display.CENTER)
        :pos(display.cx,display.cy)  
    target.layerBg = spriteBg
    spriteBg:setScaleX(display.width/640)
    spriteBg:setScaleY(display.height/960) 
    return spriteBg
end

return GameUtils