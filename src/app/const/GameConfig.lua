
GC = {}

GC.background_speed = 160

GC.baseHeroY = 0.1  --基本高度，占屏幕长度

GC.baseVerticalDis = 50  --基本垂直距离

GC.basehorizontalDis = 54  --基本水平距离

GC.smallHorizontalDis = 45  --移动时水平最小距离

GC.heroWidth = 54
GC.heroCX = 27

GC.heroHeight = 110
GC.heroCY = 55

GC.level = {  --{等级，背景图名字}
    {1,"bgJungle.png"},
    {2,"bgSnow.png"},
    {3,"bgDesert.png"},
    {4,"bgVolcano.png"},
    {5,"bgBase.png"},
}

--//    武器掉落概率
--//    HAND_GUN = 0,
--//    MACHINE_GUN = 20,
--//    SHOT_GUN = 20,
--//    BAZOOKA = 20,
--//    HOMING_ROCKET = 20,
--//    LASER = 20
GC.WEAPON_CREATE_PROBABILITY = {0,20,20,20,20,20}

GC.WEAPON_CREATE_ID = {1,2,3,4,5,6}


GC.WALK_MODE = {
    vertical = 0,
    horizontal = 1,
}

GC.HERO_BULLET_TYPE = {
    HAND_GUN = 0,
    MACHINE_GUN = 1,
    SHOT_GUN = 2,
    BAZOOKA = 3,
    HOMING_ROCKET = 4,
    LASER = 5,
}

GC.HERO_BULLET_INTERVAL = {
    HAND_GUN = 0.5,
    MACHINE_GUN = 0.5,
    SHOT_GUN = 0.6,
    BAZOOKA = 0.6,
    HOMING_ROCKET = 0.6,
    LASER = 0.6,
}

GC.HERO_BULLET_SPEED = {
    HAND_GUN = 750,
    MACHINE_GUN = 750,
    SHOT_GUN = 700,
    BAZOOKA = 700,
    HOMING_ROCKET = 700,
    LASER = 700,
}