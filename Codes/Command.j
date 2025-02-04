scope Command initializer Init

private function View takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local string str = GetEventPlayerChatString()
    local integer value = S2I( SubString(str, 8, StringLength(str)) )
    
    if value < 80 or value > 150 then
        return
    endif
    
    call SetCameraFieldForPlayer( p, CAMERA_FIELD_TARGET_DISTANCE, 20 * value, 0.25 )
    
    set p = null
endfunction

private function Init takes nothing returns nothing
    local integer i
    local trigger trg
    
    // 시야
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 3
        set trg = CreateTrigger()
        call TriggerRegisterPlayerChatEvent(trg, Player(i), "-시야", false)
        call TriggerAddAction( trg, function View )
    endloop

    set trg = null
endfunction

endscope