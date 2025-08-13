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

"".base.__Get := "".base.__Set := "".base.__Call := Func("Default__Warn")
maxInterval:=400
lsc:=new KeyCounter("LShift","LShiftCount",maxInterval,maxInterval-1)  
maxInterval:=400
lac:=new KeyCounter("LAlt", "LAltCount",maxInterval,maxInterval-1)
maxInterval:=400
f7C:=new KeyCounter("F7", "F7Count",maxInterval,maxInterval-1)
maxInterval:=400
lc:=new KeyCounter("LControl", "LCtrlCount",maxInterval,maxInterval-1)
maxInterval:=400
mb:=new KeyCounter("MButton", "MButtonCount",maxInterval,maxInterval-1)

buildMenu()


mpcBe64exe:="mpc-be64.exe"
GroupAdd, grpPlayers, ahk_exe %mpcBe64exe%

tt("hotkeys started")
Return




~*LAlt::
	setScalingAware()
	global gMyAlt:=true
	
	curcount:=lac.keydown()
	id:=getMouseWin()
	if (curcount==1 && ismpcwin(id)) {
		keys := Object()
		keys.push("LAlt")
		cb:=new MouseTrackerCBLAlt()
		MouseTracker.instance().track(cb, keys)
activateOther()
	}
	
return

~*LAlt up::
	setScalingAware()
	global gMyAlt:=false
	lac.keyup()
return

~*LCtrl::
	setScalingAware()
	global gMyLCtrl:=true
return
~*LCtrl Up::
	setScalingAware()
	global gMyLCtrl:=false
return

~*LShift::
	setScalingAware()
	global gMylshift:=true
	curcount:=lsc.keydown()
return 
~*LShift up::
	setScalingAware()
	global gMylshift:=false
	lsc.keyup()
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

~*LButton::
setScalingAware()
;tt("LBUTTON")
global gMouseButtonHit :=1
global gMyLButtonDown:=true
return

~*LButton up::
setScalingAware()
;tt("LBUTTON up")
global gMyLButtonDown:=false
return

RButton::
setScalingAware()
;tt("RButton::")
global gMyLButtonDown
global menPoint
menPoint:=getPointFromMouse()
if(gMyLButtonDown){
	KeyWait, LButton, L
	KeyWait, RButton, L
	tt("menuu()")
	openMainMenu()
}else{
	global gMyRButtonDown:=true
	Send, {RButton}
}

return

~^s::
Sleep, 1000
Reload
Return

^!h::
Run, shutdown /h

MButton::
setScalingAware()
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
setScalingAware()
googlesearch()
return

;=========================================================================
;=========================================================================
#If isMpcWinWithCtrlCheck() && IsTopOrBottomArea() && !IsLeftOrRightArea()


WheelUp::
wheelIsTopOrBottomArea(true)
return

WheelDown::
wheelIsTopOrBottomArea(false)
return


;=========================================================================
;=========================================================================

#If ismpcwin(getMouseWin())
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

^!WheelUp::
id:=getctid()
loopSound(true,true,false)
return

^!WheelDown::
id:=getctid()
loopSound(false,true,false)
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

^WheelUp::
setScalingAware()
id:=getctid()
	mpcsend_Jump_Forward_large(id)
return

^WheelDown::
setScalingAware()
	id:=getctid()
	mpcsend_Jump_Backward_large(id)
return


F7Count(c,mp) {
	;tt(c)
	id:=getMouseWin()
	if (0 && c==1) {
		; screen:=getscreenFromMouse()
		; getScreenpos(screen,x,y,w,h)
		; mos(screen,x,y,w,h)
		; ExplorerTestClass.___Monitor()

		;SysGet, MonitorName, MonitorName, screen
		;	SysGet, Monitor, Monitor, screen
		;	SysGet, MonitorWorkArea, MonitorWorkArea, %A_Index%
		;	MsgBox, Monitor:`t#%A_Index%`nName:`t%MonitorName%`nLeft:`t%MonitorLeft% (%MonitorWorkAreaLeft% work)`nTop:`t%MonitorTop% (%MonitorWorkAreaTop% work)`nRight:`t%MonitorRight% (%MonitorWorkAreaRight% work)`nBottom:`t%MonitorBottom% (%MonitorWorkAreaBottom% work)
	} else if (c==2) {
		Run, osk.exe ;, , Max|Min|Hide|UseErrorLevel, OutputVarPID]
		
	}Else{
		if(ismpcwin(id)) {
			if (c==1) {
				mpcsend_Play_Pause(id)
			}
		}
	}
}

LShiftCount(c,mp) {
	;tt(c)
	id:=getMouseWin()
	
	if(c==1) {
		if (ismpcwin(id) && isFullscreenarea()) {
			mpcsend_Toggle_Playlist_Bar(id)
		} else if (isOnLeftScreenBoarder()) {
			tt("left")
			ShowTaskbar()
		}
	} else if (c=2) {
		openMainMenu()
	} 
}


buildMenu() {
	for i,dm in getDynWinSubMenus() {
		
        dm.setParentAndAddsubmenu("RareMenu")
    }
    Menu, MyMenu, Add
	locVar := getINIBoolVars()
    for index, element in locVar {
		Menu, SetMenu, Add, %element%, INIBoolItemLab
	}
	Menu, MyMenu, Add,SetMenu,:SetMenu
	Menu, MyMenu, Add,Close, MenuHandler
}

MenuHandler:
return

adjustDynMenItems() {
    temp:=readini()
	locVar := getINIBoolVars()
    for index, element in locVar {
	istrue := temp[element]
    if (istrue) {
            Menu, SetMenu,Check, %element%
        } else {
            Menu, SetMenu,UnCheck, %element%
        }

    }
}

openMainMenu() {
    killmenu()


    global menposx,menposy,menposid,menposctrlid,gTitle, gmenuPoint
    MouseGetPos,menposx,menposy, menposid  ;    ,menposctrlid,2
	menposid:=getctid()
	menposctrlid:= getWindowFromPointExact(menposx,menposy)
	calcTitleInfo(menposid,fpath,fpathOrTitle, schedTo,schedTotfpath)
  	gtitle:=fpathOrTitle
	if (fpath) {
        SplitPath, fpath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
        ;Clipboard = %OutFileName%
    } else {
        ;Clipboard = %fpathOrTitle%
    }


	s= %fpathOrTitle%

    if (s) {
		;mos()
        tt(s)
    }

    ;    Menu, MyMenu, Show

    for i,dm in getDynWinSubMenus() {
		if (dm.inlineMenuu()) {
			mname:=dm.__Class
			startt:=A_TickCount
			dm.buildmenu()
			duration:=A_TickCount-startt
			;            tt(duration . " " . mname  )
        }
    }

    adjustDynMenItems()

    Menu, MyMenu, Show
}

INIBoolItemLab:
tp:=readini()
tp[A_ThisMenuItem] := !tp[A_ThisMenuItem] 
return