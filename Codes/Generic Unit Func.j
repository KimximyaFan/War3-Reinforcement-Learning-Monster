library GenericUnitFunc requires BaseFunc, BasicFunc, DmgText

// 마지막 인자는 null 필수 기입
function Get_Group takes unit u, real x, real y, real range, group h returns group
    local group g = CreateGroup()
    local unit c = null
    
    set h = CreateGroup()
    
    call GroupEnumUnitsInRange(g, x, y, range, null)
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            call GroupAddUnit(h, c)
        endif
    endloop
    call GroupClear(g)
    call DestroyGroup(g)
    set c = null
    set g = null
    return h
endfunction

private function Set_Unit_Ex_Facing_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real angle = LoadReal(HT, id, 1)
    
    call SetUnitFacing(u, angle)
    call EXSetUnitFacing(u, angle)
    
    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

function Set_Unit_Ex_Facing takes unit u, real angle, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, angle)
    call TimerStart(t, delay, false, function Set_Unit_Ex_Facing_Func)
    
    set t = null
endfunction

private function Set_Unit_Void_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    
    call UnitRemoveType(u, UNIT_TYPE_MECHANICAL)

    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

private function Set_Unit_Void_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real time = LoadReal(HT, id, 1)
    
    call UnitAddType(u, UNIT_TYPE_MECHANICAL)
    
    call TimerStart(t, time, false, function Set_Unit_Void_Func2)
    
    set t = null
    set u = null
endfunction

function Set_Unit_Void takes unit u, real time, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, time)
    call TimerStart(t, delay, false, function Set_Unit_Void_Func)
    
    set t = null
endfunction

private function Unit_Jump_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real v = LoadReal(HT, id, 1)
    local real a = LoadReal(HT, id, 2)
    local location loc = GetUnitLoc(u)
    local real z = GetUnitFlyHeight(u) + GetLocationZ(loc) + v
    
    call SetUnitFlyHeight(u, GetUnitFlyHeight(u) + v, 0)
    
    set v = v + a
    
    if z < GetLocationZ(loc) then
        call Timer_Clear(t)
    else
        call SaveReal(HT, id, 1, v)
        call TimerStart(t, 0.02, false, function Unit_Jump_Func)
    endif
    
    call RemoveLocation(loc)
    set t = null
    set u = null
    set loc = null
endfunction
// (2 * v) / a = tic
// time = tic * 0.02
function Unit_Jump takes unit u, real v, real a, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call UnitAddAbility(u, 'Amrf')
    call UnitRemoveAbility(u, 'Amrf')
    
    if a >= 0 then
        set a = -a
    endif
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, v)
    call SaveReal(HT, id, 2, a)
    call TimerStart(t, delay, false, function Unit_Jump_Func)
    
    set t = null
endfunction

private function Unit_Move_Front_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer tic = LoadInteger(HT, id, 1)
    local integer i = LoadInteger(HT, id, 2) + 1
    local real v = LoadReal(HT, id, 3)
    local real a = LoadReal(HT, id, 4)
    local real angle = GetUnitFacing(u)
    local real x = Polar_X(GetUnitX(u), v, angle)
    local real y = Polar_Y(GetUnitY(u), v, angle)
    
    set v = v + a
    
    if IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) == false then
        call SetUnitX( u, x )
        call SetUnitY( u, y )
    else
        set i = tic
    endif
    
    if i >= tic then
        call Timer_Clear(t)
    else
        call SaveInteger(HT, id, 2, i)
        call SaveReal(HT, id, 3, v)
        call TimerStart(t, 0.02, false, function Unit_Move_Front_Func)
    endif
    
    set t = null
    set u = null
endfunction

function Unit_Move_Front takes unit u, integer tic, real v, real a, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, tic)
    call SaveInteger(HT, id, 2, 0)
    call SaveReal(HT, id, 3, v)
    call SaveReal(HT, id, 4, a)
    
    call TimerStart(t, delay, false, function Unit_Move_Front_Func)
    
    set t = null
endfunction

