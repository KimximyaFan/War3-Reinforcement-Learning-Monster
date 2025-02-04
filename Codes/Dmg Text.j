library DmgText requires BaseFunc

function Dmg_Text takes unit target, real dmg returns nothing
    local string str
    local string str2
    local integer strL
    local integer loopA = 0
    local real tempX
    local real tempY
    local string type_str
    local string eff
    local real x = GetUnitX(target)
    local real y = GetUnitY(target)
    
    set type_str = "White"
    
    set str = I2S(R2I(dmg + 0.0001))
    set strL = JNStringLength(str)
    
    loop
    exitwhen loopA >= strL
        set loopA = loopA + 1
        set str2 = SubString(str,loopA-1,loopA)

        set tempX = x - (25 * (loopA-1) * Cos( 180 * bj_DEGTORAD ))
        set tempY = y - (25 * (loopA-1) * Sin( 180 * bj_DEGTORAD ))
        
        set eff = "Dmg Text " + type_str + " " + str2 + ".mdx"
        
        call DestroyEffect( AddSpecialEffect(eff, tempX, tempY) )
    endloop
endfunction

endlibrary