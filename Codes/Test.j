scope Test initializer Init

globals 
    private unit motion_unit
    integer global_motion = 0
endglobals

private function Check_Q_Table takes nothing returns nothing
    local string str = GetEventPlayerChatString()
    local integer state = S2I(JNStringSplit(str, " ", 1))
    local integer i
    
    set str = ""
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= number_of_actions
        set str = str + R2S(Get_Q_Value(state, i)) + " "
    endloop
    
    call BJDebugMsg(str)
endfunction

private function Set_Motion takes nothing returns nothing
    local string str = GetEventPlayerChatString()
    local integer motion = S2I(JNStringSplit(str, " ", 1))
    
    set global_motion = motion
    call BJDebugMsg(I2S(motion) + " 번 모션 세팅됨")
endfunction

private function Play_Motion takes nothing returns nothing
    local string str = GetEventPlayerChatString()
    local integer motion = S2I(JNStringSplit(str, " ", 1))
    
    call SetUnitAnimationByIndex(motion_unit, motion)
    call BJDebugMsg(I2S(motion) + " 번 모션 재생함")
endfunction

private function Set_Motion_Unit takes nothing returns nothing
    set motion_unit = GetTriggerUnit()
    call BJDebugMsg("선택됨")
endfunction

private function Init takes nothing returns nothing
    local trigger trg
    /*
    set trg = CreateTrigger(  )
    call TriggerRegisterPlayerSelectionEventBJ( trg, Player(0), true )
    call TriggerAddAction( trg, function Set_Motion_Unit )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( trg, Player(0), "-motion ", false )
    call TriggerAddAction( trg, function Play_Motion )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( trg, Player(0), "-set_motion ", false )
    call TriggerAddAction( trg, function Set_Motion )
    */
    
    set trg = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( trg, Player(0), "-check_q_table ", false )
    call TriggerAddAction( trg, function Check_Q_Table )
    
    set trg = null
endfunction

endscope