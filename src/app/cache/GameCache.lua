
local GameCache = {}

GameCache.pause = false
GameCache.over = false

GameCache.heros = {  --英雄列表 {武器ID}
    {CONSTANT.WEAPON_ID.HAND_GUN},
}

GameCache.mode = 0  --英雄队形，0为打横，1为打竖
GameCache.miles = 0  --路程
GameCache.enemies = 0  --杀死敌人数目
GameCache.coins = 0  --获取的金币

function GameCache:init()
    self.pause = false
    self.over = false
    self.level = 1
    self.heros = {
        {CONSTANT.WEAPON_ID.HAND_GUN},
    }
    self.mode = 0
    GameCache.miles = 0
    GameCache.enemies = 0
    GameCache.coins = 0
end


return GameCache