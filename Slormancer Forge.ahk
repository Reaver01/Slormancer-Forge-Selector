#Requires AutoHotkey v2.0

; GLOBAL VARIABLES
global Resolution4k := false
global Mode := "auto" ; "manual" = hit F1 to calculate weights; "auto" = loop and check automatically.
global SelectOptions := true ; true/false if false then options won't be clicked, but weight will still be calculated and displayed.
global ControllerInput := true ; Will turn on clicking on top right corner to get rid of controller circle if true.
global EnableOSD := true ; Will use the OSD instead of tooltips if true.
global WinTitle := "ahk_exe The Slormancer.exe"
global Path := "slormancer_img\"
global ToolTipTimeout := -30000
global TitleBarOffset := 30 ; Additional offset for bordered windows
global OsdSize := [220, 615]
if (Resolution4k == true) {
    global Extension := "_4k.png"
    global NextWaveImg := "slormancer_img\next_wave_4k.png"
    global AutoStartImg := "*25 slormancer_img\autostart_4k.png"
    global ForgeIconImg := "slormancer_img\forge_icon_4k.png"
    global TopLeftClickPos := [350, 350]
    global AutoStartBox := [3265, 600]
    global AutoStartBounds := [3210, 545, 3310, 645]
    global NextWaveButton := [3560, 600]
    global NextWaveBounds := [3315, 540, 3830, 660]
    global ForgeIconBounds := [3190, 0, 3300, 145]
    global LeftOption := [1200, 1200]
    global LeftChallengeBounds := [1100, 780, 1270, 970]
    global LeftRewardBounds := [1110, 1380, 1270, 1500]
    global LeftDurationBounds := [1050, 1270, 1315, 1320]
    global MiddleOption := [1920, 1200]
    global MiddleChallengeBounds := [1840, 780, 2000, 970]
    global MiddleRewardBounds := [1840, 1380, 2000, 1500]
    global MiddleDurationBounds := [1790, 1270, 2060, 1325]
    global RightOption := [2650, 1200]
    global RightChallengeBounds := [2570, 780, 2750, 970]
    global RightRewardBounds := [2570, 1380, 2750, 1500]
    global RightDurationBounds := [2520, 1270, 2790, 1325]
    global ToolTipPos := [70, 70]
} else {
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
    global LeftOption := [600, 550]
    global LeftChallengeBounds := [450, 300, 750, 600]
    global LeftRewardBounds := [450, 650, 750, 800]
    global LeftDurationBounds := [450, 620, 750, 700]
    global MiddleOption := [950, 550]
    global MiddleChallengeBounds := [850, 300, 1150, 600]
    global MiddleRewardBounds := [850, 650, 1150, 800]
    global MiddleDurationBounds := [850, 620, 1150, 700]
    global RightOption := [1330, 550]
    global RightChallengeBounds := [1200, 300, 1500, 600]
    global RightRewardBounds := [1200, 650, 1500, 800]
    global RightDurationBounds := [1200, 620, 1500, 700]
    global ToolTipPos := [5, 5]
}
global CursedChestWeight := 200 ; Allows attack speed curse buff to show
global Challenges := [
    {display_name:"Ace Combat", file_name:"ace_combat", weight:0}, ; The following Wave has x additional Elite enemies.
    {display_name:"Assassins", file_name:"assassins", weight:100}, ; Enemies have +x Evasion and +x Critical Strike Chance.
    {display_name:"Assimilation", file_name:"assimilation", weight:100}, ; Enemies receive x Decreased Damage for each yard between you and them.
    {display_name:"Attrition Battle", file_name:"attrition_battle", weight:200}, ; The Duration of all upcoming Challenges is increased by x Waves.
    {display_name:"Avenger", file_name:"avenger", weight:60}, ; Enemies gain +x increased Damage whenever another enemy dies within a x yard radius.
    {display_name:"Curse", file_name:"curse", weight:0}, ; This depends on the cursed reward option. Script is set to only allow Attack Speed increase.
    {display_name:"Cursed Reward", file_name:"cursed_reward", weight:-100}, ; Adds a random Curse that will affect an upcoming Challenge.
    {display_name:"Double Down", file_name:"double_down", weight:100}, ; Enemies have +x Recast Chance.
    {display_name:"Endless Fire", file_name:"endless_fire", weight:80}, ; A slow yet massive Fireball is constantly following you, dealing x Fire Damage to Heroes and Minions hit.
    {display_name:"Equilibrium", file_name:"equilibrium", weight:100}, ; Damage dealt by Fire, Ice, Lightning, Light and Shadow Effects is increased by x.
    {display_name:"Evolving Wizards", file_name:"evolving_wizards", weight:100}, ; Enemies have +x Elemental Resistance and deal +x Elemental Damage.
    {display_name:"Explosive", file_name:"explosive", weight:90}, ; Enemies explode upon dying dealing x of their Base Max Life as Skill Damage after x second within a x yard radius.
    {display_name:"Fire Rage", file_name:"fire_rage", weight:70}, ; Enemies summon 1 large Fire waves upon dying, dealing x Fire Damage.
    {display_name:"Fire Strike", file_name:"fire_strike", weight:100}, ; Enemies deal x Fire Damage and have x Chance to apply Burn for the next x seconds.
    {display_name:"Floor is Lava", file_name:"floor_is_lava", weight:70}, ; Enemies leave an area of Molten Lava upon dying, lasting x seconds and dealing x Fire Damage per second to Heroes and Minions standing on it.
    {display_name:"Flow Interruption", file_name:"flow_interruption", weight:100}, ; You have -x Life and Mana Regeneration.
    {display_name:"Frenzy", file_name:"frenzy", weight:100}, ; Enemies have +x Attack Speed and +x Movement Speed.
    {display_name:"Fury of the Storm", file_name:"fury_of_the_storm", weight:100}, ; Enemies trigger a Lightning Bolt upon dying, dealing x Lightning Damage to Heroes and Minions hit.
    {display_name:"Gargantuan", file_name:"gargantuan", weight:90}, ; Enemies are bigger and deal +x Increased Damage until they receive damage.
    {display_name:"Gravity", file_name:"gravity", weight:100}, ; Your Pojectiles have -x Projectile Range and Speed.
    {display_name:"Greater Speed", file_name:"greater_speed", weight:10}, ; Enemies have +x Attack Speed and +x Movement Speed.
    {display_name:"Greater Strength", file_name:"greater_strength", weight:0}, ; Enemies deal +x Increased Damage.
    {display_name:"Greater Vitality", file_name:"greater_vitality", weight:0}, ; Enemies have +x Max Life.
    {display_name:"Hermetic", file_name:"hermetic", weight:100}, ; Enemies have +x Resistance to Damage over Time.
    {display_name:"Highlander", file_name:"highlander", weight:0}, ; The following Wave has an Invincible Elite enemy that only dies once you've kille every other enemy.
    {display_name:"Ice Bombs", file_name:"ice_bombs", weight:90}, ; An Ice Bomb appears every x seconds. Ice Bomb explodes after x seconds, dealing x Ice Damage and Freezing Heroes and Minions hit by the explosion for the next x seconds within a x yard radius.
    {display_name:"Ice Ray", file_name:"ice_ray", weight:90}, ; Every x seconds, an Ice Ray falls from the sky directly toward you, dealing up to x Ice Damage. This Damage cannot be fatal. A few moments before it lands, Bryan creates a Protection Dome. Get into the dome to prevent the Ice Ray from dealing damage to you.
    {display_name:"Ice Strike", file_name:"ice_strike", weight:100}, ; Enemies deal x Ice Damage and have x Chance to apply Chill for the next x seconds.
    {display_name:"Invulnerability", file_name:"invulnerability", weight:50}, ; Enemeies gain a Shield equal to x of their Max Life.
    {display_name:"Iron Health", file_name:"iron_health", weight:100}, ; Enemies have +x Max Life.
    {display_name:"Light Beam", file_name:"light_beam", weight:90}, ; Light Beams continuously appear, dealing x Light Damage in a small area to Heroes and Minions hit.
    {display_name:"Light Strike", file_name:"light_strike", weight:90}, ; Enemies deal x Light Damage and have x Chance to apply Daze, Slow, Armor Broken or Elemental Resistance Broken for the next x seconds.
    {display_name:"Light Totem", file_name:"light_totem", weight:90}, ; A Light Totem appears every x seconds. The Light Totem lasts x seconds and casts x waves of x Light Projectiles before disappearing.
    {display_name:"Lightning Strike", file_name:"lightning_strike", weight:100}, ; Enemies deal x Lightning Damage and have x Chance to apply Shock for the next x seconds.
    {display_name:"Multiplication", file_name:"multiplication", weight:100}, ; Enemies have +x Additional Projectiles.
    {display_name:"Neverending Speed", file_name:"neverending_speed", weight:-100}, ; Enemies gain a x Increased Attack Speed Multiplier everytime you complete a Wave.
    {display_name:"Neverending Strength", file_name:"neverending_strength", weight:-100}, ; Enemies gain a x Increased Damage Multiplier everytime you complete a Wave.
    {display_name:"Neverending Vitality", file_name:"neverending_vitality", weight:-100}, ; Enemies gain a x Increased Life Multiplier everytime you complete a Wave.
    {display_name:"Nullifying Shield", file_name:"nullifying_shield", weight:60}, ; Enemies ignore the first x hits.
    {display_name:"Obelisk of Annihilation", file_name:"obelisk_annihilation", weight:0}, ; Spawns an Obelisk of Annihilation nearby. While Obelisk of Annihilation is active, Enemies deal Increased Damage equal to the Percent of Life Left on Obelisk of Annihilation.
    {display_name:"Obelisk of Destruction", file_name:"obelisk_destruction", weight:0}, ; Spawns an Obelisk of Destruction nearby. While Obelisk of Destruction is active, it continuously casts Deadly Missiles in random directions.
    {display_name:"Obelisk of Illusion", file_name:"obelisk_illusion", weight:0}, ; Spawns an Obelisk of Illusion nearby. While Obelisk of Illusion is active, you can only choose between x Challenges instead of 3.
    {display_name:"Obelisk of Revocation", file_name:"obelisk_revocation", weight:0}, ; Spawns an Obelisk of Revocation nearby. While Obelisk of Revocation is active, you cannot restore Life.
    {display_name:"Obelisk of Transmutation", file_name:"obelisk_transmutation", weight:0}, ; Spawns an Obelisk of Transmutation nearby. While Obelisk of Transmutation is active, everytime an enemy dies, it restores Life equal to its Max Life to other enemies within a x yard radius.
    {display_name:"Overcrowding", file_name:"overcrowding", weight:0}, ; The following Wave has +x more enemies.
    {display_name:"Proliferation", file_name:"proliferation", weight:100}, ; Enemies have +x Increased Area Size.
    {display_name:"Reconstruction", file_name:"reconstruction", weight:90}, ; Enemies not receiving damage for x seconds restore their full Life.
    {display_name:"Regeneration", file_name:"regeneration", weight:70}, ; Non-Elite Enemies regenerate x of their Max Life per second. Elite Enemies regenerate x of their Max Life per second.
    {display_name:"Relentless Lightning", file_name:"relentless_lightning", weight:100}, ; Lightning Bolts are constantly bouncing from the Edges of the World dealing x Lightning Damage to Heroes and Minions hit.
    {display_name:"Rest", file_name:"rest", weight:100}, ; The Siege Leader has been defeated. Rest for now, and enjoy a fancy reward.
    {display_name:"Seal of Blindness", file_name:"seal_of_blindness", weight:100}, ; Seals of Blindness are moving randomly across the area. Standing on a Seal of Blindness reduces your Field of Vision.
    {display_name:"Shadow Benediction", file_name:"shadow_benediction", weight:80}, ; Every x seconds, a random enemy nearby becomes Chosen by the Shadows for the next x seconds. When Chosen by the Shadows ends, if the enemy is still alive, it deals x Shadow Damage to you and applies Shadow Confusion.
    {display_name:"Shadow Clone", file_name:"shadow_clone", weight:50}, ; Enemies create a Shadow Clone upon dying that casts x attacks before vanishing
    {display_name:"Shadow Curse", file_name:"shadow_curse", weight:80}, ; Every x seconds, a Shadow Symbol appears next to you. The Shadow Symbol lasts x seconds and deals x Shadow Damage the first time you walk onto it.
    {display_name:"Shadow Strike", file_name:"shadow_strike", weight:90}, ; Enemies deal x Shadow Damage and have x Chance to apply Shadow Confusion for the next x seconds.
    {display_name:"Side Storm", file_name:"side_storm", weight:100}, ; Whenever they attack, Enemies create x Lightning Bolts on their sides dealing x Lightning Damage to Heroes and Minions hit.
    {display_name:"The Siege Leader: Alacrity", file_name:"siege_alacrity", weight:50}, ; The Siege Leader has +x Attack Speed.
    {display_name:"The Siege Leader: Barrage", file_name:"siege_barrage", weight:50}, ; The Siege Leader has new Attack Patterns.
    {display_name:"The Siege Leader: Brutality", file_name:"siege_brutality", weight:50}, ; The Siege Leader has +x Increased Damage.
    {display_name:"The Siege Leader: Dominance", file_name:"siege_dominance", weight:50}, ; The Siege Leader has +x Max Life.
    {display_name:"The Siege Leader: Escort", file_name:"siege_escort", weight:50}, ; The Siege Leader is escorted by x Elite Enemies.
    {display_name:"The Siege Leader: Quiver", file_name:"siege_quiver", weight:50}, ; The Siege Leader has +x Additional Projectile.
    {display_name:"The Siege Leader: Reinforcements", file_name:"siege_reinforcements", weight:50}, ; The Siege Leader continuously calls upon allies during the fight.
    {display_name:"Slippery Ice", file_name:"slippery_ice", weight:100}, ; The entire area is covered in Slippery Ice. While standing on Slippery Ice area, you slip...
    {display_name:"Let. Them. Come.", file_name:"start_let_them_come", weight:100}, ; Each Wave, enemies will come from 6 different locations.
    {display_name:"Open the Gates!", file_name:"start_open_the_gates", weight:0}, ; Each Wave, enemies will come from 4 different locations.
    {display_name:"Set up the Barricades!", file_name:"start_set_up_the_barricades", weight:0}, ; Each Wave, enemies will come from 2 different locations.
    {display_name:"Tenacious", file_name:"tenacious", weight:100}, ; Enemies have +x Resistance to Damage over Time.
    {display_name:"To Each His Own", file_name:"to_each_his_own", weight:100}, ; You have -x Life Leech.
    {display_name:"Epic Upgrade", file_name:"upgrade_epic", weight:300}, ; The next Challenge is of Epic rarity
    {display_name:"Legendary Upgrade", file_name:"upgrade_legendary", weight:350}, ; The next Challenge is of Legendary rarity
    {display_name:"Magic Upgrade", file_name:"upgrade_magic", weight:50}, ; The next Challenge is of Magic rarity
    {display_name:"Rare Upgrade", file_name:"upgrade_rare", weight:250}, ; The next Challenge is of Rare rarity
    {display_name:"Wild Beasts", file_name:"wild_beasts", weight:100} ; Enemies have +x Armor and deal +x Skill Damage.
]
global Rewards := [
    {display_name:"Chest Effect", file_name:"reward_chest_effect", weight:0, count:0}, ; Random Chest Effect.
    {display_name:"Chest Quality", file_name:"reward_chest_quality", weight:50, count:0}, ; War Chest Quality increases the overall quality of Equipment, Slormites, Slormelines and Fragments stored inside your War Chest upon looting its content.
    {display_name:"Chest Quality Effect", file_name:"reward_chest_quality_effect", weight:50, count:0}, ; Random Chest Quality Effect.
    {display_name:"Chest Quantity", file_name:"reward_chest_quantity", weight:50, count:0}, ; War Chest Quantity increases the quantity of everything that's inside your War Chest upon looting its content.
    {display_name:"Chest Quantity Effect", file_name:"reward_chest_quantity_effect", weight:60, count:0}, ; Random Chest Quantity Effect.
    {display_name:"Equipment", file_name:"reward_equipment", weight:20, count:0}, ; Increases the overall quality of Equipments stored inside your War Chest upon looting its content.
    {display_name:"Equipment Effect", file_name:"reward_equipment_effect", weight:20, count:0}, ; Increases the overall quality of Equipments stored inside your War Chest upon looting its content.
    {display_name:"Fragment", file_name:"reward_fragment", weight:20, count:0}, ; Increases the overall quality of Fragments stored inside your War Chest upon looting its content.
    {display_name:"Goldus", file_name:"reward_goldus", weight:40, count:0}, ; Increases the quantity of Goldus that's Inside your War Chest.
    {display_name:"Goldus Effect", file_name:"reward_goldus_effect", weight:40, count:0}, ; Random Goldus Effect.
    {display_name:"Obelisk", file_name:"reward_obelisk", weight:0, count:0}, ; Random Obelisk Modifier.
    {display_name:"Slorm", file_name:"reward_slorm", weight:10, count:0}, ; Increases the quantity of Slorm that's Inside your War Chest.
    {display_name:"Slorm Effect", file_name:"reward_slorm_effect", weight: 50, count:0}, ; Random Slorm Modifier.
    {display_name:"Slormite", file_name:"reward_slormite", weight:30, count:0}, ; Increases the overall quality of Slormites stored inside your War Chest upon looting its content.
    {display_name:"Slormline", file_name:"reward_slormline", weight:30, count:0}, ; Increases the overall quality of Slormlines stored inside your War Chest upon looting its content.
    {display_name:"Adrianne Spirit", file_name:"reward_spirit_adrianne", weight:0, count:0}, ; Reapersmith Spirits are found inside The Great Forge.
    {display_name:"Astorias Spirit", file_name:"reward_spirit_astorias", weight:0, count:0}, ; Reapersmith Spirits are found inside The Great Forge.
    {display_name:"Beigarth Spirit", file_name:"reward_spirit_beigarth", weight:0, count:0}, ; Reapersmith Spirits are found inside The Great Forge.
    {display_name:"Cory Spirit", file_name:"reward_spirit_cory", weight:0, count:0}, ; Reapersmith Spirits are found inside The Great Forge.
    {display_name:"Fulgurorn Spirit", file_name:"reward_spirit_fulgurorn", weight:0, count:0}, ; Reapersmith Spirits are found inside The Great Forge.
    {display_name:"Hagan Spirit", file_name:"reward_spirit_hagan", weight:0, count:0}, ; Reapersmith Spirits are found inside The Great Forge.
    {display_name:"Smaloron Spirit", file_name:"reward_spirit_smaloron", weight:0, count:0}, ; Reapersmith Spirits are found inside The Great Forge.
    {display_name:"Spirit Effect", file_name:"reward_spirit_effect", weight:0, count:0}, ; Random Reapersmith Spirit Effect.
    {display_name:"None", file_name:"reward_none", weight:0, count:0} ; No Reward
]
global Duration := [
	{display_name:"Duration: 3 Waves", file_name:"duration3", weight:10},
	{display_name:"Duration: 4 Waves", file_name:"duration4", weight:20},
	{display_name:"Duration: 5 Waves", file_name:"duration5", weight:30},
	{display_name:"Duration: 6 Waves", file_name:"duration6", weight:40},
	{display_name:"Duration: 7 Waves", file_name:"duration7", weight:50}
]
global Results := {
    left: {challenge: "", reward: "", label: "", totalWeight: -1000, selected: false}, 
    middle: {challenge: "", reward: "", label: "", totalWeight: -1000, selected: false}, 
    right: {challenge: "", reward: "", label: "", totalWeight: -1000, selected: false}, 
}
global ImageError := false
global PreviousChoices := []

