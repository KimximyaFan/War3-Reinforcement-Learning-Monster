library DataServer initializer Init requires BasicFunc

function Build_Q_Table_5 takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local string state_str
    local string action_str
    local integer i
    local integer j
    
    set i = 39
    loop
    set i = i + 1
    exitwhen i > 41
        set state_str = JNStringSplit(sync_data, "/", i - 40)
        
        set j = -1
        loop
        set j = j + 1
        exitwhen j >= 1
            set action_str = JNStringSplit(state_str, "#", j)
            
            call SaveReal(Q_Table, i, j, S2R(action_str))
        endloop
    endloop
endfunction

function Build_Q_Table_4 takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local string state_str
    local string action_str
    local integer i
    local integer j
    
    set i = 29
    loop
    set i = i + 1
    exitwhen i > 39
        set state_str = JNStringSplit(sync_data, "/", i - 30)
        
        set j = -1
        loop
        set j = j + 1
        exitwhen j >= number_of_actions
            set action_str = JNStringSplit(state_str, "#", j)
            
            call SaveReal(Q_Table, i, j, S2R(action_str))
        endloop
    endloop
endfunction

function Build_Q_Table_3 takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local string state_str
    local string action_str
    local integer i
    local integer j
    
    set i = 19
    loop
    set i = i + 1
    exitwhen i > 29
        set state_str = JNStringSplit(sync_data, "/", i - 20)
        
        set j = -1
        loop
        set j = j + 1
        exitwhen j >= number_of_actions
            set action_str = JNStringSplit(state_str, "#", j)
            
            call SaveReal(Q_Table, i, j, S2R(action_str))
        endloop
    endloop
endfunction

function Build_Q_Table_2 takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local string state_str
    local string action_str
    local integer i
    local integer j
    
    set i = 9
    loop
    set i = i + 1
    exitwhen i > 19
        set state_str = JNStringSplit(sync_data, "/", i - 10)
        
        set j = -1
        loop
        set j = j + 1
        exitwhen j >= number_of_actions
            set action_str = JNStringSplit(state_str, "#", j)
            
            call SaveReal(Q_Table, i, j, S2R(action_str))
        endloop
    endloop
endfunction

function Build_Q_Table_1 takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local string state_str
    local string action_str
    local integer i
    local integer j
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 9
        set state_str = JNStringSplit(sync_data, "/", i)
        
        set j = -1
        loop
        set j = j + 1
        exitwhen j >= number_of_actions
            set action_str = JNStringSplit(state_str, "#", j)
            
            call SaveReal(Q_Table, i, j, S2R(action_str))
        endloop
    endloop
endfunction

function Load_Q_Table_String_From_Server takes nothing returns nothing
    local string str
    local string str2
    local string str3
    local string str4
    local string str5
    
    call Msg("Load Q Table", 0.0)
    
    if Is_Player_Exist[0] == true then
        if GetLocalPlayer() == Player(0) then
            set str = JNGetLoadCode( MAP_ID, USER_ID, SECRET_KEY, CHARACTER_1 )
            call DzSyncData("load_1", str)
            
            set str2 = JNGetLoadCode( MAP_ID, USER_ID, SECRET_KEY, CHARACTER_2 )
            call DzSyncData("load_2", str2)
            
            set str3 = JNGetLoadCode( MAP_ID, USER_ID, SECRET_KEY, CHARACTER_3 )
            call DzSyncData("load_3", str3)
            
            set str4 = JNGetLoadCode( MAP_ID, USER_ID, SECRET_KEY, CHARACTER_4 )
            call DzSyncData("load_4", str4)
            
            set str5 = JNGetLoadCode( MAP_ID, USER_ID, SECRET_KEY, CHARACTER_5 )
            call DzSyncData("load_5", str5)
        endif
    else
        if GetLocalPlayer() == Player(3) then
            set str = JNGetLoadCode( MAP_ID, USER_ID, SECRET_KEY, CHARACTER_1 )
            call DzSyncData("load_1", str)
            
            set str2 = JNGetLoadCode( MAP_ID, USER_ID, SECRET_KEY, CHARACTER_2 )
            call DzSyncData("load_2", str2)
            
            set str3 = JNGetLoadCode( MAP_ID, USER_ID, SECRET_KEY, CHARACTER_3 )
            call DzSyncData("load_3", str3)
            
            set str4 = JNGetLoadCode( MAP_ID, USER_ID, SECRET_KEY, CHARACTER_4 )
            call DzSyncData("load_4", str4)
            
            set str5 = JNGetLoadCode( MAP_ID, USER_ID, SECRET_KEY, CHARACTER_5 )
            call DzSyncData("load_5", str5)
        endif
    endif
endfunction

function Build_Q_Table_String_5 takes nothing returns string
    local string str = ""
    local integer i
    local integer j

    set i = 39
    loop
    set i = i + 1
    exitwhen i > 41
        
        set j = -1
        loop
        set j = j + 1
        exitwhen j >= 1
            set str = str + R2S(LoadReal(Q_Table, i, j)) + "#"
        endloop
        
        set str = SubString(str, 0, StringLength(str) - 1)
        set str = str + "/"
    endloop
    
    set str = SubString(str, 0, StringLength(str) - 1)
    
    return str