private function Unit_Move_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer tic = LoadInteger(HT, id, 1)
    local integer i = LoadInteger(HT, id, 2) + 1
    local real v = LoadReal(HT, id, 3)
    local real a = LoadReal(HT, id, 4)
    local real angle = LoadReal(HT, id, 5)
    local real x = Polar_X(GetUnitX(u), v, angle)
    local real y = Polar_Y(GetUnitY(u), v, angle)
    
    set v = v + a
    
    if IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) == false then
        call SetUnitX( u, x )
        call SetUnitY( u, y )
    else
        set i = tic
    endif
    
    if i >= tic then
        call Timer_Clear(t)
    else
        call SaveInteger(HT, id, 2, i)
        call SaveReal(HT, id, 3, v)
        call TimerStart(t, 0.02, false, function Unit_Move_Func)
    endif
    
    set t = null
    set u = null
endfunction

function Unit_Move takes unit u, integer tic, real v, real a, real angle, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, tic)
    call SaveInteger(HT, id, 2, 0)
    call SaveReal(HT, id, 3, v)
    call SaveReal(HT, id, 4, a)
    call SaveReal(HT, id, 5, angle)
    
    call TimerStart(t, delay, false, function Unit_Move_Func)
    
    set t = null
endfunction

private function Knock_Back_Attached_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, -1)
    local integer tic = LoadInteger(HT, id, 0)
    local real dist = LoadReal(HT, id, 1)
    local real angle = LoadReal(HT, id, 2)
    local real size = LoadReal(HT, id, 3)
    local real v = LoadReal(HT, id, 4)
    local real a = LoadReal(HT, id, 5)
    local real knock_angle = LoadReal(HT, id, 6)
    local boolean isSpread = LoadBoolean(HT, id, 7)
    local boolean isFacing = LoadBoolean(HT, id, 8)
    local group g = CreateGroup()
    local unit c
    local real x
    local real y
    
    if isFacing == true then
        set angle = GetUnitFacing(u) + angle
    endif
    
    set x = Polar_X(GetUnitX(u), dist, angle)
    set y = Polar_Y(GetUnitY(u), dist, angle)

    call GroupEnumUnitsInRange( g, x, y, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            if isSpread == true then
                set knock_angle = Angle(x, y, GetUnitX(c), GetUnitY(c))
            endif

            call Unit_Move(c, tic, v, a, knock_angle, 0.0)
        endif
    endloop
    
    call Timer_Clear(t)
    call Group_Clear(g)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction
// isSpread 체크하면 knock_angle값에 상관없이 방사형 넉백
// isFacing이 true라면 angle은 add_angle로써 작동하게된다
function Knock_Back_Attached takes unit u, real dist, real angle, real size, integer tic, real v, real a, real knock_angle, /*
*/ boolean isSpread, boolean isFacing, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, -1, u)
    call SaveInteger(HT, id, 0, tic)
    call SaveReal(HT, id, 1, dist)
    call SaveReal(HT, id, 2, angle)
    call SaveReal(HT, id, 3, size)
    call SaveReal(HT, id, 4, v)
    call SaveReal(HT, id, 5, a)
    call SaveReal(HT, id, 6, knock_angle)
    call SaveBoolean(HT, id, 7, isSpread)
    call SaveBoolean(HT, id, 8, isFacing)
    
    call TimerStart(t, delay, false, function Knock_Back_Attached_Func)
    
    set t = null
endfunction

private function Knock_Back_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, -1)
    local integer tic = LoadInteger(HT, id, 0)
    local real x = LoadReal(HT, id, 1)
    local real y = LoadReal(HT, id, 2)
    local real size = LoadReal(HT, id, 3)
    local real v = LoadReal(HT, id, 4)
    local real a = LoadReal(HT, id, 5)
    local real angle = LoadReal(HT, id, 6)
    local boolean isSpread = LoadBoolean(HT, id, 7)
    local group g = CreateGroup()
    local unit c

    call GroupEnumUnitsInRange( g, x, y, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            if isSpread == true then
                set angle = Angle(x, y, GetUnitX(c), GetUnitY(c))
            endif

            call Unit_Move(c, tic, v, a, angle, 0.0)
        endif
    endloop
    
    call Timer_Clear(t)
    call Group_Clear(g)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction
// isSpread 체크하면 angle값에 상관없이 방사형 넉백 
function Knock_Back takes unit u, real x, real y, real size, integer tic, real v, real a, real angle, boolean isSpread, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, -1, u)
    call SaveInteger(HT, id, 0, tic)
    call SaveReal(HT, id, 1, x)
    call SaveReal(HT, id, 2, y)
    call SaveReal(HT, id, 3, size)
    call SaveReal(HT, id, 4, v)
    call SaveReal(HT, id, 5, a)
    call SaveReal(HT, id, 6, angle)
    call SaveBoolean(HT, id, 7, isSpread)
    
    call TimerStart(t, delay, false, function Knock_Back_Func)
    
    set t = null
