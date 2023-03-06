#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
CoordMode,Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen

SetWorkingDir, %A_ScriptDir%
#Include C:\ProgrammeUser\AHK_New\MyLibs 
#Include base.ahk
#Include googlesearch.ahk
#include KdeMouseMoveLib.ahk

Default__Warn(obs*)
{
    ListLines
 	
    Mos(callstack(),"A non-object value was improperly invoked.",obs)
	
}
"".base.__Get := "".base.__Set := "".base.__Call := Func("Default__Warn")

tt("hotkeys started")
Return

~^s::
Reload
Return

^!h::
Run, shutdown /h

MButton::
id:=getMouseWin()
;tt(getWinInfobase(id))
DllCall("SetWindowPos","UInt",id,"UInt",1 ,"Int",0,"Int",0,"Int",0,"Int",0,"UInt",SWP_NOACTIVATE() | SWP_NOMOVE() | SWP_NOSIZE() | SWP_NOREDRAW() | SWP_NOSENDCHANGING() )	 
Return


!LButton::
setScalingAware()
p:=mypoint.frommouse()
tick:=A_TickCount
kdeMouseMove("LButton","RButton")
duration:=A_TickCount-tick
p2:=mypoint.frommouse()
if (p.isEqual(p2) && duration < 200) {
	;tt("Send !LButton")
	Send, !{LButton}
}

return

!RButton::
setScalingAware()
GetKeyState,theLButton,LButton ,P ; Break if button has been released.
If theLButton = D
	return ; RButton during LButton is used to activate a window
kdeMouseResizeMulti("RButton")
return

!^d:: ; alt ctrl d
KeyWait Alt, L
KeyWait CTRL, L
Send, %A_YYYY%-%A_MM%-%A_DD%
return

!^+d:: ; shift alt ctrl d
KeyWait Alt, L
KeyWait CTRL, L
KeyWait Shift, L
Send, %A_YYYY%-%A_MM%-%A_DD% %A_DDDD%
return 

!^r:: ; alt ctrl r
Run Calc
return




#If !ismpcwin(getMouseWin())
!F7::
googlesearch()
return

#If ismpcwin(getMouseWin())
;!WheelUp::
;id:=getMouseWin()
;tt("foo")
;tt(getWinInfobase(id))
; mpcsend_Increase_Rate(id)
Return

