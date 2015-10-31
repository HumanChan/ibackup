
local CollisionManager = class("CollisionManager",function()
    return {}
end)

function CollisionManager:ctor()
    self.updateFlag = 1
end

function CollisionManager:detectHerosCollision(delta)
    local terrainEnemys = m_GameLayer.enemyManager.terrainEnemys
    local terrainItems = m_GameLayer.itemManager.terrainItems
    local screenItems = m_GameLayer.itemManager.screenItems
    local heros = m_GameLayer.heros

    for i=1,#heros do
        if heros[i].isActive then
            local px = heros[i]:getPositionX()
            local py = heros[i]:getPositionY()
            for j=1,#terrainItems do
                if terrainItems[j].isActive then
                    local box = terrainItems[j]:getBox()
                    local e = terrainItems[j]:convertToWorldSpace(cc.p(0,0))
                    box.x = e.x-box.width*0.5
                    box.y = e.y-box.height*0.5
                    if cc.rectContainsPoint(box,cc.p(px,py)) then
                        local type = terrainItems[j]:getType()
                        if type == CONSTANT.ITEM_TYPE.BOX then
                            terrainItems[j]:open()
                        elseif type == CONSTANT.ITEM_TYPE.CAGE then
                            m_GameLayer:addHero(e.x,e.y)
                            terrainItems[j]:dispose()
                        end
                    end
                end
            end
            for h=1,#screenItems do
                if screenItems[h].isActive then
                    local box = screenItems[h]:getBox()
                    local e = screenItems[h]:convertToWorldSpace(cc.p(0,0))
                    box.x = e.x-box.width*0.5
                    box.y = e.y-box.height*0.5
                    if cc.rectContainsPoint(box,cc.p(px,py)) then
                        local info = screenItems[h]:getInfo()
                        heros[i]:changeWeapon(info)
                        screenItems[h]:dispose()
                    end
                end
            end
            for k=1,#terrainEnemys do
                if terrainEnemys[k].isActive then
                    local def = terrainEnemys[k].def
                    local e = terrainEnemys[k]:convertToWorldSpace(cc.p(0,0))
                    local box = terrainEnemys[k]:getBox()
                    box.x = e.x-box.width*0.5
                    box.y = e.y-box.height*0.5
                    if cc.rectContainsPoint(box,cc.p(px,py)) and heros[i].isActive then
                        heros[i]:dispose()
                    end
                end
            end
        end
    end
end


function CollisionManager:detectHeroBulletCollision(delta)
    local heroBullets = m_GameLayer.heroBullets
    local terrainEnemys = m_GameLayer.enemyManager.terrainEnemys
    local terrainItems = m_GameLayer.itemManager.terrainItems
    for i=1,#heroBullets do
        local b = heroBullets[i]
        if b.isActive then
            local power = b.power
            local bx,by = b:getPosition()
            for j=1,#terrainEnemys do
                if terrainEnemys[j].isActive then
                    local def = terrainEnemys[j].def
                    local e = terrainEnemys[j]:convertToWorldSpace(cc.p(0,0))
                    local box = terrainEnemys[j]:getBox()
                    box.x = e.x-box.width*0.5
                    box.y = e.y-box.height*0.5
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
                    local box = terrainItems[k]:getBox()
                    box.x = e.x-box.width*0.5
                    box.y = e.y-box.height*0.5
                    if cc.rectContainsPoint(box,cc.p(bx,by)) then
                        local type = terrainItems[k]:getType()
                        if type == CONSTANT.ITEM_TYPE.BOX then
                            terrainItems[k]:open()
                        elseif type == CONSTANT.ITEM_TYPE.CAGE then
                            m_GameLayer:addHero(e.x,e.y)
                            terrainItems[k]:dispose()
                        end
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
                    local box = heros[j]:getBox()
                    box.x = e.x-box.width*0.5
                    box.y = e.y-box.height*0.5
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

function CollisionManager:enterFrame(Delta)
    local delta = 3 * Delta
    if self.updateFlag == 1 then
        self:detectHerosCollision(delta)
    elseif self.updateFlag == 2 then
        self:detectHeroBulletCollision(delta)
    elseif self.updateFlag == 3 then
        self:detectEnemyBulletCollision(delta)
    end
    self.updateFlag = self.updateFlag + 1
    if self.updateFlag > 3 then self.updateFlag = 1 end
end



return CollisionManager









