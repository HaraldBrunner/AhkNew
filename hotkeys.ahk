#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
CoordMode,Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen
SetWinDelay,-1 ; kde functions are really nice with this, but for some window functions, it could be too fast


SetWorkingDir, %A_ScriptDir%
#Include C:\ProgrammeUser\AHK_New\MyLibs 
#Include base.ahk
#Include googlesearch.ahk
#include KdeMouseMoveLib.ahk
#include Player.ahk
#include KeyCounter.ahk
#include MouseTracker.ahk
#include MouseTrackerCBLAlt.ahk
#include actOther.ahk

Default__Warn(obs*)
{
    ListLines
 	
    Mos(callstack(),"A non-object value was improperly invoked.",obs)
	
}
"".base.__Get := "".base.__Set := "".base.__Call := Func("Default__Warn")

lsc:=new KeyCounter("LShift","LShiftCount")  
maxInterval:=1200
lac:=new KeyCounter("LAlt", "LAltCount",maxInterval,maxInterval-1)
maxInterval:=400
f7C:=new KeyCounter("F7", "F7Count",maxInterval,maxInterval-1)
maxInterval:=400
lc:=new KeyCounter("LControl", "LCtrlCount",maxInterval,maxInterval-1)
maxInterval:=400
mb:=new KeyCounter("MButton", "MButtonCount",maxInterval,maxInterval-1)

tt("hotkeys started")
Return

~*LAlt::
	setScalingAware()
	global gMyAlt:=true
	activateOther()
	curcount:=lac.keydown()
	id:=getMouseWin()
	if (curcount==1 && ismpcwin(id)) {
		keys := Object()
		keys.push("LAlt")
		cb:=new MouseTrackerCBLAlt()
		MouseTracker.instance().track(cb, keys)
	}
return
~*LAlt up::
	setScalingAware()
	global gMyAlt:=false
	lac.keyup()
return

~*LCtrl::
	global gmyLCtrl:=true
return
~*LCtrl Up::
	global gmyLCtrl:=false
return

~*LShift::
	global mylshift:=true
return 
~*LShift up::
	global mylshift:=false
return

~*F7::
setScalingAware()
global gF7:=true
f7c.keydown()
return
~*F7 up::
setScalingAware()
global gF7:=false
f7c.keyup()
return

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


;=========================================================================
;=========================================================================

#If isMpcWinWithCtrlCheck()
!WheelUp::
	setScalingAware()

	;tt("!WheelUp") 
	sizeplayer(getctid(),true)
return

!WheelDown::
	setScalingAware()
	;tt("!WheelDown") 
	sizeplayer(getctid(),false)
return

!F7::
setScalingAware()
it:=getMouseWin()
mpcsend_PnS_Reset(id)
return

+WheelUp::
setScalingAware()
rate(true,!false)
return

+WheelDown::
setScalingAware()
rate(false,!false)
return

!+WheelUp::
setScalingAware()
rate(true,!true)
return

!+WheelDown::
setScalingAware()
rate(false,!true)
return

~+LButton::
setScalingAware()
id:=getctid()	
mpcsend_Reset_Rate(id)
return




F7Count(c,mp) {
	;tt(c)
	id:=getMouseWin()
	if(ismpcwin(id)) {
		if (c==1) {
			mpcsend_Play_Pause(id)
		}
	}
}