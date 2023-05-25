#NoEnv
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



if 0 < 1  ; The left side of a non-expression if-statement is always the name of a variable.
	{
	
		last:=ObjFromFile(memPath)
		funcName:=last.funcName
		params:=last.params
		mos(last,funcName,params)
		s:="This script requires at least 1 incoming parameters but it only received 0. `n Run last `n" Stringjoin(" ",funcName,params*)
		; MsgBox, 4, , %s%
		; IfMsgBox No
			; return
		;mos(s)
		;%last.funcName%(last.params*)
		%funcName%(params*)
	}else{
		funcName = %1%
		params := []
		rpcount = %0%
		rpcount-=1
		fpcount:=IsFunc(funcName)-1
		;mm(fpcount)
		if (fpcount<=rpcount) {
			Loop % rpcount
			{
				
				llreceivepIndex:=A_Index+1
				receivepIndex := %llreceivepIndex%
				val = %receivepIndex%
				;mm(val)
				params.push(val)
			}
			last:=Object()
			;ttos(params)
			last.funcName:=funcName
			last.params:=params
			ObjToFile(last, memPath)
	
			;mos(Stringjoin(" ","parCount",params.maxindex(),funcName,params*),last, memPath)
			%funcName%(params*)
		}else{
			mm(funcName . " reqires at least" . fpcount . " params, but only " . rpcount . " receiveee")
		}
		
	}
	SetTimer, TmrExit,-1000
	return
	
	TmrExit:
	ExitApp 