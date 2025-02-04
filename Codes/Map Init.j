scope MapInit initializer Init

function Player_Playing_Check takes player p returns boolean
    return GetPlayerController(p) == MAP_CONTROL_USER and GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING
endfunction

private function Player_Check takes nothing returns nothing
    local integer i = -1
    
    set Is_Player_Exist[0] = false
    set Is_Player_Exist[1] = false
    set Is_Player_Exist[2] = false
    set Is_Player_Exist[3] = false
    
    loop
    set i = i + 1
    exitwhen i > 3
        set Is_Player_Exist[i] = Player_Playing_Check(Player(i))
    endloop
endfunction

private function Frame_Init takes nothing returns nothing
    // 보유 자원량
    call DzFrameClearAllPoints(DzSimpleFrameFindByName("ResourceBarFrame", 0))
    call DzFrameSetAbsolutePoint(DzSimpleFrameFindByName("ResourceBarFrame", 0), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    
    // 미니맵, 미니맵 버튼들
    call DzFrameShow(DzFrameGetMinimap(), false)
    call DzFrameSetAbsolutePoint(DzFrameGetMinimapButton(0), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetMinimapButton(1), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetMinimapButton(2), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetMinimapButton(3), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetMinimapButton(4), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    
    // 유닛 상태창
    call DzFrameClearAllPoints(DzSimpleFrameFindByName("SimpleInfoPanelUnitDetail", 0))
    call DzFrameSetAbsolutePoint(DzSimpleFrameFindByName("SimpleInfoPanelUnitDetail", 0), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    
    // 명령창 아이콘
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(0, 0), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(0, 1), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(0, 2), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(0, 3), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(1, 0), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(1, 3), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(2, 1), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(2, 2), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(2, 3), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    
    call DzFrameEditBlackBorders(0, 0)
    
    call DzFrameSetScale(DzFrameGetCommandBarButton(2, 0), 0.95)
    call DzFrameSetScale(DzFrameGetCommandBarButton(2, 1), 0.95)
    call DzFrameSetScale(DzFrameGetCommandBarButton(2, 2), 0.95)
    call DzFrameSetScale(DzFrameGetCommandBarButton(2, 3), 0.95)
    call DzFrameSetScale(DzFrameGetCommandBarButton(1, 3), 0.95)
    
    call DzFrameSetScale(DzFrameGetCommandBarButton(1, 1), 0.95)
    call DzFrameSetScale(DzFrameGetCommandBarButton(1, 2), 0.95)
    // -----------------------------------------------------------
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(2, 0), 0, 0.310, 0.061)
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(2, 1), 0, 0.350, 0.061)
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(2, 2), 0, 0.390, 0.061)
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(2, 3), 0, 0.430, 0.061)
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(1, 3), 0, 0.470, 0.061)
    
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(1, 1), 0, 0.400, 0.105)
    call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(1, 2), 0, 0.440, 0.105)
endfunction

private function Map_Configuration takes nothing returns nothing
    call JNSetSyncDelay(20)
endfunction

private function Init takes nothing returns nothing
    call Frame_Init()
    call Map_Configuration()
    call Player_Check()
    call Blood_Golem_Init()
    call Stick_Man_Skill_Init()
endfunction

endscope