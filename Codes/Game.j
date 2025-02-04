library Game initializer Init requires BasicFunc

globals
    private string eff = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl"
    private timer t = CreateTimer()
    private integer player_ptr = -1
    private real user_start_x = -700
    private real user_start_y = -800
    
    private real monster_start_x = 450
    private real monster_start_y = 350
    
    private unit current_user
    
    private unit current_monster
    
    private trigger start_trg
endglobals

private function Game_Over takes nothing returns nothing
    call BJDebugMsg("게임 끝")
    return
endfunction

private function Start_Trigger_Execute takes nothing returns nothing
    call TriggerExecute(start_trg)
endfunction

function Game_End takes nothing returns nothing
    call Eff(GetUnitX(current_user), GetUnitY(current_user), eff, 0.0)
    call Eff(GetUnitX(current_monster), GetUnitY(current_monster), eff, 0.0)
    call RemoveUnit(current_user)
    call RemoveUnit(current_monster)

    call Msg("다음 게임을 준비합니다 \n\n", 0.0)
    
    call Save_Q_Table_String_To_Server()
    call TimerStart(t, 2.5, false, function Start_Trigger_Execute)
endfunction

private function Set_Battle takes nothing returns nothing
    
    
    call Msg( I2S(player_ptr + 1) + " 번 플레이어 시작! \n\n", 0.0)
    
    set current_user = CreateUnit(Player(player_ptr), 'h000', user_start_x, user_start_x, 45)
    call Eff(GetUnitX(current_user), GetUnitY(current_user), eff, 0.0)
    
    set current_monster = CreateUnit(Player(11), 'n000', monster_start_x, monster_start_y, 225)
    call Eff(GetUnitX(current_monster), GetUnitY(current_monster), eff, 0.0)
endfunction

function Game_Start takes nothing returns nothing
    set player_ptr = player_ptr + 1
    
    if player_ptr > 3 then
        call Game_Over()
        return
    endif
    
    if Is_Player_Exist[player_ptr] == true then
        call Load_Q_Table_String_From_Server()
        call Set_Battle()
    else    
        call Game_Start()
    endif
endfunction

private function Init takes nothing returns nothing
    set start_trg = CreateTrigger()
    call TriggerAddAction( start_trg, function Game_Start )
endfunction

endlibrary