endfunction

private function Unit_Rotate_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real time = LoadReal(HT, id, 1)
    local real interval = LoadReal(HT, id, 2)
    local real start_angle = LoadReal(HT, id, 3)
    local real d_angle = LoadReal(HT, id, 4)
    
    set start_angle = start_angle + d_angle
    set time = time - interval
    
    call SetUnitFacingTimed(u, start_angle, 0.0)
    
    if time <= 0 then
        call Timer_Clear(t)
    else
        call SaveReal(HT, id, 1, time)
        call SaveReal(HT, id, 3, start_angle)
    endif
    
    set t = null
    set u = null
endfunction

private function Unit_Rotate_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real interval = LoadReal(HT, id, 2)
    local real start_angle = LoadReal(HT, id, 3)
    
    //call SetUnitFacingTimed(u, start_angle, 0.0)
    call EXSetUnitFacing(u, start_angle)
    
    call TimerStart( t, interval, true, function Unit_Rotate_Func2 )
    
    set t = null
    set u = null
endfunction

function Unit_Rotate takes unit u, real time, real interval, real start_angle, real d_angle, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, time)
    call SaveReal(HT, id, 2, interval)
    call SaveReal(HT, id, 3, start_angle)
    call SaveReal(HT, id, 4, d_angle)
    call TimerStart( t, delay, false, function Unit_Rotate_Func )
    
    set t = null
endfunction

function Area_Dmg_Attached_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dmg = LoadReal(HT, id, 1)
    local real dist = LoadReal(HT, id, 2)
    local real angle = LoadReal(HT, id, 3)
    local real size = LoadReal(HT, id, 4)
    local boolean isFacing = LoadBoolean(HT, id, 5)
    local group g = CreateGroup()
    local real x
    local real y
    local unit c
    
    if isFacing == true then
        set angle = GetUnitFacing(u) + angle
    endif
    
    set x = Polar_X(GetUnitX(u), dist, angle)
    set y = Polar_Y(GetUnitY(u), dist, angle)
    
    call GroupEnumUnitsInRange( g, x, y, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            if IsUnitType(c, UNIT_TYPE_MECHANICAL) == false then
                set USER_ATTACKED = true
                call UnitDamageTargetBJ( u, c, dmg, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_NORMAL )
            else
                call Dmg_Text(c, 0)
            endif
        endif
    endloop
    
    call Group_Clear(g)
    call Timer_Clear(t)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction
// isFacing == true 라면 angle은 add_angle로 작동한다
function Area_Dmg_Attached takes unit u, real dmg, real dist, real angle, real size, boolean isFacing, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dmg)
    call SaveReal(HT, id, 2, dist)
    call SaveReal(HT, id, 3, angle)
    call SaveReal(HT, id, 4, size)
    call SaveBoolean(HT, id, 5, isFacing)
    
    call TimerStart(t, delay, false, function Area_Dmg_Attached_Func)
    
    set t = null
endfunction

function X_Y_Dmg_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dmg = LoadReal(HT, id, 1)
    local real x = LoadReal(HT, id, 2)
    local real y = LoadReal(HT, id, 3)
    local real size = LoadReal(HT, id, 4)
    local group g = CreateGroup()
    local unit c
    
    call GroupEnumUnitsInRange( g, x, y, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            call UnitDamageTargetBJ( u, c, dmg, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_NORMAL )
        endif
    endloop
    
    call Group_Clear(g)
    call Timer_Clear(t)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction

function X_Y_Dmg takes unit u, real dmg, real x, real y, real size, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dmg)
    call SaveReal(HT, id, 2, x)
    call SaveReal(HT, id, 3, y)
    call SaveReal(HT, id, 4, size)
    
    call TimerStart(t, delay, false, function X_Y_Dmg_Func)
    
    set t = null
endfunction

function Delayed_Pre_Anim_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandleBJ(0, id, HT)
    local integer motion = LoadIntegerBJ(1, id, HT)
    local real postAniSpeed = LoadRealBJ(4, id, HT)
    
    if IsUnitAliveBJ(u) == false then
        call DestroyTimer(t)
        call FlushChildHashtableBJ(id, HT)
        set t = null
        set u = null
        return
    endif
    
    call SetUnitTimeScalePercent( u, postAniSpeed )
    
    call DestroyTimer(t)
    call FlushChildHashtableBJ(id, HT)
    
    set t = null
    set u = null
