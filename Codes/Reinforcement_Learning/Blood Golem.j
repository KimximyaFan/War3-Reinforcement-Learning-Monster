library BloodGolem requires BaseFunc, GenericUnitFunc, BloodGolemActions, Game, ReinforcementLearning

globals
    private trigger start_trg
endglobals

private function Routine_End takes nothing returns nothing
    call Game_End()
endfunction

private function Pattern_End takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer state
    
    call RemoveSavedHandle(HT, id, 1)
    
    if IsUnitAliveBJ(u) == false then
        set state = Get_State(0)
        call Epsilon_Greedy(state)
        call Update_Process()
        call Routine_End()
        call Timer_Clear(t)
    else
        call TriggerExecute(start_trg)
    endif
    
    set t = null
    set u = null
endfunction

private function Do_Action takes unit u, unit target, integer action returns real
    local real delay
    
    if action == BACK_STEP_1 then
        call Back_Step(u, target, -24)
        set delay = 1.8
    elseif action == JUMP_ATTACK_1 then
        call Jump_Attack(u, target, -100)
        set delay = 2.3
    elseif action == FAST_ATTACK_1 then
        call Fast_Attack(u, target, 0.8)
        set delay = 1.6
    elseif action == CENTER_ATTACK_1 then
        call Center_Attack(u, target, 1.1)
        set delay = 2.6
    elseif action == BIG_ATTACK_1 then
        call Big_Attack(u, target, 1.2)
        set delay = 2.3
        
    elseif action == BACK_STEP_2 then
        call Back_Step(u, target, 12)
        set delay = 1.8
    elseif action == JUMP_ATTACK_2 then
        call Jump_Attack(u, target, 100)
        set delay = 2.3
    elseif action == FAST_ATTACK_2 then
        call Fast_Attack(u, target, 1.0)
        set delay = 1.8
    elseif action == CENTER_ATTACK_2 then
        call Center_Attack(u, target, 1.5)
        set delay = 3.0
    elseif action == BIG_ATTACK_2 then
        call Big_Attack(u, target, 1.8)
        set delay = 2.9
    endif
    
    return delay
endfunction

private function Action_Selection takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local unit target = LoadUnitHandle(HT, id, 1)
    local real dist = Dist(GetUnitX(u), GetUnitY(u), GetUnitX(target), GetUnitY(target))
    local real delay = 0.00
    local integer state
    local integer action
    
    //call State_Debuging()
    
    set state = Get_State(dist)
    set action = Epsilon_Greedy(state)
    call Update_Process()
    
    call Attacked_State_Init()

    set delay = Do_Action(u, target, action)
    
    call TimerStart(t, delay, false, function Pattern_End)
    
    set t = null
    set u = null
    set target = null
endfunction

private function Pattern_Start takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local group g = Get_Group(u, GetUnitX(u), GetUnitY(u), 2500, null)
    local unit target
    local integer state
    
    if CountUnitsInGroup(g) == 0 then
        set state = Get_State(0)
        call Epsilon_Greedy(state)
        call Update_Process()
        call Routine_End()
        call Timer_Clear(t)
    else
        set target = FirstOfGroup(g)
        call SaveUnitHandle(HT, id, 1, target)
        call TimerStart(t, 0.01, false, function Action_Selection)
    endif
    
    call Group_Clear(g)
    
    set t = null
    set u = null
    set g = null
    set target = null
endfunction

private function Routine_Start takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local unit u = GetAttacker()
    local unit target = GetTriggerUnit()
    
    call PauseUnit(u, true)
    
    call Variable_Init()
    call Set_User_and_Monster(u, target)
    
    call SaveUnitHandle(HT, id, 0, u)
    call TimerStart(t, 0.01, false, function Pattern_Start)
    
    set t = null
    set u = null
endfunction

private function Unit_Type_Con takes nothing returns boolean
    return GetUnitTypeId(GetAttacker()) == 'n000'
endfunction

function Blood_Golem_Init takes nothing returns nothing
    local trigger trg
    
    call Init_Q_Table()
    
    set start_trg = CreateTrigger()
    call TriggerAddAction( start_trg, function Pattern_Start )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg, EVENT_PLAYER_UNIT_ATTACKED )
    call TriggerAddCondition(trg, function Unit_Type_Con)
    call TriggerAddAction( trg, function Routine_Start )
    
    set trg = null
endfunction

endlibrary