endfunction

function Build_Q_Table_String_4 takes nothing returns string
    local string str = ""
    local integer i
    local integer j

    set i = 29
    loop
    set i = i + 1
    exitwhen i > 39
        
        set j = -1
        loop
        set j = j + 1
        exitwhen j >= number_of_actions
            set str = str + R2S(LoadReal(Q_Table, i, j)) + "#"
        endloop
        
        set str = SubString(str, 0, StringLength(str) - 1)
        set str = str + "/"
    endloop
    
    set str = SubString(str, 0, StringLength(str) - 1)
    
    return str
endfunction

function Build_Q_Table_String_3 takes nothing returns string
    local string str = ""
    local integer i
    local integer j

    set i = 19
    loop
    set i = i + 1
    exitwhen i > 29
        
        set j = -1
        loop
        set j = j + 1
        exitwhen j >= number_of_actions
            set str = str + R2S(LoadReal(Q_Table, i, j)) + "#"
        endloop
        
        set str = SubString(str, 0, StringLength(str) - 1)
        set str = str + "/"
    endloop
    
    set str = SubString(str, 0, StringLength(str) - 1)
    
    return str
endfunction

function Build_Q_Table_String_2 takes nothing returns string
    local string str = ""
    local integer i
    local integer j

    set i = 9
    loop
    set i = i + 1
    exitwhen i > 19
        
        set j = -1
        loop
        set j = j + 1
        exitwhen j >= number_of_actions
            set str = str + R2S(LoadReal(Q_Table, i, j)) + "#"
        endloop
        
        set str = SubString(str, 0, StringLength(str) - 1)
        set str = str + "/"
    endloop
    
    set str = SubString(str, 0, StringLength(str) - 1)
    
    return str
endfunction

function Build_Q_Table_String_1 takes nothing returns string
    local string str = ""
    local integer i
    local integer j
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 9
        
        set j = -1
        loop
        set j = j + 1
        exitwhen j >= number_of_actions
            set str = str + R2S(LoadReal(Q_Table, i, j)) + "#"
        endloop
        
        set str = SubString(str, 0, StringLength(str) - 1)
        set str = str + "/"
    endloop
    
    set str = SubString(str, 0, StringLength(str) - 1)
    
    return str
endfunction

function Save_Q_Table_String_To_Server takes nothing returns nothing
    local string str
    local string str2
    local string str3
    local string str4
    local string str5
    
    set str = Build_Q_Table_String_1()
    set str2 = Build_Q_Table_String_2()
    set str3 = Build_Q_Table_String_3()
    set str4 = Build_Q_Table_String_4()
    set str5 = Build_Q_Table_String_5()
    
    if Is_Player_Exist[0] == true then
        if GetLocalPlayer() == Player(0) then
            call JNSetSaveCode(MAP_ID, USER_ID, SECRET_KEY, CHARACTER_1, str)
            call JNSetSaveCode(MAP_ID, USER_ID, SECRET_KEY, CHARACTER_2, str2)
            call JNSetSaveCode(MAP_ID, USER_ID, SECRET_KEY, CHARACTER_3, str3)
            call JNSetSaveCode(MAP_ID, USER_ID, SECRET_KEY, CHARACTER_4, str4)
            call JNSetSaveCode(MAP_ID, USER_ID, SECRET_KEY, CHARACTER_5, str5)
            
            call JNMapServerLog(MAP_ID, SECRET_KEY, "2.6", R2S(total_reward))
        endif
    else
        if GetLocalPlayer() == Player(3) then
            call JNSetSaveCode(MAP_ID, USER_ID, SECRET_KEY, CHARACTER_1, str)
            call JNSetSaveCode(MAP_ID, USER_ID, SECRET_KEY, CHARACTER_2, str2)
            call JNSetSaveCode(MAP_ID, USER_ID, SECRET_KEY, CHARACTER_3, str3)
            call JNSetSaveCode(MAP_ID, USER_ID, SECRET_KEY, CHARACTER_4, str4)
            call JNSetSaveCode(MAP_ID, USER_ID, SECRET_KEY, CHARACTER_5, str5)
            
            call JNMapServerLog(MAP_ID, SECRET_KEY, "2.6", R2S(total_reward))
        endif
    endif
    
    call Msg("서버 저장", 0.0)
endfunction

private function Init takes nothing returns nothing
    local trigger trg
    
    // Load 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "load_1", false)
    call TriggerAddAction( trg, function Build_Q_Table_1 )
    
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "load_2", false)
    call TriggerAddAction( trg, function Build_Q_Table_2 )
    
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "load_3", false)
    call TriggerAddAction( trg, function Build_Q_Table_3 )
    
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "load_4", false)
    call TriggerAddAction( trg, function Build_Q_Table_4 )
    
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "load_5", false)
    call TriggerAddAction( trg, function Build_Q_Table_5 )
    
    set trg = null
endfunction

endlibrary