endfunction

function Delayed_Pre_Anim_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandleBJ(0, id, HT)
    local integer motion = LoadIntegerBJ(1, id, HT)
    local real preAniSpeed = LoadRealBJ(2, id, HT)
    local real preTime = LoadRealBJ(3, id, HT)
    
    if IsUnitAliveBJ(u) == false then
        call DestroyTimer(t)
        call FlushChildHashtableBJ(id, HT)
        set t = null
        set u = null
        return
    endif
    
    call SetUnitTimeScalePercent( u, preAniSpeed )
    call SetUnitAnimationByIndex( u, motion )
    
    call TimerStart(t, preTime, false, function Delayed_Pre_Anim_Func2)
    
    set t = null
    set u = null
endfunction

function Delayed_Pre_Anim takes unit u, integer motion, real preAniSpeed, real preTime, real postAniSpeed, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandleBJ(u, 0, id, HT)
    call SaveIntegerBJ(motion, 1, id, HT)
    call SaveRealBJ(preAniSpeed, 2, id, HT)
    call SaveRealBJ(preTime, 3, id, HT)
    call SaveRealBJ(postAniSpeed, 4, id, HT)
    
    call TimerStart(t, delay, false, function Delayed_Pre_Anim_Func)
    
    set t = null
endfunction

function Delayed_Target_Time_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandleBJ(0, id, HT)
    local unit c = LoadUnitHandleBJ(1, id, HT)
    local integer tic = LoadIntegerBJ(2, id, HT)
    local integer i = LoadIntegerBJ(3, id, HT) + 1
    local location loc = GetUnitLoc(u)
    local location loc2 = GetUnitLoc(c)
    local real angle = AngleBetweenPoints(loc, loc2)
    
    call SetUnitFacingTimed( u, angle, 0 )
    
    if i >= tic or IsUnitAliveBJ(u) == false or IsUnitAliveBJ(c) == false then
        call PauseTimer(t)
        call DestroyTimer(t)
        call FlushChildHashtableBJ(id, HT)
    else
        call SaveIntegerBJ(i, 3, id, HT)
    endif
    
    call RemoveLocation(loc)
    call RemoveLocation(loc2)
    set t = null
    set u = null
    set c = null
    set loc = null
    set loc2 = null
endfunction

function Delayed_Target_Time_Func takes nothing returns nothing
    call TimerStart(GetExpiredTimer(), 0.05, true, function Delayed_Target_Time_Func2 )
endfunction

function Delayed_Target_Time takes unit u, unit c, real time, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandleBJ(u, 0, id, HT)
    call SaveUnitHandleBJ(c, 1, id, HT)
    call SaveIntegerBJ(R2I(time/0.05), 2, id, HT)
    call SaveIntegerBJ(0, 3, id, HT)
    
    call TimerStart(t, delay, false, function Delayed_Target_Time_Func )
    
    set t = null
endfunction

function Effect_Attached_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dist = LoadReal(HT, id, 1)
    local real angle = LoadReal(HT, id, 2)
    local real eff_size = LoadReal(HT, id, 3)
    local real eff_speed = LoadReal(HT, id, 4)
    local real eff_height = LoadReal(HT, id, 5)
    local real eff_time = LoadReal(HT, id, 6)
    local real pitch = LoadReal(HT, id, 7)
    local real roll = LoadReal(HT, id, 8)
    local real yaw = LoadReal(HT, id, 9)
    local boolean isFacing = LoadBoolean(HT, id, 10)
    local string eff = LoadStr(HT, id, 11)    
    local real x
    local real y
    local effect e
    
    if isFacing == true then
        set angle = GetUnitFacing(u) + angle
        set yaw = angle
    endif
    
    set x = Polar_X(GetUnitX(u), dist, angle)
    set y = Polar_Y(GetUnitY(u), dist, angle)
    
    set e = AddSpecialEffect(eff, x, y)
    call EXSetEffectSize(e, eff_size/100)
    call EXSetEffectSpeed(e, eff_speed/100)
    call EXEffectMatRotateZ(e, yaw)
    call EXEffectMatRotateY(e, pitch)
    call EXEffectMatRotateX(e, roll)
    call EXEffectMatRotateZ(e, yaw)
    call EXSetEffectZ(e, EXGetEffectZ(e) + eff_height)
    
    call Effect_Destroy(e, eff_time)
    call Timer_Clear(t)
    
    set t = null
    set u = null
    set e = null
