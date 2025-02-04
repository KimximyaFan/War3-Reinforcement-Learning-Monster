library BaseFunc

function GRR takes real lower, real upper returns real
    return GetRandomReal(lower, upper)
endfunction

function Mod takes integer dividend, integer divisor returns integer
    local integer modulus = dividend - (dividend / divisor) * divisor

    if (modulus < 0) then
        set modulus = modulus + divisor
    endif

    return modulus
endfunction

function Dist takes real x, real y, real end_x, real end_y returns real
    return SquareRoot( (end_x - x)*(end_x - x) + (end_y - y)*(end_y - y) )
endfunction

function Angle takes real x, real y, real end_x, real end_y returns real
    return bj_RADTODEG * Atan2( end_y - y, end_x - x )
endfunction

function Polar_Y takes real y,  real dist, real angle returns real
    return y + dist * Sin(angle * bj_DEGTORAD)
endfunction

function Polar_X takes real x, real dist, real angle returns real
    return x + dist * Cos(angle * bj_DEGTORAD)
endfunction

function Group_Clear takes group g returns nothing
    call GroupClear(g)
    call DestroyGroup(g)
endfunction

function Timer_Clear takes timer t returns nothing
    call FlushChildHashtable(HT, GetHandleId(t))
    call PauseTimer(t)
    call DestroyTimer(t)
endfunction

endlibrary