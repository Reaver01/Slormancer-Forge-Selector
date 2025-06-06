#Requires AutoHotkey v2.0

; GLOBAL VARIABLES
global Resolution4k := false
global Mode := "auto" ; "manual" = hit F1 to calculate weights; "auto" = loop and check automatically.
global SelectOptions := true ; true/false if false then options won't be clicked, but weight will still be calculated and displayed.
global ControllerInput := true ; Will turn on clicking on top right corner to get rid of controller circle if true.
global WinTitle := "ahk_exe The Slormancer.exe"
global Path := "slormancer_img\"
global Extension := ".png"
global NextWaveImg := "slormancer_img\next_wave.png"
global AutoStartImg := "*25 slormancer_img\autostart.png"
global ForgeIconImg := "slormancer_img\forge_icon.png"
global TopLeftClickPos := [200, 200]
global AutoStartBox := [1640, 300]
global AutoStartBounds := [1590, 260, 1650, 360]
global NextWaveButton := [1790, 300]
global NextWaveBounds := [1650, 260, 1920, 360]
global ForgeIconBounds := [1500, 0, 1700, 200]
global LeftChallengeBounds := [450, 300, 750, 600]
global LeftRewardBounds := [450, 650, 750, 800]
global LeftDurationBounds := [450, 620, 750, 700]
global MiddleChallengeBounds := [850, 300, 1150, 600]
global MiddleRewardBounds := [850, 650, 1150, 800]
global MiddleDurationBounds := [850, 620, 1150, 700]
global RightChallengeBounds := [1200, 300, 1500, 600]
global RightRewardBounds := [1200, 650, 1500, 800]
global RightDurationBounds := [1200, 620, 1500, 700]
global ToolTipTimeout := -30000
global ToolTipPos := [5, 5]
if (Resolution4k == true) {
    Extension := "_4k.png"
    NextWaveImg := "slormancer_img\next_wave_4k.png"
    AutoStartImg := "*25 slormancer_img\autostart_4k.png"
    ForgeIconImg := "slormancer_img\forge_icon_4k.png"
    TopLeftClickPos := [350, 350]
    AutoStartBox := [3265, 600]
    AutoStartBounds := [3210, 545, 3310, 645]
    NextWaveButton := [3560, 600]
    NextWaveBounds := [3315, 540, 3830, 660]
    ForgeIconBounds := [3190, 0, 3300, 145]
    LeftChallengeBounds := [1100, 780, 1270, 970]
    LeftRewardBounds := [1110, 1380, 1270, 1500]
    LeftDurationBounds := [1050, 1270, 1315, 1320]
    MiddleChallengeBounds := [1840, 780, 2000, 970]
    MiddleRewardBounds := [1840, 1380, 2000, 1500]
    MiddleDurationBounds := [1790, 1270, 2060, 1325]
    RightChallengeBounds := [2570, 780, 2750, 970]
    RightRewardBounds := [2570, 1380, 2750, 1500]
    RightDurationBounds := [2520, 1270, 2790, 1325]
    ToolTipPos := [70, 70]
}
global CursedChestWeight := 200 ; Allows attack speed curse buff to show
global Challenges := [
    {name:"ace_combat", weight:0}, ; The following Wave has x additional Elite enemies.
    {name:"assassins", weight:100}, ; Enemies have +x Evasion and +x Critical Strike Chance.
    {name:"assimilation", weight:100}, ; Enemies receive x Decreased Damage for each yard between you and them.
    {name:"attrition_battle", weight:200}, ; The Duration of all upcoming Challenges is increased by x Waves.
    {name:"avenger", weight:60}, ; Enemies gain +x increased Damage whenever another enemy dies within a x yard radius.
    {name:"curse", weight:0}, ; This depends on the cursed reward option. Script is set to only allow Attack Speed increase.
    {name:"cursed_reward", weight:-100}, ; Adds a random Curse that will affect an upcoming Challenge.
    {name:"double_down", weight:100}, ; Enemies have +x Recast Chance.
    {name:"endless_fire", weight:80}, ; A slow yet massive Fireball is constantly following you, dealing x Fire Damage to Heroes and Minions hit.
    {name:"equilibrium", weight:100}, ; Damage dealt by Fire, Ice, Lightning, Light and Shadow Effects is increased by x.
    {name:"evolving_wizards", weight:100}, ; Enemies have +x Elemental Resistance and deal +x Elemental Damage.
    {name:"explosive", weight:90}, ; Enemies explode upon dying dealing x of their Base Max Life as Skill Damage after x second within a x yard radius.
    {name:"fire_rage", weight:70}, ; Enemies summon 1 large Fire waves upon dying, dealing x Fire Damage.
    {name:"fire_strike", weight:100}, ; Enemies deal x Fire Damage and have x Chance to apply Burn for the next x seconds.
    {name:"floor_is_lava", weight:70}, ; Enemies leave an area of Molten Lava upon dying, lasting x seconds and dealing x Fire Damage per second to Heroes and Minions standing on it.
    {name:"flow_interruption", weight:100}, ; You have -x Life and Mana Regeneration.
    {name:"frenzy", weight:100}, ; Enemies have +x Attack Speed and +x Movement Speed.
    {name:"fury_of_the_storm", weight:100}, ; Enemies trigger a Lightning Bolt upon dying, dealing x Lightning Damage to Heroes and Minions hit.
    {name:"gargantuan", weight:90}, ; Enemies are bigger and deal +x Increased Damage until they receive damage.
    {name:"gravity", weight:100}, ; Your Pojectiles have -x Projectile Range and Speed.
    {name:"greater_speed", weight:30}, ; Enemies have +x Attack Speed and +x Movement Speed.
    {name:"greater_strength", weight:0}, ; Enemies deal +x Increased Damage.
    {name:"greater_vitality", weight:0}, ; Enemies have +x Max Life.
    {name:"hermetic", weight:100}, ; Enemies have +x Resistance to Damage over Time.
    {name:"highlander", weight:0}, ; The following Wave has an Invincible Elite enemy that only dies once you've kille every other enemy.
    {name:"ice_bombs", weight:90}, ; An Ice Bomb appears every x seconds. Ice Bomb explodes after x seconds, dealing x Ice Damage and Freezing Heroes and Minions hit by the explosion for the next x seconds within a x yard radius.
    {name:"ice_ray", weight:90}, ; Every x seconds, an Ice Ray falls from the sky directly toward you, dealing up to x Ice Damage. This Damage cannot be fatal. A few moments before it lands, Bryan creates a Protection Dome. Get into the dome to prevent the Ice Ray from dealing damage to you.
    {name:"ice_strike", weight:100}, ; Enemies deal x Ice Damage and have x Chance to apply Chill for the next x seconds.
    {name:"invulnerability", weight:50}, ; Enemeies gain a Shield equal to x of their Max Life.
    {name:"iron_health", weight:100}, ; Enemies have +x Max Life.
    {name:"light_beam", weight:90}, ; Light Beams continuously appear, dealing x Light Damage in a small area to Heroes and Minions hit.
    {name:"light_strike", weight:90}, ; Enemies deal x Light Damage and have x Chance to apply Daze, Slow, Armor Broken or Elemental Resistance Broken for the next x seconds.
    {name:"light_totem", weight:90}, ; A Light Totem appears every x seconds. The Light Totem lasts x seconds and casts x waves of x Light Projectiles before disappearing.
    {name:"lightning_strike", weight:100}, ; Enemies deal x Lightning Damage and have x Chance to apply Shock for the next x seconds.
    {name:"multiplication", weight:100}, ; Enemies have +x Additional Projectiles.
    {name:"neverending_speed", weight:-100}, ; Enemies gain a x Increased Attack Speed Multiplier everytime you complete a Wave.
    {name:"neverending_strength", weight:-100}, ; Enemies gain a x Increased Damage Multiplier everytime you complete a Wave.
    {name:"neverending_vitality", weight:-100}, ; Enemies gain a x Increased Life Multiplier everytime you complete a Wave.
    {name:"nullifying_shield", weight:60}, ; Enemies ignore the first x hits.
    {name:"obelisk_annihilation", weight:0}, ; Spawns an Obelisk of Annihilation nearby. While Obelisk of Annihilation is active, Enemies deal Increased Damage equal to the Percent of Life Left on Obelisk of Annihilation.
    {name:"obelisk_destruction", weight:0}, ; Spawns an Obelisk of Destruction nearby. While Obelisk of Destruction is active, it continuously casts Deadly Missiles in random directions.
    {name:"obelisk_illusion", weight:0}, ; Spawns an Obelisk of Illusion nearby. While Obelisk of Illusion is active, you can only choose between x Challenges instead of 3.
    {name:"obelisk_revocation", weight:0}, ; Spawns an Obelisk of Revocation nearby. While Obelisk of Revocation is active, you cannot restore Life.
    {name:"obelisk_transmutation", weight:0}, ; Spawns an Obelisk of Transmutation nearby. While Obelisk of Transmutation is active, everytime an enemy dies, it restores Life equal to its Max Life to other enemies within a x yard radius.
    {name:"overcrowding", weight:0}, ; The following Wave has +x more enemies.
    {name:"proliferation", weight:100}, ; Enemies have +x Increased Area Size.
    {name:"reconstruction", weight:90}, ; Enemies not receiving damage for x seconds restore their full Life.
    {name:"regeneration", weight:70}, ; Non-Elite Enemies regenerate x of their Max Life per second. Elite Enemies regenerate x of their Max Life per second.
    {name:"relentless_lightning", weight:100}, ; Lightning Bolts are constantly bouncing from the Edges of the World dealing x Lightning Damage to Heroes and Minions hit.
    {name:"rest", weight:100}, ; The Siege Leader has been defeated. Rest for now, and enjoy a fancy reward.
    {name:"seal_of_blindness", weight:100}, ; Seals of Blindness are moving randomly across the area. Standing on a Seal of Blindness reduces your Field of Vision.
    {name:"shadow_benediction", weight:80}, ; Every x seconds, a random enemy nearby becomes Chosen by the Shadows for the next x seconds. When Chosen by the Shadows ends, if the enemy is still alive, it deals x Shadow Damage to you and applies Shadow Confusion.
    {name:"shadow_clone", weight:50}, ; Enemies create a Shadow Clone upon dying that casts x attacks before vanishing
    {name:"shadow_curse", weight:80}, ; Every x seconds, a Shadow Symbol appears next to you. The Shadow Symbol lasts x seconds and deals x Shadow Damage the first time you walk onto it.
    {name:"shadow_strike", weight:90}, ; Enemies deal x Shadow Damage and have x Chance to apply Shadow Confusion for the next x seconds.
    {name:"side_storm", weight:100}, ; Whenever they attack, Enemies create x Lightning Bolts on their sides dealing x Lightning Damage to Heroes and Minions hit.
    {name:"siege_alacrity", weight:50}, ; The Siege Leader has +x Attack Speed.
    {name:"siege_barrage", weight:50}, ; The Siege Leader has new Attack Patterns.
    {name:"siege_brutality", weight:50}, ; The Siege Leader has +x Increased Damage.
    {name:"siege_dominance", weight:50}, ; The Siege Leader has +x Max Life.
    {name:"siege_escort", weight:50}, ; The Siege Leader is escorted by x Elite Enemies.
    {name:"siege_quiver", weight:50}, ; The Siege Leader has +x Additional Projectile.
    {name:"siege_reinforcements", weight:50}, ; The Siege Leader continuously calls upon allies during the fight.
    {name:"slippery_ice", weight:100}, ; The entire area is covered in Slippery Ice. While standing on Slippery Ice area, you slip...
    {name:"start_let_them_come", weight:100}, ; Each Wave, enemies will come from 6 different locations.
    {name:"start_open_the_gates", weight:0}, ; Each Wave, enemies will come from 4 different locations.
    {name:"start_set_up_the_barricades", weight:0}, ; Each Wave, enemies will come from 2 different locations.
    {name:"tenacious", weight:100}, ; Enemies have +x Resistance to Damage over Time.
    {name:"to_each_his_own", weight:100}, ; You have -x Life Leech.
    {name:"upgrade_epic", weight:300}, ; The next Challenge is of Epic rarity
    {name:"upgrade_legendary", weight:350}, ; The next Challenge is of Legendary rarity
    {name:"upgrade_magic", weight:50}, ; The next Challenge is of Magic rarity
    {name:"upgrade_rare", weight:250}, ; The next Challenge is of Rare rarity
    {name:"wild_beasts", weight:100} ; Enemies have +x Armor and deal +x Skill Damage.
]
global Rewards := [
    {name:"reward_chest_effect", weight:0}, ; Random Chest Effect.
    {name:"reward_chest_quality", weight:50}, ; War Chest Quality increases the overall quality of Equipment, Slormites, Slormelines and Fragments stored inside your War Chest upon looting its content.
    {name:"reward_chest_quality_effect", weight:50}, ; Random Chest Quality Effect.
    {name:"reward_chest_quantity", weight:50}, ; War Chest Quantity increases the quantity of everything that's inside your War Chest upon looting its content.
    {name:"reward_chest_quantity_effect", weight:60}, ; Random Chest Quantity Effect.
    {name:"reward_equipment", weight:20}, ; Increases the overall quality of Equipments stored inside your War Chest upon looting its content.
    {name:"reward_fragment", weight:20}, ; Increases the overall quality of Fragments stored inside your War Chest upon looting its content.
    {name:"reward_goldus", weight:40}, ; Increases the quantity of Goldus that's Inside your War Chest.
    {name:"reward_goldus_effect", weight:40}, ; Random Goldus Effect.
    {name:"reward_obelisk", weight:0}, ; Random Obelisk Modifier.
    {name:"reward_slorm", weight:10}, ; Increases the quantity of Slorm that's Inside your War Chest.
    {name:"reward_slorm_effect", weight: 50}, ; Random Slorm Modifier.
    {name:"reward_slormite", weight:30}, ; Increases the overall quality of Slormites stored inside your War Chest upon looting its content.
    {name:"reward_slormline", weight:30}, ; Increases the overall quality of Slormlines stored inside your War Chest upon looting its content.
    {name:"reward_spirit_adrianne", weight:0}, ; Reapersmith Spirits are found inside The Great Forge.
    {name:"reward_spirit_astorias", weight:0}, ; Reapersmith Spirits are found inside The Great Forge.
    {name:"reward_spirit_beigarth", weight:0}, ; Reapersmith Spirits are found inside The Great Forge.
    {name:"reward_spirit_cory", weight:0}, ; Reapersmith Spirits are found inside The Great Forge.
    {name:"reward_spirit_effect", weight:0}, ; Random Reapersmith Spirit Effect.
    {name:"reward_spirit_fulgurorn", weight:0}, ; Reapersmith Spirits are found inside The Great Forge.
    {name:"reward_spirit_hagan", weight:0}, ; Reapersmith Spirits are found inside The Great Forge.
    {name:"reward_spirit_smaloron", weight:0} ; Reapersmith Spirits are found inside The Great Forge.
]
global Duration := [
	{name:"duration3", weight:10},
	{name:"duration4", weight:20},
	{name:"duration5", weight:30},
	{name:"duration6", weight:40},
	{name:"duration7", weight:50}
]

