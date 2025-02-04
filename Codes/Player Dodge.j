scope PlayerDodge initializer Init

private function Player_Dodge takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    
    set Is_Player_Exist[pid] = false
    
    call Msg( I2S(pid) + " 번 플레이어 나감", 0.0)
    
    set p = null
endfunction

private function Init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerEventLeave( trg, Player(0) )
    call TriggerRegisterPlayerEventLeave( trg, Player(1) )
    call TriggerRegisterPlayerEventLeave( trg, Player(2) )
    call TriggerRegisterPlayerEventLeave( trg, Player(3) )
    call TriggerAddAction( trg, function Player_Dodge )
    
    set trg = null
endfunction

endscope