#Requires AutoHotkey v2.0

F3::Pause -1
F4::Reload

global WinTitle := "ahk_exe The Slormancer.exe"
global Path := "slormancer_img\"
global Extension := ".png"
global Challenges := [
    {name:"ace_combat",weight:0},
    {name:"assassins",weight:120},
    {name:"assimilation",weight:110},
    {name:"attrition_battle",weight:200},	;waves +2
    {name:"avenger",weight:60},
    {name:"cursed_reward",weight:50},
	{name:"curse",weight:50},
    {name:"double_down",weight:120},
    {name:"endless_fire",weight:40},
    {name:"equilibrium",weight:120},
    {name:"evolving_wizards",weight:120},
    {name:"explosive",weight:50},
    {name:"fire_rage",weight:50},
    {name:"fire_strike",weight:120},
    {name:"floor_is_lava",weight:40},
    {name:"flow_interruption",weight:120},
    {name:"frenzy",weight:120},
    {name:"fury_of_the_storm",weight:120},
    {name:"gargantuan",weight:8},
    {name:"gravity",weight:120},
    {name:"greater_speed",weight:0},
    {name:"greater_strength",weight:0},
    {name:"greater_vitality",weight:0},
    {name:"hermetic",weight:120},
    {name:"highlander",weight:0},
    {name:"ice_bombs",weight:90},
    {name:"ice_ray",weight:80},
    {name:"ice_strike",weight:120},
    {name:"invulnerability",weight:50},
    {name:"iron_health",weight:120},
    {name:"light_beam",weight:100},
    {name:"light_strike",weight:100},
    {name:"light_totem",weight:100},
    {name:"lightning_strike",weight:120},
    {name:"multiplication",weight:120},
    {name:"neverending_speed",weight:0},
    {name:"neverending_strength",weight:0},
    {name:"neverending_vitality",weight:0},
    {name:"nullifying_shield",weight:70},
    {name:"obelisk_annihilation",weight:20},
    {name:"obelisk_destruction",weight:20},
    {name:"obelisk_illusion",weight:20},
    {name:"obelisk_revocation",weight:20},
    {name:"obelisk_transmutation",weight:20},
    {name:"overcrowding",weight:100},
    {name:"proliferation",weight:120},
    {name:"reconstruction",weight:100},
    {name:"regeneration",weight:80},
    {name:"relentless_lightning",weight:120},
    {name:"rest",weight:10},
    {name:"seal_of_blindness",weight:120},
    {name:"shadow_benediction",weight:20},
    {name:"shadow_clone",weight:10},
    {name:"shadow_curse",weight:40},
    {name:"shadow_strike",weight:100},
    {name:"side_storm",weight:120},
    {name:"siege_alacrity",weight:130},
	{name:"siege_barrage",weight:130},
    {name:"siege_brutality",weight:130},
    {name:"siege_dominance",weight:130},
    {name:"siege_escort",weight:130},
    {name:"siege_quiver",weight:130},
    {name:"siege_reinforcements",weight:130},
    {name:"slippery_ice",weight:120},
    {name:"start_let_them_come",weight:10},
    {name:"start_open_the_gates",weight:0},
    {name:"start_set_up_the_barricades",weight:0},
    {name:"tenacious",weight:120},
    {name:"to_each_his_own",weight:120},
    {name:"upgrade_epic",weight:300},
    {name:"upgrade_legendary",weight:350},
    {name:"upgrade_magic",weight:90},
    {name:"upgrade_rare",weight:200},
    {name:"wild_beasts",weight:120}
]
global Rewards := [
    {name:"reward_adrianne",weight:10},
    {name:"reward_astorias",weight:10},
    {name:"reward_beigarth",weight:10},
    {name:"reward_chest_effect",weight:30},
    {name:"reward_chest_effect2",weight:70},
    {name:"reward_chest_quality",weight:60},
	{name:"reward_chest_quality_effect",weight:70},
	{name:"reward_chest_quality45",weight:60},
    {name:"reward_chest_quantity",weight:60},
    {name:"reward_cory",weight:10},
    {name:"reward_equipment",weight:30},
	{name:"reward_equipment_quality",weight:30},
    {name:"reward_fragment",weight:30},
    {name:"reward_fulgurorn",weight:10},
    {name:"reward_goldus",weight:60},
    {name:"reward_goldus_effect",weight:150},
    {name:"reward_hagan",weight:10},
	{name:"reward_obelisk",weight:10},
    {name:"reward_reaper_effect",weight:10},
    {name:"reward_slorm",weight:20},
	{name:"reward_slorm_effect",weight:80},
    {name:"reward_slormite",weight:40},
    {name:"reward_slormline",weight:40},
	{name:"reward_slormline2",weight:40},
    {name:"reward_smaloron",weight:10}
]
global Duration := [
	{name:"duration3",weight:10},
	{name:"duration4",weight:20},
	{name:"duration5",weight:30},
	{name:"duration6",weight:40},
	{name:"duration7",weight:50}
]