; On Screen Display
global osdGui := Gui("+AlwaysOnTop -Caption +ToolWindow +LastFound +E0x20")
osdGui.BackColor := "Black"
osdGui.SetFont("s10 cWhite", "Consolas")
global osdText := osdGui.Add("Text", "w" OsdSize[1] " h" OsdSize[2] " vOsdText Left")
WinSetTransparent(100, osdGui.Hwnd)

if (EnableOSD) {
    UpdateOSD("Script Loaded")
} else {
    ToolTip "Script Loaded", ToolTipPos[1], ToolTipPos[2]
}

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
    global Results
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
        Results := {
            left: {challenge: "", reward: "", label: "", totalWeight: -1000, selected: false}, 
            middle: {challenge: "", reward: "", label: "", totalWeight: -1000, selected: false}, 
            right: {challenge: "", reward: "", label: "", totalWeight: -1000, selected: false}, 
        }
        foundImages := ""
        if (WinExist(WinTitle)) {
            WinActivate
            MouseMove TopLeftClickPos[1], TopLeftClickPos[2]
            if (ControllerInput) {
                Click "down"
                Sleep 10
                Click "up"
            }
        }
        for index, value in Challenges {
            Results.left.challenge := value.display_name
            imagePath := Path value.file_name Extension
            if (ImageSearch(&FoundX, &FoundY, LeftChallengeBounds[1], LeftChallengeBounds[2], LeftChallengeBounds[3], LeftChallengeBounds[4], imagePath)) {
                Results.left.totalWeight := value.weight
                Results.left.label .= "1. " value.display_name " | " value.weight
                if (!EnableOSD) {
                    foundImages := "1. " value.display_name " | " value.weight
                    ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                    SetTimer () => ToolTip(), ToolTipTimeOut
                }
                break
            }
        }
        for index, value in Rewards {
            Results.left.reward := value.display_name
            imagePath := Path value.file_name Extension
            if (ImageSearch(&FoundX, &FoundY, LeftRewardBounds[1], LeftRewardBounds[2], LeftRewardBounds[3], LeftRewardBounds[4], imagePath)) {
                if (Results.left.challenge == 'Cursed Reward' && value.display_name == 'Chest Quantity') {
                    Results.left.totalWeight := CursedChestWeight
                } else {
                    Results.left.totalWeight += value.weight
                }
                Results.left.label .= "`n + " value.display_name " | " value.weight
                if (!EnableOSD) {
                    foundImages := foundImages "`n + " value.display_name " | " value.weight
                    ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                    SetTimer () => ToolTip(), ToolTipTimeout
                }
                break
            }
        }
        for index, value in Duration {
            imagePath := Path value.file_name Extension
            if (ImageSearch(&FoundX, &FoundY, LeftDurationBounds[1], LeftDurationBounds[2], LeftDurationBounds[3], LeftDurationBounds[4], imagePath)) {
                Results.left.totalWeight += value.weight
                Results.left.label .=  "`n + " value.display_name " | " value.weight
                if (!EnableOSD) {
                    foundImages := foundImages "`n + " value.display_name " | " value.weight
                    ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                    SetTimer () => ToolTip(), ToolTipTimeout
                }
                break
            }
        }
        if (WinExist(WinTitle)) {
            WinActivate
            MouseMove TopLeftClickPos[1], TopLeftClickPos[2]
            if (ControllerInput) {
                Click "down"
                Sleep 10
                Click "up"
            }
        }
        for index, value in Challenges {
            Results.middle.challenge := value.display_name
            imagePath := Path value.file_name Extension
            if (ImageSearch(&FoundX, &FoundY, MiddleChallengeBounds[1], MiddleChallengeBounds[2], MiddleChallengeBounds[3], MiddleChallengeBounds[4], imagePath)) {
                Results.middle.totalWeight := value.weight
                Results.middle.label .= "2. " value.display_name " | " value.weight
                if (!EnableOSD) {
                    foundImages := foundImages "`n2. " value.display_name " | " value.weight
                    ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                    SetTimer () => ToolTip(), ToolTipTimeOut
                }
                break
            }
        }
        for index, value in Rewards {
            Results.middle.reward := value.display_name
            imagePath := Path value.file_name Extension
            if (ImageSearch(&FoundX, &FoundY, MiddleRewardBounds[1], MiddleRewardBounds[2], MiddleRewardBounds[3], MiddleRewardBounds[4], imagePath)) {
                if (Results.middle.challenge == 'Cursed Reward' && value.display_name == 'Chest Quantity') {
                    Results.middle.totalWeight := CursedChestWeight
                } else {
                    Results.middle.totalWeight += value.weight
                }
                Results.middle.label .= "`n + " value.display_name " | " value.weight
                if (!EnableOSD) {
                    foundImages := foundImages "`n + " value.display_name " | " value.weight
                    ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                    SetTimer () => ToolTip(), ToolTipTimeout
                }
                break
            }
        }
        for index, value in Duration {
            imagePath := Path value.file_name Extension
            if (ImageSearch(&FoundX, &FoundY, MiddleDurationBounds[1], MiddleDurationBounds[2], MiddleDurationBounds[3], MiddleDurationBounds[4], imagePath)) {
                Results.middle.totalWeight := Results.middle.totalWeight + value.weight
                Results.middle.label .= "`n + " value.display_name " | " value.weight
                if (!EnableOSD) {
                    foundImages := foundImages "`n + " value.display_name " | " value.weight
                    ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                    SetTimer () => ToolTip(), ToolTipTimeout
                }
                break
            }
        }
        if (WinExist(WinTitle)) {
            WinActivate
            MouseMove TopLeftClickPos[1], TopLeftClickPos[2]
            if (ControllerInput) {
                Click "down"
                Sleep 10
                Click "up"
            }
        }
        for index, value in Challenges {
            Results.right.challenge := value.display_name
            imagePath := Path value.file_name Extension
            if (ImageSearch(&FoundX, &FoundY, RightChallengeBounds[1], RightChallengeBounds[2], RightChallengeBounds[3], RightChallengeBounds[4], imagePath)) {
                Results.right.totalWeight := value.weight
                Results.right.label .= "3. " value.display_name " | " value.weight
                if (!EnableOSD) {
                    foundImages := foundImages "`n3. " value.display_name " | " value.weight
                    ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                    SetTimer () => ToolTip(), ToolTipTimeOut
                }
                break
            }
        }
        for index, value in Rewards {
            Results.right.reward := value.display_name
            imagePath := Path value.file_name Extension
            if (ImageSearch(&FoundX, &FoundY, RightRewardBounds[1], RightRewardBounds[2], RightRewardBounds[3], RightRewardBounds[4], imagePath)) {
                if (Results.right.challenge == 'Cursed Reward' && value.display_name == 'Chest Quantity') {
                    Results.right.totalWeight := CursedChestWeight
                } else {
                    Results.right.totalWeight += value.weight
                }
                Results.right.label .= "`n + " value.display_name " | " value.weight
                if (!EnableOSD) {
                    foundImages := foundImages "`n + " value.display_name " | " value.weight
                    ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                    SetTimer () => ToolTip(), ToolTipTimeout
                }
                break
            }
        }
        for index, value in Duration {
            imagePath := Path value.file_name Extension
            if (ImageSearch(&FoundX, &FoundY, RightDurationBounds[1], RightDurationBounds[2], RightDurationBounds[3], RightDurationBounds[4], imagePath)) {
                Results.right.totalWeight += value.weight
                Results.right.label .= "`n + " value.display_name " | " value.weight
                if (!EnableOSD) {
                    foundImages := foundImages "`n + " value.display_name " | " value.weight
                    ToolTip foundImages, ToolTipPos[1], ToolTipPos[2]
                    SetTimer () => ToolTip(), ToolTipTimeout
                }
                break
            }
        }
        PreviousChoices.Push(Results.right.label)
        PreviousChoices.Push(Results.middle.label)
        PreviousChoices.Push(Results.left.label)
        if (Results.left.totalWeight > -1000 || Results.middle.totalWeight > -1000 || Results.right.totalWeight > -1000) {
            ImageError := false
            SendMode "Input"
            if (
                (Results.left.totalWeight > Results.middle.totalWeight && Results.left.totalWeight > Results.right.totalWeight) ||
                (Results.left.totalWeight == Results.middle.totalWeight && Results.left.totalWeight == Results.right.totalWeight) ||
                (Results.left.totalWeight > Results.middle.totalWeight && Results.left.totalWeight == Results.right.totalWeight) ||
                (Results.left.totalWeight == Results.middle.totalWeight && Results.left.totalWeight > Results.right.totalWeight)
            ) {
                If WinExist(WinTitle) {
                    WinActivate
                    MouseMove LeftOption[1], LeftOption[2]
                    if (SelectOptions) {
                        Click "down"
                        Sleep 10
                        Click "up"
                        if (EnableOSD) {
                            Results.left.selected := true
                        } else {
                            ToolTip foundImages "`n`nPicked " Results.left.label, ToolTipPos[1], ToolTipPos[2]
                            SetTimer () => ToolTip(), ToolTipTimeout
                        }
                    }
                }
            } else if (
                (Results.middle.totalWeight > Results.left.totalWeight && Results.middle.totalWeight > Results.right.totalWeight) ||
                (Results.middle.totalWeight > Results.left.totalWeight && Results.middle.totalWeight == Results.right.totalWeight) ||
                (Results.middle.totalWeight == Results.left.totalWeight && Results.middle.totalWeight > Results.right.totalWeight)
            ) {
                If WinExist(WinTitle) {
                    WinActivate
                    MouseMove MiddleOption[1], MiddleOption[2]
                    if (SelectOptions) {
                        Click "down"
                        Sleep 10
                        Click "up"
                        if (EnableOSD) {
                            Results.middle.selected := true
                        } else {
                            ToolTip foundImages "`n`nPicked " Results.middle.label, ToolTipPos[1], ToolTipPos[2]
                            SetTimer () => ToolTip(), ToolTipTimeout
                        }
                    }
                }
            } else if (
                (Results.right.totalWeight > Results.left.totalWeight && Results.right.totalWeight > Results.middle.totalWeight) ||
                (Results.right.totalWeight > Results.left.totalWeight && Results.right.totalWeight == Results.middle.totalWeight) ||
                (Results.right.totalWeight == Results.left.totalWeight && Results.right.totalWeight > Results.middle.totalWeight)
            ) {
                If WinExist(WinTitle) {
                    WinActivate
                    MouseMove RightOption[1], RightOption[2]
                    if (SelectOptions) {
                        Click "down"
                        Sleep 10
                        Click "up"
                        if (EnableOSD) {
                            Results.right.selected := true
                        } else {
                            ToolTip foundImages "`n`nPicked " Results.right.label, ToolTipPos[1], ToolTipPos[2]
                            SetTimer () => ToolTip(), ToolTipTimeout
                        }
                    }
                }
            }
        } else {
            if (EnableOSD) {
                ImageError := true
            } else {
                ToolTip "Images not found", ToolTipPos[1], ToolTipPos[2]
                SetTimer () => ToolTip(), ToolTipTimeout
            }
        }
        if (EnableOSD) {
            UpdateOSD()
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


UpdateOSD(customText?) {
    Sleep 10
    global osdGui, osdText, WinTitle, Rewards, ImageError, PreviousChoices
    if !WinExist(WinTitle)
        return

    outputText := ""
    if (IsSet(customText)) {
        outputText .= customText "`n"
    }

    failedImages := ""
    if (ImageError) {
        failedImages := "Failed to find images`n"
    }
    
    pastChoices := "Previous Options:"
    loop Min(PreviousChoices.Length, 3) {
        pastChoices := pastChoices "`n" PreviousChoices[PreviousChoices.Length - A_Index + 1]
    }

    recent := "`n`nLast Selected Reward:"
    for key, result in Results.OwnProps() {
        if (result.selected) {
            recent .= "`n" result.label
        }
        
        for reward in Rewards {
            if (result.reward != "" && result.reward == reward.display_name) {
                reward.count += 1
                break
            }
        }
    }

    summary := "`n`nReward Counts:`n"
    for rw in Rewards {
        summary .= rw.display_name ": " rw.count "`n"
    }

    outputText := failedImages pastChoices recent summary

    osdText.Text := outputText
    WinGetPos(&x, &y, &w, &h, WinTitle)
    
    offsetY := ToolTipPos[2]
    if IsWindowBordered(WinTitle)
        offsetY += TitleBarOffset
    osdGui.Show("x" (x + ToolTipPos[1]) " y" (y + offsetY))
}

; Function to determine if a window is bordered
IsWindowBordered(hwnd) {
    style := WinGetStyle(hwnd)
    WS_BORDER     := 0x00800000
    WS_CAPTION    := 0x00C00000  ; WS_BORDER | WS_DLGFRAME
    WS_THICKFRAME := 0x00040000
    return (style & WS_CAPTION) || (style & WS_THICKFRAME)
}
