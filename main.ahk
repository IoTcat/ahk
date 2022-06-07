;Volume control, Alt+Scroll wheel (and Mbutton)
Alt & WheelUp::Volume_Up
Alt & WheelDown::Volume_Down
Alt & MButton::Volume_Mute



^!H::GoSub,CheckActiveWindow
CheckActiveWindow:
ID := WinExist("A")
WinGetClass,Class, ahk_id %ID%
WClasses := "CabinetWClass ExploreWClass"
IfInString, WClasses, %Class%
GoSub, Toggle_HiddenFiles_Display
Return
 
Toggle_HiddenFiles_Display:
RootKey = HKEY_CURRENT_USER
SubKey = Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
 
RegRead, HiddenFiles_Status, % RootKey, % SubKey, Hidden
 
if HiddenFiles_Status = 2
RegWrite, REG_DWORD, % RootKey, % SubKey, Hidden, 1
else
RegWrite, REG_DWORD, % RootKey, % SubKey, Hidden, 2
PostMessage, 0x111, 41504,,, ahk_id %ID%
Return



; Google Search highlighted text
^+c::
{
 Send, ^c
 Sleep 50
 Run, http://www.google.com/search?q=%clipboard%
 Return
}




; Empty trash
#Del::FileRecycleEmpty ; win + del
return




; Always on Top
^SPACE:: Winset, Alwaysontop, , A ; ctrl + space
Return



;Suspend hotkeys
!s::
suspend, toggle
return



; Drag window anywhere
Capslock & LButton::
    CoordMode, Mouse
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, % wTitle := "ahk_id " EWD_MouseWin
    mv_mode = mv
    SetTimer, EWD_WatchMouse, 10
return

; Resize window
Capslock & RButton::
    CoordMode, Mouse
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    WinGetPos, ,, EWD_OriginalPosX, EWD_OriginalPosY, % wTitle := "ahk_id " EWD_MouseWin
    mv_mode = sz
    SetTimer, EWD_WatchMouse, 10
return

; Drag window if LButton+RButton
#If GetKeyState("LButton", "P")
RButton::
    CoordMode, Mouse
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    While GetKeyState("RButton", "P") {
        WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, % wTitle := "ahk_id " EWD_MouseWin
        mv_mode = mv
        SetTimer, EWD_WatchMouse, 10
        Send {Esc}
    }
return
#If

; Resize window if RButton+LButton
#If GetKeyState("RButton", "P")
LButton::
    CoordMode, Mouse
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    While GetKeyState("LButton", "P") {
        WinGetPos, ,, EWD_OriginalPosX, EWD_OriginalPosY, % wTitle := "ahk_id " EWD_MouseWin
        mv_mode = sz
        SetTimer, EWD_WatchMouse, 10
        KeyWait, Rbutton ;As soon as RButton is released...
        Send {Esc}  ;... kill the context menu
    }
return
#If

; Function for move and resize windows
EWD_WatchMouse:
    CoordMode, Mouse
    MouseGetPos, EWD_MouseX, EWD_MouseY
    SetWinDelay, -1   ; Makes the below move faster/smoother.
    if mv_mode = mv 
    {
        GetKeyState, EWD_MButtonState, LButton, P
        WinGetPos, EWD_WinX, EWD_WinY,,, %wTitle%
        WinMove, %wTitle%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
    }
    if mv_mode = sz 
    {
        GetKeyState, EWD_MButtonState, RButton, P
        WinGetPos, ,, Width, Height, %wTitle%
        WinMove, %wTitle%,,,, Width + EWD_MouseX - EWD_MouseStartX, Height + EWD_MouseY - EWD_MouseStartY
    }
    if EWD_MButtonState = U 
    {
        SetTimer, EWD_WatchMouse, off
        return
    }
    EWD_MouseStartX := EWD_MouseX
    EWD_MouseStartY := EWD_MouseY
    WinActivate %wTitle%
return


