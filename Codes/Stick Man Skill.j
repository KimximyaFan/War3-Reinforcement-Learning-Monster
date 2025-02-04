library StickManSkill requires GenericUnitFunc, HeroFunc

private function Stick_Man_Q takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real angle = Closest_Angle(u, 400)
    local real dmg = 40
    local real delay = 0.20
    local integer motion = 4
    
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, 0.35, 0.01)
    call Unit_Motion(u, motion, 150, 0.01)
    call Area_Dmg(u, dmg, 175, angle, 175, delay)
    call Effect_Attached(u, 175, angle, 100, 100, 75, 0.0, 0, 0, angle, false, "A_0001.mdx", delay)

    set u = null
endfunction

private function Stick_Man_D takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local real angle = Angle(x, y , end_x, end_y)
    
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Set_Unit_Void(u, 0.35, 0.01)
    call Hero_Pause(u, 0.35, 0.01)
    call Unit_Motion(u, 131, 200, 0.01)
    call Unit_Move(u, 5, 40, 0, angle, 0.01)
    call Unit_Move(u, 10, 22, -2, angle, 0.13)
    
    set u = null
endfunction

private function Q_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A002'
endfunction

private function D_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A000'
endfunction

function Stick_Man_Skill_Init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( trg, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function D_Con ) )
    call TriggerAddAction( trg, function Stick_Man_D )
    
    set trg = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( trg, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function Q_Con ) )
    call TriggerAddAction( trg, function Stick_Man_Q )
    
    set trg = null
endfunction

endlibrary