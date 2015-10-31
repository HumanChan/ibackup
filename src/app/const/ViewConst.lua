local ViewConst = {}

---场景部分
ViewConst.MAINSCENE = "1001"

ViewConst.scene = {
    --主场景
    ["1001"] = {
        ["path"] = "app.scenes.MainScene",
    },
}

---模块部分
ViewConst.TEST = "2000"
ViewConst.MainMenu = "2001" --主菜单
ViewConst.ItemView = "2002" --物品购买界面
ViewConst.WeaponView = "2003" --武器升级界面
ViewConst.SettingView = "2004" --设置界面
ViewConst.PauseView = "2005" --暂停界面

ViewConst.win = {
    ["2000"] = {
        ["path"] = "",
    },
    ["2001"] = {
        ["path"] = "app.module.menu.MenuView"
    },
    ["2002"] = {
        ["path"] = "app.module.menu.ItemView"
    },
    ["2003"] = {
        ["path"] = "app.module.menu.WeaponView"
    },
    ["2004"] = {
        ["path"] = "app.module.menu.SettingView"
    },
    ["2005"] = {
        ["path"] = "app.module.fight.PauseView"
    },
}


return ViewConst
