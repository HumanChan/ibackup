
local CollisionManager = class("CollisionManager",function()
    return {}
end)


function CollisionManager:ctor()
end

function CollisionManager:detectItemCollision(delta)
    local terrainItems = m_GameLayer.itemManager.terrainItems

    local heros = m_GameLayer.heros
    for i=1,#heros do
        if heros[i].isActive then
            local px = heros[i]:getPositionX()
            local py = heros[i]:getPositionY()
            if heros[i].isActive then
                for j=1,#terrainItems do
                    local box = terrainItems[j]:getBoundingBox()
                    local e = terrainItems[j]:convertToWorldSpace(cc.p(0,0))
                    box.x = e.x
                    box.y = e.y
                    if cc.rectContainsPoint(box,cc.p(px,py)) then
                        terrainItems[j]:open()
                    end
                end
            end
        end
    end
end

function CollisionManager:detectHeroBulletCollision(delta)
    local heroBullets = m_GameLayer.heroBullets
    for i=1,#heroBullets do
        local b = heroBullets[i]
        if b.isActive then
            local power = b.power
            local bx,by = b:getPosition()
            local terrainEnemys = m_GameLayer.enemyManager.terrainEnemys
            local terrainItems = m_GameLayer.itemManager.terrainItems
            for j=1,#terrainEnemys do
                if terrainEnemys[j].isActive then
                    local def = terrainEnemys[j].def
                    local e = terrainEnemys[j]:convertToWorldSpace(cc.p(0,0))
                    local box = terrainEnemys[j].facade:getBoundingBox()
                    box.x = e.x
                    box.y = e.y
                    if power >= def then
                        if cc.rectContainsPoint(box,cc.p(bx,by)) then
                            terrainEnemys[j]:dispose()
                        end
                    end
                end
            end
            for k=1,#terrainItems do
                if terrainItems[k].isActive then
                    local e = terrainItems[k]:convertToWorldSpace(cc.p(0,0))
                    local box = terrainItems[k]:getBoundingBox()
                    box.x = e.x
                    box.y = e.y
                    if cc.rectContainsPoint(box,cc.p(bx,by)) then
                        terrainItems[k]:open()
                    end
                end
            end
        end
    end
end

function CollisionManager:detectEnemyBulletCollision(delta)
    local enemyBullets = m_GameLayer.enemyBullets
    local heros = m_GameLayer.heros
    for i=1,#enemyBullets do
        local b = enemyBullets[i]
        if b.isActive then
            local power = b.power
            local bx,by = b:getPosition()
            for j=1,#heros do
                if heros[j].isActive then
                    local def = heros[j].def
                    local e = heros[j]:convertToWorldSpace(cc.p(0,0))
                    local box = heros[j].facade:getBoundingBox()
                    box.x = e.x
                    box.y = e.y
                    if power >= def then
                        if cc.rectContainsPoint(box,cc.p(bx,by)) then
                            heros[j]:dispose()
                        end
                    end
                end
            end
        end
    end
end

function CollisionManager:enterFrame(delta)
    self:detectItemCollision(delta)
    self:detectHeroBulletCollision(delta)
    self:detectEnemyBulletCollision(delta)
end



return CollisionManager