If WinExist(WinTitle) {
    WinActivate
    Loop {
        If WinExist(WinTitle) {
                WinActivate
        }
        try {
			if ((ImageSearch(&FoundX, &FoundY, 3210, 545, 3310, 645, "*25 slormancer_img\autostart.png"))) {
                If WinExist(WinTitle) {
                    WinActivate
                    MouseMove 3265,600
                    Click "down"
                    Sleep 10
                    Click "up"
					Sleep 10
					MouseMove 3575,600
					Click "down"
                    Sleep 10
                    Click "up"
                } 
            }
            if ((ImageSearch(&FoundX, &FoundY, 3315, 540, 3830, 660, "slormancer_img\next_wave.png"))) {
                If WinExist(WinTitle) {
                    WinActivate
                    MouseMove 3560,600
                    Click "down"
                    Sleep 10
                    Click "up"
                } 
            }
            if (!(ImageSearch(&FoundX, &FoundY, 3190, 0, 3300, 145, "slormancer_img\forge_icon.png"))) {
                Sleep 1000
                foundImages := ""
                leftWeight := -1000
                middleWeight := -1000
                rightWeight := -1000
                If WinExist(WinTitle) {
                    WinActivate
                    MouseMove 350,150
                    Click "down"
                    Sleep 10
                    Click "up"
                }
                for index, value in Challenges {
                    imagePath := Path value.name Extension
                    if (ImageSearch(&FoundX1, &FoundY1, 1100, 780, 1270, 970, imagePath)) {
                        leftWeight := value.weight
                        foundImages := "1. " value.name " | " value.weight
                        ToolTip foundImages, 70, 70
                        SetTimer () => ToolTip(), -30000
                        break
                    }
                }
                for index, value in Rewards {
                    imagePath := Path value.name Extension
                    if (ImageSearch(&FoundX1, &FoundY1, 1110, 1380, 1270, 1500, imagePath)) {
                        leftWeight := leftWeight + value.weight
                        foundImages := foundImages "`n    +" value.name " | " value.weight
                        ToolTip foundImages, 70, 70
                        SetTimer () => ToolTip(), -30000
                        break
                    }
                }
				for index, value in Duration {
                    imagePath := Path value.name Extension
                    if (ImageSearch(&FoundX1, &FoundY1, 1050, 1270, 1315, 1320, imagePath)) {
                        leftWeight := leftWeight + value.weight
                        foundImages := foundImages "`n    +" value.name " | " value.weight
                        ToolTip foundImages, 70, 70
                        SetTimer () => ToolTip(), -30000
                        break
                    }
                }
                If WinExist(WinTitle) {
                    WinActivate
                    MouseMove 350,150
                    Click "down"
                    Sleep 10
                    Click "up"
                }
                for index, value in Challenges {
                    imagePath := Path value.name Extension
                    if (ImageSearch(&FoundX1, &FoundY1, 1840, 780, 2000, 970, imagePath)) {
                        middleWeight := value.weight
                        foundImages := foundImages "`n2. " value.name " | " value.weight
                        ToolTip foundImages, 70, 70
                        SetTimer () => ToolTip(), -30000
                        break
                    }
                }
                for index, value in Rewards {
                    imagePath := Path value.name Extension
                    if (ImageSearch(&FoundX1, &FoundY1, 1840, 1380, 2000, 1500, imagePath)) {
                        middleWeight := middleWeight + value.weight
                        foundImages := foundImages "`n    +" value.name " | " value.weight
                        ToolTip foundImages, 70, 70
                        SetTimer () => ToolTip(), -30000
                        break
                    }
                }
				for index, value in Duration {
                    imagePath := Path value.name Extension
                    if (ImageSearch(&FoundX1, &FoundY1, 1790, 1270, 2060, 1325, imagePath)) {
                        middleWeight := middleWeight + value.weight
                        foundImages := foundImages "`n    +" value.name " | " value.weight
                        ToolTip foundImages, 70, 70
                        SetTimer () => ToolTip(), -30000
                        break
                    }
                }
                If WinExist(WinTitle) {
                    WinActivate
                    MouseMove 350,150
                    Click "down"
                    Sleep 10
                    Click "up"
                }
                for index, value in Challenges {
                    imagePath := Path value.name Extension
                    if (ImageSearch(&FoundX1, &FoundY1, 2570, 780, 2750, 970, imagePath)) {
                        rightWeight := value.weight
                        foundImages := foundImages "`n3. " value.name " | " value.weight
                        ToolTip foundImages, 70, 70
                        SetTimer () => ToolTip(), -30000
                        break
                    }
                }
                for index, value in Rewards {
                    imagePath := Path value.name Extension
                    if (ImageSearch(&FoundX1, &FoundY1, 2570, 1380, 2750, 1500, imagePath)) {
                        rightWeight := rightWeight + value.weight
                        foundImages := foundImages "`n    +" value.name " | " value.weight
                        ToolTip foundImages, 70, 70
                        SetTimer () => ToolTip(), -30000
                        break
                    }
                }
				for index, value in Duration {
                    imagePath := Path value.name Extension
                    if (ImageSearch(&FoundX1, &FoundY1, 2520, 1270, 2790, 1325, imagePath)) {
                        rightWeight := rightWeight + value.weight
                        foundImages := foundImages "`n    +" value.name " | " value.weight
                        ToolTip foundImages, 70, 70
                        SetTimer () => ToolTip(), -30000
                        break
                    }
                }
				If WinExist(WinTitle) {
                    WinActivate
                    MouseMove 350,150
                    Click "down"
                    Sleep 10
                    Click "up"
                }
                if (leftWeight > -1000 || middleWeight > -1000 || rightWeight > -1000) {
                    SendMode "Input"
                    if ((leftWeight > middleWeight && leftWeight > rightWeight) || (leftWeight == middleWeight && leftWeight == rightWeight) || (leftWeight > middleWeight && leftWeight == rightWeight) || (leftWeight == middleWeight && leftWeight > rightWeight)) {
                        If WinExist(WinTitle) {
                            WinActivate
                            MouseMove 1180,1200
                            Click "down"
                            Sleep 10
                            Click "up"
							ToolTip foundImages "`n`nPicked 1. | " leftWeight, 70, 70
							SetTimer () => ToolTip(), -30000
                        }
                    }
                    if ((middleWeight > leftWeight && middleWeight > rightWeight) || (middleWeight > leftWeight && middleWeight == rightWeight) || (middleWeight == leftWeight && middleWeight > rightWeight)) {
                        If WinExist(WinTitle) {
                            WinActivate
                            MouseMove 1920,1200
                            Click "down"
                            Sleep 10
                            Click "up"
							ToolTip foundImages "`n`nPicked 2. | " middleWeight, 70, 70
							SetTimer () => ToolTip(), -30000
                        }
                    }
                    if ((rightWeight > leftWeight && rightWeight > middleWeight) || (rightWeight > leftWeight && rightWeight == middleWeight) || (rightWeight == leftWeight && rightWeight > middleWeight)) {
                        If WinExist(WinTitle) {
                            WinActivate
                            MouseMove 2650,1200
                            Click "down"
                            Sleep 10
                            Click "up"
							ToolTip foundImages "`n`nPicked 3. | " rightWeight, 70, 70
							SetTimer () => ToolTip(), -30000
                        }
                    }
                } else {
                    ToolTip "Images not found", 70, 70
                    SetTimer () => ToolTip(), -5000
                }
                Sleep 100
            }
        }
        catch as exc {
            MsgBox "Could not conduct the search due to the following error:`n" exc.Message
            Break
        }
    }

}
