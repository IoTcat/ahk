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


