scope MapStart initializer Init

globals
    private timer t = CreateTimer()
    
    private real interval_0 = 4.5
    private real interval_1 = 2.5
    
    private boolean is_Test = false
endglobals

private function Set_View_Distance takes nothing returns nothing
    local integer i
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 3
        call SetCameraFieldForPlayer( Player(i), CAMERA_FIELD_TARGET_DISTANCE, 20 * 100, 0.25 )
    endloop
endfunction

private function Battle_Net_Check takes nothing returns boolean
    if is_Test == true then
        return true
    endif
    
    if JNGetConnectionState() == 1112425812 then
        return true
    else
        return false
    endif
endfunction

private function Map_Start_1 takes nothing returns nothing
    call FogEnableOff()
    call FogMaskEnableOff()
    
    call TimerStart(t, interval_1, false, function Game_Start)
endfunction

private function Map_Start_0 takes nothing returns nothing
    if Battle_Net_Check() == false then
        call Msg("배틀넷 환경 필요 \n\n", 0.0)
        return
    endif
    
    call Set_View_Distance()
    

    call Msg("강화학습 몬스터 \n\n", 0.0)
    call Msg("플레이어는 보스와 1:1로 싸운다 \n\n", 2.5)
    call Msg("Q는 공격, D는 대쉬인데 0.35초간 무적 \n\n", 4.5)
    
    call TimerStart(t, interval_0, false, function Map_Start_1)
endfunction

private function Init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger()
    call TriggerRegisterTimerEvent(trg, 0.00, false)
    call TriggerAddAction(trg, function Map_Start_0)
    
    set trg = null
endfunction

endscope