ToolTip "Script Loaded", ToolTipPos[1], ToolTipPos[2]

; HOTKEYS

F1::ForgeSelector
F3::{
    if (A_IsPaused == 0) {
        ToolTip "Script Paused", ToolTipPos[1], ToolTipPos[2]
    } else {
        ToolTip "", ToolTipPos[1], ToolTipPos[2]
    }
    Pause -1
}
F5::Reload

; MAIN SELECTOR AND WEIGHTING FUNCTION

ForgeSelector() {
    If WinExist(WinTitle) {
        WinActivate
    }
    if ((ImageSearch(&FoundX, &FoundY, AutoStartBounds[1], AutoStartBounds[2], AutoStartBounds[3], AutoStartBounds[4], AutoStartImg))) {
        If WinExist(WinTitle) {
            WinActivate
            MouseMove AutoStartBox[1], AutoStartBox[2]
            Click "down"
            Sleep 10
            Click "up"
            Sleep 10
            MouseMove NextWaveButton[1], NextWaveButton[2]
            Click "down"
            Sleep 10
            Click "up"
        } 
    }
    if (ImageSearch(&FoundX, &FoundY, NextWaveBounds[1], NextWaveBounds[2], NextWaveBounds[3], NextWaveBounds[4], NextWaveImg)) {
        If WinExist(WinTitle) {
            WinActivate
            MouseMove NextWaveButton[1], NextWaveButton[2]
            Click "down"
            Sleep 10
            Click "up"
        }
    }
    if (!(ImageSearch(&FoundX, &FoundY, ForgeIconBounds[1], ForgeIconBounds[2], ForgeIconBounds[3], ForgeIconBounds[4], ForgeIconImg))) {
        Sleep 1000
        foundImages := ""
        leftWeight := -1000
        middleWeight := -1000
        rightWeight := -1000
        If (ControllerInput && WinExist(WinTitle)) {
            WinActivate
            MouseMove TopLeftClickPos[1], TopLeftClickPos[2]
            Click "down"
            Sleep 10
            Click "up"
        }
        foundChallenge := ''
        for index, value in Challenges {
            foundChallenge := value.name
            imagePath := Path foundChallenge Extension
            if (ImageSearch(&FoundX1, &FoundY1, LeftChallengeBounds[1], LeftChallengeBounds[2], LeftChallengeBounds[3], LeftChallengeBounds[4], imagePath)) {
                leftWeight := value.weight
                foundImages := "1. " foundChallenge " | " value.weight
                ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                SetTimer () => ToolTip(), ToolTipTimeOut
                break
            }
        }
        foundReward := ''
        for index, value in Rewards {
            foundReward := value.name
            imagePath := Path foundReward Extension
            if (ImageSearch(&FoundX1, &FoundY1, LeftRewardBounds[1], LeftRewardBounds[2], LeftRewardBounds[3], LeftRewardBounds[4], imagePath)) {
                if (foundChallenge == 'cursed_reward' && foundReward == 'reward_chest_quantity') {
                    leftWeight := CursedChestWeight
                } else {
                    leftWeight := leftWeight + value.weight
                }
                foundImages := foundImages "`n   +" foundReward " | " value.weight
                ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                SetTimer () => ToolTip(), ToolTipTimeout
                break
            }
        }
        for index, value in Duration {
            imagePath := Path value.name Extension
            if (ImageSearch(&FoundX1, &FoundY1, LeftDurationBounds[1], LeftDurationBounds[2], LeftDurationBounds[3], LeftDurationBounds[4], imagePath)) {
                leftWeight := leftWeight + value.weight
                foundImages := foundImages "`n    +" value.name " | " value.weight
                ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                SetTimer () => ToolTip(), ToolTipTimeout
                break
            }
        }
        If (ControllerInput && WinExist(WinTitle)) {
            WinActivate
            MouseMove TopLeftClickPos[1], TopLeftClickPos[2]
            Click "down"
            Sleep 10
            Click "up"
        }
        foundChallenge := ''
        for index, value in Challenges {
            foundChallenge := value.name
            imagePath := Path foundChallenge Extension
            if (ImageSearch(&FoundX1, &FoundY1, MiddleChallengeBounds[1], MiddleChallengeBounds[2], MiddleChallengeBounds[3], MiddleChallengeBounds[4], imagePath)) {
                middleWeight := value.weight
                foundImages := foundImages "`n2. " foundChallenge " | " value.weight
                ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                SetTimer () => ToolTip(), ToolTipTimeout
                break
            }
        }
        foundReward := ''
        for index, value in Rewards {
            foundReward := value.name
            imagePath := Path foundReward Extension
            if (ImageSearch(&FoundX1, &FoundY1, MiddleRewardBounds[1], MiddleRewardBounds[2], MiddleRewardBounds[3], MiddleRewardBounds[4], imagePath)) {
                if (foundChallenge == 'cursed_reward' && foundReward == 'reward_chest_quantity') {
                    middleWeight := CursedChestWeight
                } else {
                    middleWeight := middleWeight + value.weight
                }
                foundImages := foundImages "`n   +" foundReward " | " value.weight
                ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                SetTimer () => ToolTip(), ToolTipTimeout
                break
            }
        }
        for index, value in Duration {
            imagePath := Path value.name Extension
            if (ImageSearch(&FoundX1, &FoundY1, MiddleDurationBounds[1], MiddleDurationBounds[2], MiddleDurationBounds[3], MiddleDurationBounds[4], imagePath)) {
                middleWeight := middleWeight + value.weight
                foundImages := foundImages "`n    +" value.name " | " value.weight
                ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                SetTimer () => ToolTip(), ToolTipTimeout
                break
            }
        }
        If (ControllerInput && WinExist(WinTitle)) {
            WinActivate
            MouseMove TopLeftClickPos[1], TopLeftClickPos[2]
            Click "down"
            Sleep 10
            Click "up"
        }
        foundChallenge := ''
        for index, value in Challenges {
            foundChallenge := value.name
            imagePath := Path foundChallenge Extension
            if (ImageSearch(&FoundX1, &FoundY1, RightChallengeBounds[1], RightChallengeBounds[2], RightChallengeBounds[3], RightChallengeBounds[4], imagePath)) {
                rightWeight := value.weight
                foundImages := foundImages "`n3. " foundChallenge " | " value.weight
                ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                SetTimer () => ToolTip(), ToolTipTimeout
                break
            }
        }
        foundReward := ''
        for index, value in Rewards {
            foundReward := value.name
            imagePath := Path foundReward Extension
            if (ImageSearch(&FoundX1, &FoundY1, RightRewardBounds[1], RightRewardBounds[2], RightRewardBounds[3], RightRewardBounds[4], imagePath)) {
                if (foundChallenge == 'cursed_reward' && foundReward == 'reward_chest_quantity') {
                    rightWeight := CursedChestWeight
                } else {
                    rightWeight := rightWeight + value.weight
                }
                foundImages := foundImages "`n   +" foundReward " | " value.weight
                ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                SetTimer () => ToolTip(), ToolTipTimeout
                break
            }
        }
        for index, value in Duration {
            imagePath := Path value.name Extension
            if (ImageSearch(&FoundX1, &FoundY1, RightDurationBounds[1], RightDurationBounds[2], RightDurationBounds[3], RightDurationBounds[4], imagePath)) {
                rightWeight := rightWeight + value.weight
                foundImages := foundImages "`n    +" value.name " | " value.weight
                ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                SetTimer () => ToolTip(), ToolTipTimeout
                break
            }
        }
        if (leftWeight > -1000 || middleWeight > -1000 || rightWeight > -1000) {
            SendMode "Input"
            if (
                (leftWeight > middleWeight && leftWeight > rightWeight) ||
                (leftWeight == middleWeight && leftWeight == rightWeight) ||
                (leftWeight > middleWeight && leftWeight == rightWeight) ||
                (leftWeight == middleWeight && leftWeight > rightWeight)
            ) {
                If WinExist(WinTitle) {
                    WinActivate
                    MouseMove 600, 550
                    if (SelectOptions) {
                        Click "down"
                        Sleep 10
                        Click "up"
                        ToolTip foundImages "`n`nPicked 1. | " leftWeight, ToolTipPos[1], ToolTipPos[2]
                        SetTimer () => ToolTip(), ToolTipTimeout
                    }
                }
            } else if (
                (middleWeight > leftWeight && middleWeight > rightWeight) ||
                (middleWeight > leftWeight && middleWeight == rightWeight) ||
                (middleWeight == leftWeight && middleWeight > rightWeight)
            ) {
                If WinExist(WinTitle) {
                    WinActivate
                    MouseMove 950, 550
                    if (SelectOptions) {
                        Click "down"
                        Sleep 10
                        Click "up"
                        ToolTip foundImages "`n`nPicked 2. | " middleWeight, ToolTipPos[1], ToolTipPos[2]
                        SetTimer () => ToolTip(), ToolTipTimeout
                    }
                }
            } else if (
                (rightWeight > leftWeight && rightWeight > middleWeight) ||
                (rightWeight > leftWeight && rightWeight == middleWeight) ||
                (rightWeight == leftWeight && rightWeight > middleWeight)
            ) {
                If WinExist(WinTitle) {
                    WinActivate
                    MouseMove 1330, 550
                    if (SelectOptions) {
                        Click "down"
                        Sleep 10
                        Click "up"
                        ToolTip foundImages "`n`nPicked 3. | " rightWeight, ToolTipPos[1], ToolTipPos[2]
                        SetTimer () => ToolTip(), ToolTipTimeout
                    }
                }
            }
        } else {
            ToolTip "Images not found", ToolTipPos[1], ToolTipPos[2]
            SetTimer () => ToolTip(), ToolTipTimeout
        }
    }
    Sleep 100
}

; LOOP FUNCTION

ForgeLoop() {
    Loop {
        ForgeSelector
    }
}

; AUTO MODE

if (Mode == "auto") {
    ForgeLoop
}
