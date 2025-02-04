library BloodGolemActions requires GenericUnitFunc

function Big_Attack takes unit u, unit target, real delay2 returns nothing
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetUnitX(target)
    local real end_y = GetUnitY(target)
    local real angle = Angle(x, y, end_x, end_y)
    local real delay = 0.0
    local real pre_delay = delay2 - 0.30
    local real dist = 300
    local real dist2 = 600
    local real dist3 = 900
    local real dist4 = 1200
    local real dist5 = 1500
    local real size = 225
    local real eff_coef = (size / 225) 
    local real dmg = 100
    local string eff = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Invisibility\\InvisibilityTarget.mdl", u, "chest") )
    
    call SetUnitFacingTimed(u, angle, delay)
    call Delayed_Target_Time(u, target, pre_delay, delay)
    call Delayed_Pre_Anim(u, 10, 20 / pre_delay, pre_delay, 110, delay)
    
    call Area_Dmg_Attached(u, dmg, dist, 0, size, true, delay2)
    call Effect_Attached(u, dist, 0, 100 * eff_coef, 100, 0, 0, 0, 0, angle, true, eff, delay2)
    call Knock_Back_Attached(u, dist, 0, size, 30, 28, -0.9, 0, true, true, delay2)
    
    call Area_Dmg_Attached(u, dmg, dist2, 0, size, true, delay2)
    call Effect_Attached(u, dist2, 0, 100 * eff_coef, 100, 0, 0, 0, 0, angle, true, eff, delay2)
    call Knock_Back_Attached(u, dist2, 0, size, 30, 28, -0.9, 0, true, true, delay2)
    
    call Area_Dmg_Attached(u, dmg, dist3, 0, size, true, delay2)
    call Effect_Attached(u, dist3, 0, 100 * eff_coef, 100, 0, 0, 0, 0, angle, true, eff, delay2)
    call Knock_Back_Attached(u, dist3, 0, size, 30, 28, -0.9, 0, true, true, delay2)
    
    call Area_Dmg_Attached(u, dmg, dist4, 0, size, true, delay2)
    call Effect_Attached(u, dist4, 0, 100 * eff_coef, 100, 0, 0, 0, 0, angle, true, eff, delay2)
    call Knock_Back_Attached(u, dist4, 0, size, 30, 28, -0.9, 0, true, true, delay2)
    
    call Area_Dmg_Attached(u, dmg, dist5, 0, size, true, delay2)
    call Effect_Attached(u, dist5, 0, 100 * eff_coef, 100, 0, 0, 0, 0, angle, true, eff, delay2)
    call Knock_Back_Attached(u, dist5, 0, size, 30, 28, -0.9, 0, true, true, delay2)
endfunction

// default delay2 = 1.2
function Center_Attack takes unit u, unit target, real delay2 returns nothing
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetUnitX(target)
    local real end_y = GetUnitY(target)
    local real angle = Angle(x, y, end_x, end_y)
    local real delay = 0.0
    local real pre_delay = delay2 - 0.20
    local real anim_coef = pre_delay
    local real dist = 0
    local real size = 500
    local real eff_coef = (size / 225)
    local string eff = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Invisibility\\InvisibilityTarget.mdl", u, "chest") )
    
    call SetUnitFacingTimed(u, angle, delay)
    call Delayed_Pre_Anim(u, 3, 20 / pre_delay, pre_delay, 125, delay)
    call Area_Dmg_Attached(u, 125, dist, 0, size, true, delay2)
    call Effect_Attached(u, dist, 0, 100 * eff_coef, 100, 0, 0, 0, 0, angle, true, eff, delay2)
    call Knock_Back_Attached(u, dist, 0, size, 40, 30, -0.75, 0, true, true, delay2)
endfunction

// default delay2 = 0.9
function Fast_Attack takes unit u, unit target, real delay2 returns nothing
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetUnitX(target)
    local real end_y = GetUnitY(target)
    local real angle = Angle(x, y, end_x, end_y)
    local real delay = 0.0
    local real pre_delay = delay2 - 0.20
    local real anim_coef = pre_delay
    local real dist = 225
    local real size = 225
    local real eff_coef = (size / 225)
    local string eff = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"

    call SetUnitFacingTimed(u, angle, delay)
    call Delayed_Pre_Anim(u, 4, 20/pre_delay, pre_delay, 125, delay)
    call Area_Dmg_Attached(u, 100, dist, 0, size, true, delay2)
    call Effect_Attached(u, dist, 0, 100 * eff_coef, 100, 0, 0, 0, 0, angle, true, eff, delay2)
    call Knock_Back_Attached(u, dist, 0, size, 25, 25, -1, 0, true, true, delay2)
endfunction

function Jump_Attack takes unit u, unit target, real add returns nothing
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetUnitX(target)
    local real end_y = GetUnitY(target)
    local real dist = Dist(x, y, end_x, end_y) + add
    local real angle = Angle(x, y, end_x, end_y)
    local real v = dist / 60
    local real delay = 0.00
    local real delay2 = 0.40
    local real delay3 = 0.80
    local real delay4 = 1.20
    local integer tic = 60
    local string eff = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    
    if dist > 2000 then
        set dist = 2000
    endif
    
    call Unit_Jump(u, 42, -1.4, delay)
    call Unit_Motion(u, 11, 150, delay)
    call Set_Unit_Ex_Facing(u, angle, delay)
    call Unit_Move(u, tic, v, 0, angle, delay)
    call Effect_Attached(u, 0, angle, 100, 100, 0, 0, 0, 0, angle, false, eff, delay)
    
    call Unit_Motion(u, 11, 150, delay2)
    call Unit_Motion(u, 11, 150, delay3)

    call Area_Dmg_Attached(u, 100, 0, angle, 350, false, delay4)
    call Effect_Attached(u, 0, angle, 150, 100, 0, 0, 0, 0, angle, false, eff, delay4)
    call Knock_Back_Attached(u, 0, angle, 350, 40, 30, -0.75, angle, true, false, delay4)
endfunction

// default  v = 16
function Back_Step takes unit u, unit target, real v returns nothing
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetUnitX(target)
    local real end_y = GetUnitY(target)
    local real angle = Angle(x, y, end_x, end_y)
    local real delay = 0.00
    local real delay2 = 0.60
    local integer tic = 30
    local string eff = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    
    call Unit_Motion(u, 11, 100, delay)
    call Unit_Move(u, tic, v, 0, angle + 180, delay)
    call Set_Unit_Ex_Facing(u, angle, delay)
    call Unit_Jump(u, 30, -2, delay)
    call Area_Dmg_Attached(u, 100, 0, angle, 225, false, delay2)
    call Effect_Attached(u, 0, angle, 100, 100, 0, 0, 0, 0, angle, false, eff, delay2)
    call Knock_Back_Attached(u, 0, angle, 225, 25, 25, -1, angle, true, false, delay2)
endfunction

endlibrary