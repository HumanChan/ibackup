
GC = {}

GC.scale = 0.5

GC.scaleBg = 0.67

GC.background_speed = 130

GC.baseHeroY = 75

GC.baseVerticalDis = 28

GC.basehorizontalDis = 40

GC.level = {  --{等级，背景图名字}
    {1,"bgJungle.png"},
    {2,"bgSnow.png"},
    {3,"bgDesert.png"},
    {4,"bgVolcano.png"},
    {5,"bgBase.png"},
}

--//    武器掉落概率
--//    MACHINE_GUN = 30,
--//    SHOT_GUN = 25,
--//    BAZOOKA = 15,
--//    HOMING_ROCKET = 15,
--//    LASER = 15
GC.WEAPON_CREATE_PROBABILITY = {20,20,20,20,20}

GC.WEAPON_CREATE_ID = {1,2,3,4,5}


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
    HAND_GUN = 0.4,
    MACHINE_GUN = 0.45,
    SHOT_GUN = 0.6,
    BAZOOKA = 0.6,
    HOMING_ROCKET = 0.6,
    LASER = 0.6,
}

GC.HERO_BULLET_SPEED = {
    HAND_GUN = 780,
    MACHINE_GUN = 500,
    SHOT_GUN = 700,
    BAZOOKA = 700,
    HOMING_ROCKET = 700,
    LASER = 700,
}