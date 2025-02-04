library DmgEngineRegister initializer Init requires BaseFunc, DmgText

function Dmg_Event_Occured takes nothing returns nothing
    local unit target = GetTriggerUnit()
    local real dmg = GetEventDamage()
    
    call Dmg_Text(target, dmg)
    
    set target = null
endfunction


private function Init takes nothing returns nothing
    call DERegisterAnyUnitHitEvent(function Dmg_Event_Occured)
endfunction

endlibrary