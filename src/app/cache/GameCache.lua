
local GameCahce = {}

GameCahce.pause = false

GameCahce.over = false

GameCahce.level = 1

GameCahce.heros = {  --英雄列表 {武器ID}
    {CONSTANT.WEAPON_ID.HAND_GUN},
}

GameCahce.mode = 0  --英雄队形，0为打横，1为打竖


function GameCahce:clear()
    self.pause = false
    self.over = false
    self.level = 1
    self.heros = {
        {CONSTANT.WEAPON_ID.HAND_GUN},
    }
    self.mode = 0
end



return GameCahce