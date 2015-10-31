
local EnemyManager = class("EnemyManager",function()
    return {}
end)


function EnemyManager:ctor()
    self.terrainEnemys = {}
end

function EnemyManager:addEnemy(enemy)
    table.insert(self.terrainEnemys,enemy)
end

function EnemyManager:clearAll()
    for i=1,#self.terrainEnemys do
        if self.terrainEnemys[i].isActive then
            self.terrainEnemys[i]:dispose()
        end
    end
end

function EnemyManager:enterFrame(delta)
    for i=1,#self.terrainEnemys do
        local enemy = self.terrainEnemys[i]
        if enemy and enemy.isActive then
            local p = enemy:convertToWorldSpace(cc.p(0,0))
            if p.y < -10 then
                table.remove(self.terrainEnemys,i)
                i = i - 1
                enemy:dispose()
            elseif p.y < display.height + 50 then
                enemy:enterFrame(delta)
            end
        end
    end
end



return EnemyManager