endfunction
// isFacing이 true라면 angle은 add_angle로써 작동하게된다
function Effect_Attached takes unit u, real dist, real angle, real eff_size, real eff_speed, real eff_height, real eff_time, real pitch, real roll, real yaw, /*
*/ boolean isFacing, string eff, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dist)
    call SaveReal(HT, id, 2, angle)
    call SaveReal(HT, id, 3, eff_size)
    call SaveReal(HT, id, 4, eff_speed)
    call SaveReal(HT, id, 5, eff_height)
    call SaveReal(HT, id, 6, eff_time)
    call SaveReal(HT, id, 7, pitch)
    call SaveReal(HT, id, 8, roll)
    call SaveReal(HT, id, 9, yaw)
    call SaveBoolean(HT, id, 10, isFacing)
    call SaveStr(HT, id, 11, eff)
    
    call TimerStart(t, delay, false, function Effect_Attached_Func)
    
    set t = null
endfunction

function Area_Dmg_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dmg = LoadReal(HT, id, 1)
    local real dist = LoadReal(HT, id, 2)
    local real angle = LoadReal(HT, id, 3)
    local real size = LoadReal(HT, id, 4)
    local real x = Polar_X( GetUnitX(u), dist, angle )
    local real y = Polar_Y( GetUnitY(u), dist, angle )
    local group g = CreateGroup()
    local unit c
    
    call GroupEnumUnitsInRange( g, x, y, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            set MONSTER_ATTACKED = true
            call UnitDamageTargetBJ( u, c, dmg, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_NORMAL )
        endif
    endloop
    
    call Group_Clear(g)
    call Timer_Clear(t)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction

function Area_Dmg takes unit u, real dmg, real dist, real angle, real size, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dmg)
    call SaveReal(HT, id, 2, dist)
    call SaveReal(HT, id, 3, angle)
    call SaveReal(HT, id, 4, size)
    
    call TimerStart(t, delay, false, function Area_Dmg_Func)
    
    set t = null
endfunction

function Closest_Angle takes unit u, real size returns real
    local real angle = GetUnitFacing(u)
    local group g = CreateGroup()
    local location loc = GetUnitLoc(u)
    local location loc2 = null
    local location loc3 = PolarProjectionBJ(loc, size + 1000, angle)
    local unit c = null

    call GroupEnumUnitsInRangeOfLoc( g, loc, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            call RemoveLocation(loc2)
            set loc2 = GetUnitLoc(c)
            
            if DistanceBetweenPoints(loc, loc2) < DistanceBetweenPoints(loc, loc3) then
                call RemoveLocation(loc3)
                set loc3 = GetUnitLoc(c)
            endif
        endif
    endloop
    
    set angle = AngleBetweenPoints(loc, loc3)
    
    call RemoveLocation(loc)
    call RemoveLocation(loc2)
    call RemoveLocation(loc3)
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set c = null
    set loc = null
    set loc2 = null
    set loc3 = null
    return angle
endfunction

function Effect_Create_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dist = LoadReal(HT, id, 1)
    local real angle = LoadReal(HT, id, 2)
    local string eff = LoadStr(HT, id, 3)
    local real x = Polar_X( GetUnitX(u), dist, angle )
    local real y = Polar_Y( GetUnitY(u), dist, angle )
    
    call DestroyEffect( AddSpecialEffect(eff, x, y) )
    
    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

function Effect_Create takes unit u, real dist, real angle, string eff, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dist)
    call SaveReal(HT, id, 2, angle)
    call SaveStr(HT, id, 3, eff)
    
    call TimerStart(t, delay, false, function Effect_Create_Func)
    
    set t = null
endfunction

function Unit_Motion_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer motion = LoadInteger(HT, id, 1)
    local real ani_speed = LoadReal(HT, id, 2)
    
    call SetUnitAnimationByIndex( u, motion )
    call SetUnitTimeScalePercent( u, ani_speed )
    
    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

function Unit_Motion takes unit u, integer motion, real ani_speed, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, motion)
    call SaveReal(HT, id, 2, ani_speed)
    
    call TimerStart(t, delay, false, function Unit_Motion_Func)
    
    set t = null
endfunction

endlibrary