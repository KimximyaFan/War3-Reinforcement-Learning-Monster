library BasicFunc requires BaseFunc

globals
    private integer array ND_Size
    private integer array ND_ID
endglobals



private function Eff_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local real x = LoadReal(HT, id, 0)
    local real y = LoadReal(HT, id, 1)
    local string eff = LoadStr(HT, id, 2)
    
    call DestroyEffect( AddSpecialEffect(eff, x, y) )
    
    call Timer_Clear(t)
    
    set t = null
endfunction

function Eff takes real x, real y, string eff, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveReal(HT, id, 0, x)
    call SaveReal(HT, id, 1, y)
    call SaveStr(HT, id, 2, eff)
    call TimerStart(t, delay, false, function Eff_Func)
    
    set t = null
endfunction

private function Effect_Destroy_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local effect e = LoadEffectHandle(HT, id, 0)
    
    call DestroyEffect(e)

    call Timer_Clear(t)
    
    set t = null
    set e = null
endfunction

function Effect_Destroy takes effect e, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveEffectHandle(HT, id, 0, e)
    call TimerStart(t, delay, false, function Effect_Destroy_Func)
    
    set t = null
endfunction

function ND_Find takes player p, integer max returns real
    local integer i = 0
    local real degree = 0
    local real temp = 0
    
    loop
    set i = i + 1
    exitwhen i > max
        set temp = LoadRealBJ(1000 + i, GetHandleId(p), HT)

        if temp > degree then
            set degree = temp
        endif
    endloop

    return degree
endfunction

function ND_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local player p = LoadPlayerHandleBJ(0, id, HT)
    local integer current_ID = LoadIntegerBJ(1, id, HT)
    local integer n = GetConvertedPlayerId(p)
    
    set ND_Size[n] = ND_Size[n] - 1
    
    if ND_Size[n] == 0 then
        call CameraClearNoiseForPlayer( p )
        set ND_ID[n] = 0
    else
        call SaveRealBJ(0, 1000 + current_ID, GetHandleId(p), HT)
        call CameraSetEQNoiseForPlayer( p, ND_Find(p, ND_ID[n]) )
    endif
    
    call FlushChildHashtableBJ(id, HT)
    call DestroyTimer(t)

    set p = null
    set t = null
endfunction

function ND takes player p, real time, real degree returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local integer n = GetConvertedPlayerId(p)
    
    set ND_Size[n] = ND_Size[n] + 1
    set ND_ID[n] = ND_ID[n] + 1
    
    call SaveRealBJ(degree, 1000 + ND_ID[n], GetHandleId(p), HT)
    call SavePlayerHandleBJ(p, 0, id, HT)
    call SaveIntegerBJ(ND_ID[n], 1, id, HT)
    
    if degree + 0.0001 >= ND_Find(p, ND_ID[n]) then
        call CameraSetEQNoiseForPlayer( p, degree )
    endif
    
    call TimerStart(t, time, false, function ND_Func)
    
    set t = null
endfunction

function Delayed_ND_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local player p = LoadPlayerHandleBJ(0, id, HT)
    local real time = LoadRealBJ(1, id, HT)
    local real degree = LoadRealBJ(2, id, HT)
    
    call ND(p, time, degree)
    
    call DestroyTimer(t)
    call FlushChildHashtableBJ(id, HT)
    
    set t = null
    set p = null
endfunction

function Delayed_ND takes player p, real time, real degree, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SavePlayerHandleBJ(p, 0, id, HT)
    call SaveRealBJ(time, 1, id, HT)
    call SaveRealBJ(degree, 2, id, HT)
    
    call TimerStart(t, delay, false, function Delayed_ND_Func)
    
    set t = null
endfunction

function Delayed_Camera_Shake takes real x, real y, real time, real degree, real range, real delay returns nothing
    local group g = CreateGroup()
    local unit c = null
    
    call GroupEnumUnitsInRange(g, x, y, range, null)
    
    loop
    set c = FirstOfGroup(g)
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        if IsUnitType(c, UNIT_TYPE_HERO) == true then
            call Delayed_ND(GetOwningPlayer(c), time, degree, delay)
        endif
    endloop
    
    call GroupClear(g)
    call DestroyGroup(g)
    set g = null
    set c = null
endfunction

function Delayed_Sound_Eff_C_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local real x = LoadRealBJ(0, id, HT)
    local real y = LoadRealBJ(1, id, HT)
    local integer ID = LoadIntegerBJ(2, id, HT)
    local unit c = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'h00L', x, y, 0)
    
    call UnitApplyTimedLifeBJ( 0.25, 'BHwe', c )
    call UnitAddAbilityBJ( ID, c )
    call IssueImmediateOrderBJ( c, "thunderclap" )
    
    call DestroyTimer(t)
    call FlushChildHashtableBJ(id, HT)
    
    set t = null
    set c = null
endfunction

function Delayed_Sound_Eff_C takes real x, real y, integer ID, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveRealBJ(x, 0, id, HT)
    call SaveRealBJ(y, 1, id, HT)
    call SaveIntegerBJ(ID, 2, id, HT)
    
    call TimerStart(t, delay, false, function Delayed_Sound_Eff_C_Func)
    
    set t = null
endfunction


private function Msg_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local string str = LoadStr(HT, id, 0)
    local integer i = 0
    
    loop
        call DisplayTimedTextToPlayer(Player(i),0,0,10,str)
        set i = i + 1
        exitwhen i == bj_MAX_PLAYERS
    endloop
    
    call Timer_Clear(t)
    
    set t = null
endfunction

function Msg takes string str, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveStr(HT, id, 0, str)
    call TimerStart(t, delay, false, function Msg_Func)
    
    set t = null
endfunction


endlibrary