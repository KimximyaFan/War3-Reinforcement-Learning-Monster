library ReinforcementLearning requires BloodGolemActions, DataServer

globals

    hashtable Q_Table = InitHashtable()

    private real alpha = 0.4
    private real gamma = 0.99
    private real epsilon = 0.5
    
    real total_reward = 0
    
    integer number_of_states = 42
    integer number_of_actions = 10
    
    // States
    boolean USER_ATTACKED = false
    boolean MONSTER_ATTACKED = false
    
    private integer DIST_200 = 0
    private integer DIST_300 = 1
    private integer DIST_400 = 2
    private integer DIST_500 = 3
    private integer DIST_600 = 4
    private integer DIST_700 = 5
    private integer DIST_800 = 6
    private integer DIST_900 = 7
    private integer DIST_1000 = 8
    private integer DIST_FAR = 9
    
    integer USER_WIN = 40
    integer MONSTER_WIN = 41
    
    // Actions
    integer BACK_STEP_1 = 0
    integer JUMP_ATTACK_1 = 1
    integer FAST_ATTACK_1 = 2
    integer CENTER_ATTACK_1 = 3
    integer BIG_ATTACK_1 = 4
    
    integer BACK_STEP_2 = 5
    integer JUMP_ATTACK_2 = 6
    integer FAST_ATTACK_2 = 7
    integer CENTER_ATTACK_2 = 8
    integer BIG_ATTACK_2 = 9
        
    private integer current_state = -1
    private integer current_action = -1
    private real current_reward = -1
    
    private integer before_state = -1
    private integer before_action = -1
    private real before_reward = -1
    
    private unit user
    private unit monster
    
endglobals

function Is_Final_State takes nothing returns boolean
    return current_state == USER_WIN or current_state == MONSTER_WIN
endfunction

function Get_State takes real dist returns integer
    local integer padding
    local integer state
    
    set before_state = current_state
    
    if IsUnitAliveBJ(user) == true and IsUnitAliveBJ(monster) == false then
        set state = USER_WIN
        set current_state = state
        return state
    elseif IsUnitAliveBJ(user) == false and IsUnitAliveBJ(monster) == true then
        set state = MONSTER_WIN
        set current_state = state
        return state
    elseif IsUnitAliveBJ(user) == false and IsUnitAliveBJ(monster) == false then
        set state = USER_WIN
        set current_state = state
        return state
    endif
    
    if USER_ATTACKED == false and MONSTER_ATTACKED == false then
        set padding = 0
    elseif USER_ATTACKED == false and MONSTER_ATTACKED == true then
        set padding = 10
    elseif USER_ATTACKED == true and MONSTER_ATTACKED == false then
        set padding = 20
    elseif USER_ATTACKED == true and MONSTER_ATTACKED == true then
        set padding = 30
    endif
    
    if dist <= 200 then
        set state = DIST_200 + padding
    elseif dist <= 300 then
        set state = DIST_300 + padding
    elseif dist <= 400 then
        set state = DIST_400 + padding
    elseif dist <= 500 then
        set state = DIST_500 + padding
    elseif dist <= 600 then
        set state = DIST_600 + padding
    elseif dist <= 700 then
        set state = DIST_700 + padding
    elseif dist <= 800 then
        set state = DIST_800 + padding
    elseif dist <= 900 then
        set state = DIST_900 + padding
    elseif dist <= 1000 then
        set state = DIST_1000 + padding
    else
        set state = DIST_FAR + padding
    endif
    
    set current_state = state
    
    return state
endfunction

function Get_Reward takes nothing returns real
    local real reward
    
    if IsUnitAliveBJ(user) == true and IsUnitAliveBJ(monster) == false then
        set reward = -10.0
        return reward
    elseif IsUnitAliveBJ(user) == false and IsUnitAliveBJ(monster) == true then
        set reward = 10.0
        return reward
    elseif IsUnitAliveBJ(user) == false and IsUnitAliveBJ(monster) == false then
        set reward = -10.0
        return reward
    endif
    
    if USER_ATTACKED == false and MONSTER_ATTACKED == false then
        set reward = 0.0
    elseif USER_ATTACKED == false and MONSTER_ATTACKED == true then
        set reward = -1.0
    elseif USER_ATTACKED == true and MONSTER_ATTACKED == false then
        set reward = 1.0
    elseif USER_ATTACKED == true and MONSTER_ATTACKED == true then
        set reward = 0.5
    endif
    
    return reward
endfunction

function Init_Q_Table takes nothing returns nothing
    local integer i
    local integer j
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= number_of_states
        set j = -1
        loop
        set j = j + 1
        exitwhen j >= number_of_actions
            call SaveReal(Q_Table, i, j, 0.0)
        endloop
    endloop
endfunction

function Get_Q_Value takes integer state, integer action returns real
    return LoadReal(Q_Table, state, action)
endfunction

function Set_Q_Value takes integer state, integer action, real value returns nothing
    call SaveReal(Q_Table, state, action, value)
endfunction

function Get_Max_Action takes integer state returns integer
    local integer i
    local integer max_action
    local real max_value
    
    set max_action = 0
    set max_value = Get_Q_Value(state, 0)
    
    set i = 0
    loop
    set i = i + 1
    exitwhen i >= number_of_actions
        if Get_Q_Value(state, i) > max_value then
            set max_action = i
            set max_value = Get_Q_Value(state, i)
        endif
    endloop
    
    return max_action
endfunction

function Epsilon_Greedy takes integer state returns integer
    local integer action
    
    set before_action = current_action
    
    if Is_Final_State() == true then
        set action = 0
    elseif GRR(0.0, 1.0) < epsilon then
        set action = GetRandomInt(0, number_of_actions-1)
    else
        set action = Get_Max_Action(state)
    endif
    
    set current_action = action
    
    return action
endfunction

function Update_Process takes nothing returns nothing
    local real value

    if before_state == -1 then
        return
    endif
    
    set before_reward = current_reward
    
    set current_reward = Get_Reward()
    
    set value = Get_Q_Value(before_state, before_action) + alpha * (before_reward + gamma * Get_Q_Value(current_state, current_action) - Get_Q_Value(before_state, before_action))
    call Set_Q_Value(before_state, before_action, value)
    
    set total_reward = total_reward + before_reward
    
    if Is_Final_State() == true then
        set value = Get_Q_Value(current_state, current_action) + alpha * (current_reward  - Get_Q_Value(before_state, before_action))
        call Set_Q_Value(current_state, current_action, value)
        set total_reward = total_reward + current_reward
    endif
endfunction

function Set_User_and_Monster takes unit u, unit target returns nothing
    set user = target
    set monster = u
endfunction

function Attacked_State_Init takes nothing returns nothing
    set USER_ATTACKED = false
    set MONSTER_ATTACKED = false
endfunction

function Variable_Init takes nothing returns nothing
    set total_reward = 0.0
    set current_state = -1
    set current_action = -1
    set current_reward = -1
    set before_state = -1
    set before_action = -1
    set before_reward = -1
endfunction

endlibrary