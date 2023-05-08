#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
CoordMode,Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen
CoordMode, Menu, Screen
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
#include hotkeysLib.ahk


Default__Warn(obs*)
{
    ListLines
 	
    Mos(callstack(),"A non-object value was improperly invoked.",obs)
	
}

setScalingAware()



SetTimer, Tick, 1000
tt("testGetWindowFromPointStarted")

Return



Tick() {
	mouseGetPos,x,y,id

	;hWnd := DllCall("WindowFromPoint", UInt64, x|(y << 32), Ptr)
	;hParent := DllCall("GetAncestor", Ptr, hWnd, UInt, GA_ROOT := 2, Ptr)

	cid:=getWindowFromPointExact(x,y)
	mainid:=getWindowFromPoint(x,y)
	ttos(x,y,id,cid, mainid)
}

~^s::
Sleep, 1000
Reload
Return

