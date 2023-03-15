#Include DataStructures.ahk


class mypoint {
	__New(x:="",y:="",id:="") {
		;tt("mypoint constructor")
		if ((x=="")||(y=="")) {
			MouseGetPos,x,y,id
		}
		this.x:=x
		this.y:=y
		this.id:=id
		return this
	}
	fromMouse() {
		;tt("frommouse")
		mouseGetPos,x,y,id
		p :=  new mypoint(x,y,id)
		;mos("new p in mouse " , p)
		return p
	}
	isEqual(p) {
		ret := this.x == p.x && this.y == p.y
		return ret
	}
}

callfunc(fn,params*){
	pcount:=isFunc(fn)
	if(	pcount){
		if(params.MaxIndex()==""){
			;mos("nop",fn,params)
			return %fn%()
		}else{
			;mos("wp" ,	pcount,fn,params)
			
			return %fn%(params*)
		}
		
	}else{
		mos("noFunk")
		callstack()
	}
	
}

class SkriptSpeed{
	fast(){
		return new SkriptSpeed()
	}
	
	__New(){
		this.OBatchLines:=A_BatchLines
		this.OKeyDelay:=A_KeyDelay
		this.OKeyDuration:=A_KeyDuration
		
		;mos(A_BatchLines, A_KeyDelay, A_KeyDuration)
		SetKeyDelay,1,-1
		SetBatchLines, 50ms
		;mos("set",A_BatchLines, A_KeyDelay, A_KeyDuration)
		return this
	}
	
	restore(){
		SetKeyDelay,this.OKeyDelay,this.OKeyDuration
		OBatchLines:=this.OBatchLines
		SetBatchLines, %OBatchLines%
		;mos("reset",A_BatchLines, A_KeyDelay, A_KeyDuration)
	}
}

tt(text="",x:="",y:=""){
	;text:=text callstack()
	;debugbreak()
	if (text==""){
		
		mos("TEXTISEMPTY" . "`n" . CallStack())
	}if (isDebug() || ttWithCallstack()) {
		text .= "`n`n`n" . CallStack()
	}
	;if (text=="1"){
	;	debugbreak()
	;}
	
	if(x && y==""){
		id:=x
		r:= new rect(id)
		x:=r.x
		y:=r.y
	}
	;text:=x " " y " - " text
	
	
	ctt()
	global gTTText
	old:=gTTText
	gTTText := text
	if (isDebug()) {
		gTTText := gTTText . "`n" . old
	}
	;x:=y:=40
	global lastgTTText
	if(lastgTTText != gTTText){
		lastgTTText := gTTText
		ToolTip %gTTText%,x,y
		id:=GetToolTipHandle()
		;mos("id" . id)
		if (id) {
			funcName:="makeClickTh"
			;%funcName%(id,160)
			;makeClickTh(id,160)
			;settrans(150,id)
			;ToolTip, Foo,x,y
		}else{
			
		}
	}
	
}
mm(s:=""){
	tt(s)
	MsgBox,4096, %s%, %s%
}
GetToolTipHandle(){
 
	;-- Initialize
	hTT :=0
	 
	;-- Get the current process ID
	Process Exist
	ScriptPID :=ErrorLevel
	; ToolTip %ScriptPID%
	;-- Find the tooltip
	WinGet, IDList,List,ahk_pid %ScriptPID%
	Loop %IDList%
	{
		id:=IDList%A_Index%
		WinGetClass Class,ahk_ID %id%
		;ToolTip %Class%
		if (Class=="tooltips_class32")
		{
			hTT:=id
			Break
		}
	}
	 
	return htt
}

ctt() {
	scheduleCloseToolTip() 
}

scheduleCloseToolTip() {
	if (isDebug()||slowTooltipTimeout()) {
		t:=-15000
	}else{
		t:=-2000
	}
	SetTimer, CloseTT, %t%
	return
	
	CloseTT:
	ToolTip
	global gTTText := ""
	global lastgTTText := ""
	return 
}

myExitApp(){
	exitapp
}

slowTooltipTimeout(){
	return false
}

ttWithCallstack(){
	return false
}

isDebug(){
return false
}
residentsPath(){
return "C:\ProgrammeUser\AHK\AutoHotkeyResistents"
}

storeFuncMem(funcName,obj){
	if(!isObject(obj)){
		o2:=object()
		o2.nonObjectVal:=obj
		;mos(obj,o2)
		obj:=o2
	}
	ObjtoFile(obj,residentsPath() "\lastCallMem" funcName)
}

getFuncMem(funcName){
	last:=ObjFromFile(residentsPath() "\lastCallMem" funcName)
	if(last.haskey("nonObjectVal")){
		nov:=last.nonObjectVal
		mos(nov,funcName,last)
		return nov
	}
	return last
}

max(a,b){
	if (a>b) {
		return a
	}else{
		return b
	}
}


min(a,b){
	if (a<b) {
		return a
	}else{
		return b
	}
}

tos(objs*) {
	if(IsObject(objs)){
		ret:= ObjToStrUser(objs)
	}else{
		ret:="noObjectVal:" . objs
		
	}
	return ret
}

ttos(obj*) {
	
	tc:=A_TickCount
	td:=tc-lc
	lc:=tc
	text:=tos(obj)
	
	if(isDebug()){
		static dbgInfo:=""
		if(td>5000){
			dbgInfo:=""
		}else{
			tn:=dbgInfo "`n" text
			dbgInfo:=tn
			text:=tn
		}
	}
	
	tt(text)

	return text


}



mos(obj*){
	MsgBox % tos(obj)"`n`n" callstack()
}

Is64Bit(){
	return true
}
DoFastRescue(){
	return true
}
getWinInfobaseArray(a){
	for i,e in a {
		msg .= getwininfobase(e)
	}
	return msg
}
getWinInfobase(id){
	WinGetClass, class, ahk_id %id%
	WinGetTitle, title, ahk_id %id%
	WinGet, Style, Style, ahk_id %id%
	top:=false ;istopmost(id)
	v:=true ;isVisWin(id)
	;screen:=getScreen(id)
	screen:="getScreen(id)"
	WinGetPos,x,y,w,h, ahk_id %id%
	WinGet,MinMax,MinMax,AHK_id %id%
		WinGet,ProcessName,ProcessName,ahk_id %id%
	s := id . " top:" . top . " vis:" v . " screen:" . screen . "x:" . x . " " . y . " " .  w . " " .  h . " " . " MinMax:" . MinMax . " p:" . ProcessName . " c:" . class . " t:" . title . "`n"
	return s
}


noNotKeepOT(ids){
	ret:=Object()
	temp:=keepOT()
	for index,id in ids{
		ov:=temp.getValueOrNull(id)
		If (ov) { 
			ret.push(id)
		}
	}
	return ret
}

Array_Reverse(arr){
	arr2 := Object()
	mi:=arr.maxindex()
	For index, val in arr {
		arr2[mi-(index-1)] := val
	}
	Return arr2
}
noclickthrough(ids){
	ret:=Object()
	for index,id in ids{
		
		If (!isclickthrough(id)) { 
			ret.push(id)
		}
	}
	return ret
}


getNoOtherScreen(ids){
	ret:=Object()
	for index,id in ids{
		
		If (getscreenFromMouse() == getscreenFromPoint( new rect(id).getCenter())) { 
			ret.push(id)
		}
	}
	return ret
}

getNonHidden(ids){
	ret:=Object()
	for index,id in ids{
		
		If (hasVisibleStyle(id)) { 
			ret.push(id)
		}
	}
	return ret
}

getNonMinimized(ids){
	ret:=Object()
	for index,id in ids{
		WinGet, WinState, MinMax, AHK_id %id%
		If (WinState != -1) { 
			ret.push(id)
		}
	}
	return ret
}


getWinsOrderedTopFirst(filter:="cmh"){
	ret:=Object()
	kOT:=Object()
	set:=Object()
	temp:=A_DetectHiddenWindows 
	DetectHiddenWindows, on
	WinGet, ids, list, , , Program Manager
	
	Loop, %ids%
	{
		StringTrimRight, id, ids%a_index%, 0
		
		if(!set.HasKey(id)){
			set[id]:=1
			if(getkeepOT(id)){
				kOT.push(id)
			}else{
				ret.push(id)  ;moveto4gridfä
			}
		}
	}
	
	for i,id in kOT{
		ret.push(id)
	}

	if(InStr(filter,"c")){
		ret :=noclickthrough(ret)
	}
	if(InStr(filter,"m")){
		ret :=getNonMinimized(ret)
	}
	if(InStr(filter,"h")){
		ret :=getNonHidden(ret)
	}
	DetectHiddenWindows, %temp%
	return ret
}

isclickthrough(id){
WinGet, exStyle, exStyle,ahk_id %id% 
if(ExStyle&0x20){
	return 1
}
return 0
}

istopmost(id){
	WinGet, ExStyle, ExStyle,  ahk_id %id%
	if (ExStyle & 0x8) {
		Return True
	}
	Return False
}
isVisWin(id) {
	;mm(callstack())
	WinGet, Style, Style, AHK_id %id%
	if ((Style & WS_VISIBLE:=0x10000000)&&(!(Style & WS_MINIMIZE:=0x20000000L ))) { ; popu
		Return True
	}

	Return False
}


getTitle(id) {
	wingettitle, title, ahk_id %id%
	return title
}
writecb(obj){
	s1:=tos(obj)
	
	rem := Object()
	
	For k,v in Obj{
		if k is integer
		{
			if(!v || !winexist("ahk_id " k)){
				;tt("remove" k)
				;obj.Remove(k)
				rem.push(k)
			}else{
			;tt("exists" k)
			}

		}
	}
	For k,v in rem{
		
		;obj.Remove(v, "")
		;ObjRemove(obj,v)
		obj.delete(v)
		if(obj.haskey(v)){
			
		}
	}
	s2:=tos(obj)
		;mos(s1,s2,rem)
	if(s1 != s2){
	}
	
}
class PersistentObjectFast {
	__New(path,preWriteCB:=""){
		this.path:=path
		this.preWriteCB:=preWriteCB
		this.scurrent:=""
		this.scurrentCont:=""
	}
	
	get(){
		FNAME:=this.path
		if (!this.scurrent){
			update:=true
		}else{
			FileRead,currentCont,%FNAME%
			if(this.scurrentCont!=currentCont){
				this.scurrentCont:=currentCont
				update:=true
			}
		}
		if(update){
			this.scurrent:= new PersistentObject(FNAME,this.preWriteCB,currentCont)
		}else{
			;ttos("update saved")
		}
		return this.scurrent
	
	}
}

class PersistentObject {

	

	RemoveAll(){
		s.=tos(this)
		path:=this["","fpath"]
		preWriteCB:=this["","preWriteCB"]
		ooo:=Object()
		ooo.fpath:=path
		ooo.preWriteCB:=preWriteCB
		ObjInsert(this, "", ooo)


		s.=tos(this)
		if(s)
			;mos(s)
		
		this.write()
	}
	
	getValueOrNull(aName){
		ooo:=this[""]
		if(ooo.HasKey(aName)) {
			ret:= ooo[aName]
		}else{
			ret:=0
		}
		return ret
	}
	
	write(){
		path:=this["","fpath"]
		cb:=this["","preWriteCB"]
		o2f:=this[""]
		if(cb){
			%cb%(o2f)
		}
		
		ObjtoFile(o2f,path)
		;ttos(this,callstack())
	}
	__New(path,preWriteCB:="", cont:=""){
		
		if (cont!=""){
			ooo:=ObjFromStr(cont)
		}else{
			if(FileExist(path)){
			ooo:=ObjFromFile(path)
			}else{
				ooo:=Object()
			}
		}
			
		
		ooo.fpath:=path
		ooo.preWriteCB:=preWriteCB
		;mos(ooo)
		ObjInsert(this, "", ooo)
	}
	__Set(aName, aValue){
		;mos(aName, aValue)
		ooo:=this[""]
		ooo[aName]:=aValue
		
		
		this.write()
		return aValue
	}
	__Get(aName){
		if(this[""].HasKey(aName)) {
			return this["",aName]
		}
	}

}

persistSetting(){
	static inst:=new PersistentObjectFast("C:\ProgrammeUser\AHK\AutoHotkeyResistents\PersistSetting.txt")
	return inst.get()
}

class DecoratedCallNotWotking{
	_before(params*){
	}
	
	_call(params*){
	}
	_after(params*){
	}
	run(params*){
		;tt("run")
		this._before(params*)
		this._call(params*)
		this._after(params*)
	}
}

class MadVrShortcutNotWotking extends DecoratedCallNotWotking{
	_before(id){
		mos("before")
		persistSetting()["actOtherTempDisable"]:=true
		WinActivate, % "ahk_id" id
	}

	_after(params*){
		persistSetting()["actOtherTempDisable"]:=false
	}
}

class ToggleStat extends DecoratedCallNotWotking{
	_call(){
		send {LCtrl down}j{LCtrl Up}
	}
}

keepOT(){
	static inst:=new PersistentObjectFast("C:\ProgrammeUser\AHK\AutoHotkeyResistents\keepOnTop.txt")
	return inst.get()

	
}

getClass(id:="") {
	if(!id){
		MouseGetPos,,,id
	}
	WinGetClass, class,ahk_id %id%
	;
	return class	

}

getKeepOTWins(){
	temp:=keepOT()
	ret:=Object()
	WinGet, ids, list, , , Program Manager
	Loop, %ids%
	{
		StringTrimRight, id, ids%a_index%, 0
		ot:=temp.getValueOrNull(id)

		
		if (isvisWin(id)&& (isMPCWin(id) || getClass(id)=="OSKMainClass") &&(isclickthrough(id) || ot))
		{
			r:=new rect(id)
			if(r.h!=28){
				;tt("id " . id)
				ret.push(id)
			
			}
		}
	}
	;ListLines
	;ttt(ret)
	return ret
}

getKeepOTMandatory(){
	ctWins:=Object()
	msg:=""

	WinGet,id ,id, ahk_class #32770
	if(id  && visibleAndNotMinimized(id) && !arrayContains(ctWins,id)){
		msg .= "Ahk " getwininfobase(id) newline()
		ctWins.push(id)
	}
	
	;ttos(A_TitleMatchMode , A_TitleMatchModeSpeed )
	WinGet,id ,id,Captcha ahk_class SunAwtDialog
	if(id  && visibleAndNotMinimized(id)  && !arrayContains(ctWins,id)){
		msg .= "Captcha  " getwininfobase(id) newline()
		;;ttos("Captcha KeepOnTop ", getwininfo(id))
		ctWins.push(id)
	}
	
	WinGet,id ,id,ThrottleStop 5.00
	if(id &&   visibleAndNotMinimized(id) && !arrayContains(ctWins,id)){
		msg .= "ThrottleStop 5" getwininfobase(id) newline()
		;mos("ThrottleStop 5 KeepOnTop ", id)
		ctWins.push(id)
	}

	WinGet,id ,id, ahk_class Shell_TrayWnd
		;mos("Shell_TrayWnd", getWininfo(id))
	if(id && visibleAndNotMinimized(id) && !arrayContains(ctWins,id)){
		msg .= "Shell_TrayWnd  " getwininfobase(id) newline() 
		ctWins.push(id)
	}	
	WinGet,id ,id, ahk_class DV2ControlHost
	if(id && visibleAndNotMinimized(id) && !arrayContains(ctWins,id)){
		msg .= "DV2ControlHost  " getwininfobase(id) newline() 
		ctWins.push(id)
	}
	WinGet,id ,id, ahk_exe osk.exe
	vnm:=visibleAndNotMinimized(id)
	ac:=arrayContains(ctWins,id)
	;mos(id,vnm,ac)
	if(id && vnm && !ac){
		msg .= "osk.exe  " getwininfobase(id) newline() 
		ctWins.push(id)
	}
	if(msg){
		;tt(msg)
	}

	return ctWins
}
array2set(a){
	s:=Object()
	for i,e in a {
		s[e]:=1
	}
	return s
}

getArrayReducedBySet(a,s){
	a2:=Object()
	for i,e in a {
		if(!s.hasKey(e)){
			a2.push(e)
		}
	}
	return a2
}

getKeepOTWinsBellowFirst(){

	
	allTopFirst:=getWinsOrderedTopFirst("hm")
	;mos("getWinsOrderedTopFirst",getWinInfobaseArray(r))
	KeepOTTopFirst:=noNotKeepOT(allTopFirst)
	;mos("KeepOT",getWinInfobaseArray(r))
	KeepOTBellowFirst:=Array_Reverse(KeepOTTopFirst)
	;mos("reverse",getWinInfobaseArray(r))
	;mos(getWinInfobaseArray(r))
	KeepOTctBellowFirst:=Object()
	KeepOTotherBellowFirst:=Object()
	for index,id in KeepOTBellowFirst {
		if(isclickthrough(id)){
			KeepOTctBellowFirst.push(id)
		}else{
			KeepOTotherBellowFirst.push(id)
		}
	}
	for index,id in KeepOTctBellowFirst {
		KeepOTotherBellowFirst.push(id)
	}
	KeepOTotherCTBellowFirst:=KeepOTotherBellowFirst

	
	manBelowFirst:=getKeepOTMandatory()
	
	manSet:=array2set(manBelowFirst)
	KeepOTWithOutManotherBellowFirst:=getArrayReducedBySet(KeepOTotherCTBellowFirst,manSet)
	;mos(manSet,getwininfobaseArray(r),getwininfobaseArray(r2))
	t:=""
	for index,id in manBelowFirst {
		;t .= gettitle(id)
		KeepOTWithOutManotherBellowFirst.push(id)
	}
	;mos(KeepOTWithOutManotherBellowFirst)
	;mos("final KeepOTWinsBellowFirst",KeepOTWithOutManotherBellowFirst)
	return KeepOTWithOutManotherBellowFirst
}

togglekeepOT(id:=""){
	if(id==""){
		id:=getctid()
	}
	if(!assureRunningScript("bp2",a_thisFunc,id)){
		return
	}
	
	ov:=keepOT().getValueOrNull(id)
	nv := !ov 
	;mos(ov,nv)
	tt("KeepOnTop "  nv,id)
	keepOT()[id]:=nv

}	   
setkeepOT(nv,id){
	if(id==""){
		mos()
		id:=getctid()
	}
	if(!id){
		mos(id)
	}
	;
	; if(!assureRunningScript("bp2",a_thisFunc,nv,id)){
		; return
	; }
	

	;tt("KeepOnTop "  nv,id)
	keepOT()[id]:=nv
	
}	
getkeepOT(id){
	;keepOT().getValueOrNull(id)
	;WinGetTitle, thistit, ahk_id %id%
	;if(thistit=="AhkQuery"){
		;return true
	;}
	return keepOT().getValueOrNull(id)
}


setkeepOTAndTopmost(nv,id){
	setkeepOT(nv,id)
	
	if(!nv){
		if(ismpcwin(id)){
			nv:=true
		}
	}
	
	setTopMost(id,nv)
}
tkot(){
	togglekeepOTAndTopmost()
}
togglekeepOTAndTopmost(id:=""){
	if(id==""){
		id:=getctid()
	}
	ot:=getKeepOT(id) 
	tm:=istopmost(id)
	
	old:=ot && tm
	;mos(old,ot,tm)
	setkeepOTAndTopmost(!tm,id)
	
}

keepOTRemoveAll(){
	
	if(!assureRunningScript("bp2",a_thisFunc)){
		return
	}
	
	keepOT().RemoveAll()
}


getctwinsraw(){
	ret:=Object()
	WinGet, ids, list, , , Program Manager
	Loop, %ids%
	{
		StringTrimRight, id, ids%a_index%, 0
		
		if (isvisWin(id)&&isclickthrough(id))
		{
			;tt("id " . id)
			ret.push(id)

		}
	}
	;ListLines
	;ttt(ret)
	return ret
}


getctwins(aboveId:=""){
	;global gctWins
	if(!gctWins){
		gctWins:=getctwinsraw()
	}
	ret:=Object()
	for i,id in gctWins
	
	{
		
		if(id==aboveId){
			
			break
		}
		if (isvisWin(id)&&isclickthrough(id))
		{
			ret.push(id)

		}
	}
	;ListLines
	;ttt(ret)
	return ret
	
}



getctwinsFromPoint(p,onlyOne:=false,aboveId:=""){
	ret:=Object()
	for index, element in getctwins(aboveId){
		w:=new WinRect(element)
		if (isPointInRect(p, w.rect )) {
			ret.push(w)
		}
	}
	;MsgBox % ret.MaxIndex()
	return ret
}



getSinglectwinFromPoint(p :="",aboveId:=""){
	if(!p){
		p:=new Point()
	}
	;ttt(p)
	ctwins:=getctwinsFromPoint(p,true,aboveId)
	;mos(ctwins)
	;tt("ctwins.MaxIndex()" . ctwins.MaxIndex())
	
	for index, element in ctwins
	{
		return element
	}
	return 0
}

clearGCtidIfOutdated(){
	global gCtId
	global sender
	
	if(isObject(gCtId)){
		pt:=point.frommouse()
		w:=new WinRect(gCtId.id)
		if (!isPointInRect(pt, w.rect )) {
			gCtId:=""
			if(sender==a_scriptname){
				tt("gCtId was cleared,  point was was no more on the window")
			}
		}
	}
}

storectidloc(id:=""){
	clearGCtidIfOutdated()	
	global sender
	global gCtId
	gCtIdLoc:=getSinglectwinFromPoint(point.fromMouse(),id)
	
	if(isObject(gCtIdLoc) && isObject(gCtId)) {
		if(gCtIdLoc.id == gCtId.id){
			if(sender==a_scriptname){
				;ttos(gCtId,a_scriptname ": gCtId was cleared instead storing, because there was still an old value:" gCtId.id)
			}
			
			gCtId:=""
			return
		}
	}
	gCtId:=gCtIdLoc
	
	;info:=tos(pt) " is p, " id " is aboveId`n"
	if(sender==a_scriptname){
		if (gCtIdLoc) {
			fo:=gettitle(gCtIdLoc.id)
			tt(info "gCtId " . " " . fo,gCtIdLoc.id)
			settimer,
		}else{
			tt(info "gCtId " . " is 0")
		}
	}
	if (A_ScriptName=="bp2.ahk") {
		if (gCtIdLoc) {
			settimer,storeCtIdNULLLL,-5000
		}
	}
	ttos(gCtId)
	return
	
	storeCtIdNULLLL:
	tt("gCtId Reset By Timer")
	calltoAllProc("storeCtIdNULLfunc")
	return
}

storeCtIdNULLfunc(){
	global gCtId
	gCtId:=0
}


SendData(wParam, lParam) {
; http://www.autohotkey.com/board/topic/77796-senddata-sending-data-between-scripts-with-sendmessage/ - May 3, 2013
 ; wParam = which script; lParam = data in CSV format
	Global
	Static Label
	Local UseError := False
	local  WM_COPYDATA:=0x4a
	Local a, b, c, Ptr := A_PtrSize = "" ? "UInt" : "Ptr", Psz := A_PtrSize = "" ? 4 : A_PtrSize
	If (wParam = True) {
		OnMessage(WM_COPYDATA, A_ThisFunc)
		If lParam and !IsLabel(Label := lParam){
		Local 	cs:=callstack()
			MsgBox, 262160, %cs% Error, Label "%Label%" does not exist.
		}
			
	} Else If (wParam = False) {
		c := A_IsUnicode ? "W" : "A", a := NumGet(lParam + 0, 2 * Psz, Ptr), VarSetCapacity(b, DllCall("lstrlen" c, Ptr, a) << (c = "W")), DllCall("lstrcpy" c, "Str", b, Ptr, a)
		params := []
		
		;MsgBox, %b%
		Local	parAr:=Object()
		Loop, Parse, b, CSV
		{
			parAr.push(A_LoopField)
		}

		b:=""
			Local index,par
		for index,par in parAr
		{
			if(index==parAr.MaxIndex()){
				sender:=par
				;mos(sender)
			}else{
				if(index>1){
					b:= b "," 
				}
				b:= b par
			}
		}
		
		
		Loop, Parse, b, CSV
		{
			If (A_Index = 1) and !Label
			{
				a := A_LoopField
				Local	funccall:= (a=="fcL")
			}
			Else If (funccall)
			{
				;mos(A_Index, A_LoopField)
				If (A_Index = 2)
				{
					 funcName:=A_LoopField
				}else{
					params.push(A_LoopField)
				}
				
			}
			Else
			{
				If (1 & A_Index) ^ !Label
					b := A_LoopField
				Else
					%b% := A_LoopField
			}

		}
		
		
		If Label
		{	
			SetTimer, %  Label, -1
		}
		else If IsLabel(a)
		{	
			SetTimer, % a, -1
		}
		Else
		{
			cs:=callstack()
			MsgBox, 262160, %cs% Error, Label %a% does not exist. b was %b%
		}
		
		Return
		fcL:
			;mos(funcName)
			pcount:=IsFunc(funcName)
			;msgbox % pcount " is pcount, params.MaxIndex() is " params.MaxIndex()
			if(pcount>0){
				pcount:=pcount-1
				avParCount:= params.MaxIndex() ? params.MaxIndex() : 0
				if(avParCount >= pcount){
					%funcName%(params*)
				} else {
					;mos("the funtion " funcName " needs " pcount " parameters, but we have only " avParCount " available`n`n",params*)
				}
			} else{
				mos("the funtion does not exist:" funcName)
			}
		return
	} Else {
	
	 lparam:=lparam "," a_scriptname
	
		a := A_DetectHiddenWindows, b := A_TitleMatchMode
		DetectHiddenWindows, On
		SetTitleMatchMode, Regex
		Local a, b, c, Ptr := A_PtrSize = "" ? "UInt" : "Ptr", Psz := A_PtrSize = "" ? 4 : A_PtrSize
		VarSetCapacity(c, 3 * Psz, 0), NumPut((StrLen(lParam) + 1) * (A_IsUnicode ? 2 : 1), c, Psz), NumPut(&lParam, c, 2 * Psz)
		
		if wParam is integer
		{
			if(wParam!=0){  ; 0x4a is WM_COPYDATA
				SendMessage, WM_COPYDATA, 0, &c, , ahk_id %wParam%
			}else{
				mos("assert(wParam!=0)")
			}
			
		}else{
			SendMessage, WM_COPYDATA, 0, &c, , i)\\\Q%wParam%\E(\.(ahk|exe))? ahk_class AutoHotkey ; edit this regular expression to your liking
		}
		
	
		If (ErrorLevel <> True) and UseError
			MsgBox, 262160, %A_ScriptName% - %A_ThisFunc%(): Error, % "ErrorLevel:`t" ErrorLevel "`n" ErrorLevel ? "Script """ wParam """ did not receive the message; the script may not exist." : "Message sent but the target window responded with 0, which may mean it ignored it."
		DetectHiddenWindows, %a%
		SetTitleMatchMode, %b%
	}
}


; StringJoin(d,strings*)
; {
  ; for index,s in strings {
	; mos(index,s)
	; if(index>1){
		; ret .= d
	; }
	; ret .= s
  ; }
  ; return ret
; }


StringJoin(sep, params*) {
    for index,param in params
        str .= param . sep
    return SubStr(str, 1, -StrLen(sep))
}

normScriptName(s){
	if(!regexmatch(s,"i).ahk$"))
		s:=s ".ahk"
		return s
}
equalScript(s1,s2){
return !(normScriptName(s1) <>normScriptName(s2))
}

assureRunningScript(sname,funcname,params*){
	;mos(params)
	;ttos(a_scriptname,sname)
	
	if(!equalScript(a_scriptname,sname)){
		callInRunningScript(sname,funcname,params*)
		return false
	}else{
		return true
	}
}
toMoveCmd(fpath,  tfpath){
		;return toMoveCmd(fpath,  tfpath)
		dq = "
		cmd:="cmd /c move " . souroundWith(fpath,  dq) . " " . souroundWith(tfpath, dq) ;. "`""
		return cmd
	}


souroundWith(s, sr){
	r:= sr . s . sr
	return r
}
	
MyMoveFile(fpath,tfpath){

	SplitPath, tfpath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive






	IfNotExist, %OutDir%
	{
		IfExist, %OutDrive%
		{
			FileCreateDir, %OutDir%
		}
	}
	;mm("run " . cmd)
	;Clipboard:=cmd
	cmd:=movetoMenu.toCmd(fpath,tfpath)
	run ,%cmd%,,Hide,OutputVarPID
}
callInRunningScript(sname,funcname,params*){
	;mos(params)
	;mos(a_scriptname,sname,funcname,params)
	
	if(!equalScript(a_scriptname,sname)){
		pAsString:=StringJoin(",",params*)
		scndP:="fcL," funcname "," pAsString
		;mos(sname,pAsString, scndP)
		SendData(sname, scndP)	
		return true
	}else{
		%funcName%(params)
		return false
	}
}

getScriptNameFromId(id){

	wingettitle,title, ahk_id %id%
	sname := RegExReplace(title, "i).ahk", "")  
	;mos(sname)
	return sname
}

callInRunningScriptById(id,funcname,params*){
	callInRunningScript(getScriptNameFromId(id),funcname,params*)
}

calltoAllProc(funcname,params*){
	pAsString:=StringJoin(",",params*)
	lparam:="fcL," funcname "," pAsString
	;mos("lparam",lparam)
	sendToAllScripts(lparam)
	; a2 := A_DetectHiddenWindows, b2 := A_TitleMatchMode
	; DetectHiddenWindows, On
	; SetTitleMatchMode, Regex

	; WinGet, id,List,ahk_exe AutoHotkey.exe
	
	; Loop, %id%
	; {
		; id := id%A_Index%

		; ;ttos("call by id",id,funcname,params)
		; callInRunningScriptById(id,funcname,params*)
	; }
	
	; DetectHiddenWindows, %a2%
	; SetTitleMatchMode, %b2%

}




	









restart(fast:=""){
	s:= "restart" callstack()
	;MsgBox,%s$
	if(fast==""){
		fast:=DoFastRescue()
	}
	;run, C:\ProgrammeUser\AHK\AutoHotkeyResistents\init.cmd
	;tt("restart()")
	id:=WinExist("A")
	WinGet,ProcessName,ProcessName,ahk_id %id%
	if(ProcessName="SciTE.exe"){
	      
		;;send {LAlt up}{LCtrl up}
		sleep 50
		send {LCtrl Down}s{LCtrl up}
		   ;send ^s
		   ;foo
		sleep 100
	}
	

	ttos("hard rescue")
	run, C:\ProgrammeUser\AHK\AutoHotkeyResistents\init.cmd,,Hide
	ExitApp

}
getRoot(id){
	return getRootWin(id)
}

getAncestor(id,GA_SPEC){
	return DllCall("GetAncestor", "UInt", id, "UInt", GA_SPEC) ; GA_PARENT:1  GA_ROOT:2  GA_ROOTOWNER:3 
}
getRootWin(id){
	return getAncestor(id,2)
}
getParent(id){
	return getAncestor(id,1)
}

setScalingAware() {
	DllCall("SetThreadDpiAwarenessContext", "ptr", -2, "ptr")
	; -2 is not per monitor aware
	; -3 and -4 is per monitor aware. But the menu does not work correctly on another screen. It was told that ahk is not per monitor aware
}

getctid(only:=false){
	setScalingAware()
	global gCtId
	gCtId:=persistSetting()["gCtId"]
	
	clearGCtidIfOutdated()
;ttos(gCtId)
	if(isObject(gCtId)){
		id := getRoot(gCtId.id)
	}else if (!only) {
		id:=getWindowFromPoint(point.frommouse())
		id:=getRoot(id)
	}
	;tt(getWinInfobase(id))
	return id
}

getMouseWin(){
	id:=getctid()
	return id
}

minimize(id:=""){
	if(id==""){
		id:=getctid()
	}
	WinMinimize ,ahk_id %id%
}


maximize(id:=""){
	if(id==""){
		id:=getctid()
	}
	WinMaximize ,ahk_id %id%
}

setVarById(varName,val,id:=""){
return
	if(varName==""){
		ttos("setVarById",varName,val,id)

	}
	calltoAllProc("setVarByIdLoc",varName,val,id)
	;sendToAllScripts(("fcL,setVarByIdLoc," . varName,val,id))
}

setVarByIdLoc(varName,val,id:=""){
	global
	;mos("setVarByIdLoc",varName,val,id)
	if(id==""){
		MouseGetPos,x,y
		id:=getctid()
	}
	id:=id+1-1
	varNamet:= varName ID
	%varNamet% := val
	;tt("set " varNamet " to " yes)
}

getVarById(varName,id:=""){
	global
	if(id==""){
		MouseGetPos,x,y
		id:=getctid()
	}
	id:=id+1-1	
	varNamet:= varName ID
	val := %varNamet% 
	;mos(varNamet " is " val)
	return val
}

atan2(y,x) {	; 4-quadrant atan
   Return dllcall("msvcrt\atan2","Double",y, "Double",x, "CDECL Double")
}

pi(){
return 3.141592653589793238462643383279502884197169399375105820974944592 ; pi
}



getModKeyboardKeys() {
	static firstCall:=true
	static modKeys
	if (firstCall) {
		firstCall:=false
		modKeys:= Object()
		modKeys.push("LAlt")
		modKeys.push("LCtrl")
		modKeys.push("LShift")
	}
	
	return modKeys.clone()
}
getModMouseKeys() {
	static firstCall:=true
	static modKeys
	if (firstCall) {
		firstCall:=false
		modKeys:= Object()
		modKeys.push("LButton")
		modKeys.push("RButton") 
		modKeys.push("MButton")
	}
	
	return modKeys.clone()
}
getModKeys() {
	static firstCall:=true
	static modKeys
	if (firstCall) {
		firstCall:=false
		modKeys:= Object()
		modKeys.push(getModMouseKeys() )
		modKeys.push(getModKeyboardKeys())
	}
	
	return modKeys.clone()
}



fixStuckKeys(onlyifDown:=false){
	;return
	;mos("fixStuckKeys")
	;debugbreak()
	;mm(callstack())
	for index, element in getModKeyboardKeys()  
	{
		needsLift:=GetKeyState(element,"L") && !GetKeyState(element)
		if(needsLift||!onlyifDown){
			send {Blind}{%element% up}
		}
	}
	


	for index, element in getModMouseKeys()  
	{
		needsLift:=GetKeyState(element,"L") && !GetKeyState(element):=GetKeyState(element,"L") && !GetKeyState(element)
		;needsLift:=GetKeyState(element,"L") && !GetKeyState(element)
		if(needsLift){
			send {Blind}{%element% up}
		}
	}
}


isAnyKeyButtonPressed(){
	;return
	;mos("fixStuckKeys")
	;debugbreak()
	;mm(callstack())
	for index, element in getModKeyboardKeys()  
	{
		down:=GetKeyState(element,"L")
		if(down){
			return true
		}
	}
	


	for index, element in getModMouseKeys()  
	{
		down:=GetKeyState(element,"L")
		if(down){
			return true
		}
	}
	return false
}

rotateDegrees(angleStart,angleOffset){
	pi := 3.14159
	Angle:=angleStart+angleOffset
	normalized:=Mod(Angle, 360)
	return normalized
}

class point{
	__New(x:="",y:="",id:=""){
		if (x==""||y=="") {
			MouseGetPos,x,y
		}
		if(id==""){
			id:=getctid()
		}
		
		this.x:=x
		this.y:=y
		this.id:=id
	}
	
	fromMouse(){
		mouseGetPos,x,y,id
		return new Point(x,y,id)
		
	}
	
	fromNull(){
		return new Point(0,0)
	}
	
	subst(o){
		return new point(this.x-o.x,this.y-o.y)
	}

	add(o){
		return new point(this.x+o.x,this.y+o.y)
	}
mul(f){
		return new point(this.x*f,this.y*f)
	}
	
	round(){
		return new point(round(this.x),Round(this.y))
	}
	equal(o){
		return (this.x==o.x &&		this.y==o.y)
	}
	
	isNull() {
			return this.x==0 && this.y==0
	}
	
	applyChoord(o){
		this.x:=o.x
		this.y:=o.y
	}


	dist(o:="") {
		if(!o){
			o:=point.fromnull()
		}
		diff:=o.subst(this)
		
		;mos(diff)
		temp:=diff.x*diff.x + diff.y*diff.y 
		
		ret:=sqrt(temp)
		;MsgBox % tos(this) . tos(o) . tos(diff) . "disttt" . ret
		return ret
	}
	
	getClockwiseDegrees(centerP:="") {  ;from 0 to 1
		if(!centerP){
			centerP:=point.fromNull()
		}
		cycler:=this.subst(centerP)
		
		OneToMinusOne:=atan2(cycler.x, cycler.y) / pi()
		;return OneToMinusOne
		;;tt("OneToMinusOne : " . OneToMinusOne)
		ret := (OneToMinusOne*-1 + 1.0) * 180
		;tt(ret)
		return ret
	}
}

	
isPointInRect(p,r){
	if(p.x>=r.x&&p.x<=r.x+r.w && p.y>=r.y&&p.y<=r.y+r.h)
	{
	return true
	}
	return false
}

isPointOnRect(p,r){
	if( ((p.x==r.x||p.x==r.x+r.w-1) && p.y>=r.y && p.y<=r.y+r.h-1) || ((p.y==r.y|| p.y==r.y+r.h-1) && p.x>=r.x && p.x <=r.x+r.h-1 ))
	{
	return true
	}
	return false
}

isPointInWin(p,id){
	return isPointInRect(p,new rect(id))

}

class Beamer {
	rec() {
		return rect.fromChoord(0,0,1920,1080)
	}
}

getiw(r){
	onlys:=0.3
	if (r<onlys) {
		ret:=0
	}else if (r> 1-onlys) 
		ret:=2
	else{
		ret:=1
	}
	 return ret
}


class rect{

	__New(id:=""){
		if (id!="") {
			WinGetPos,lx,ly,lw,lh, ahk_id %id%
			this.x:=lx
			this.y:=ly
			this.w:=lw
			this.h:=lh
			this.i:=gettitle(id)
		} else {
			this.x:=0
			this.y:=0
			this.w:=0
			this.h:=0			
		}
		;tt(tos(this))
		return this
	}
	
	clone(){
		r:=new rect()
		r.x:=this.x
		r.y:=this.y
		r.w:=this.w
		r.h:=this.h
		
		return r
	}
	
	;~ __New(x,y,w,h){
			
			;~ this.x:=x
			;~ this.y:=y
			;~ this.w:=w
			;~ this.h:=h
			;~ return this
		;~ }
	;~ }
	inflate(d)
	{
		this.x:=this.x-d
		this.y:=this.y-d
		this.w:=this.w+2*d
		this.h:=this.h+2*d
	}
	inflatefact(f,mrx,mry,rStart,limitW, limitH)	{
		;mos(f,mrx,mry,ratio,limitW, limitH)

		;thisold:=tos(this)
		
		wnew:=rStart.w*f
		hnew:=rStart.h*f
		
		dw:=rStart.w-wnew
		dh:=rStart.h-hnew

		; dwHalf:=dw/2
		; dhHalf:=dh/2

		wnew:=min(wnew,limitW)
		hnew:=min(hnew,limitH)
		
		this.x:=rStart.x + mrx*rStart.w - mrx*wnew
		this.y:=rStart.y + mry*rStart.h - mry*hnew

		this.w:=wnew
		this.h:=hnew
		;thisafter:=tos(this)
		;listlines
		;pause
	}
	
	
	fromChoord(x,y,w,h){
		ret:= new rect()
		ret.x:=x
		ret.y:=y
		ret.w:=w
		ret.h:=h
		;ttt("fc:" . ret)
		return ret
	}
	
	samesize(other) {
		if(this.w==other.w && this.h==other.h) {
			return true
		}
		return false
	}
	
	samepos(other) {
		if(this.x==other.x && this.y==other.y) {
			return true
		}
		return false
	}
	equal(other) {
		if(this.samesize(other) && this.samepos(other)) {
			;tt(A_AhkPath)
			return true
		}
		;tt("A_AhkPath")
		return false
	}
	containsPoint(p){
		return isPointInRect(p,this)
	}
	
	isNull(){
		msgbox % "reviw w&"
		if(this.x && this.y) {
			return false
		}
		return true
	}
	
	getCenter(){
		tmp:=this.pointFromRel(0.5,0.5)
		
		return tmp.round()
	}
	
	covers(otherRect){
		ret:=(this.x<=   otherRect.x)
		&&(this.y<=   otherRect.y)
		&&(this.w>=   otherRect.w)
		&&(this.h>=   otherRect.h)
		;mos(ret,this,otherRect)
		return ret
	}
	getRatio(){
		ret:=this.w / this.h
		return ret
	}
	applyChoord(o){
			this.x:=o.x
			this.y:=o.y
			this.w:=o.w
			this.h:=o.h
	}
	centerOn(p){
		ret:=this.clone()
		ret.x:=p.x-round(ret.w/2)
		ret.y:=p.y-round(ret.h/2)
		return ret
	}
	x2(){
		return this.x+this.w
	}
	y2(){
		return this.y+this.h
	}
	pointFromRel(rx,ry){
		return new point(this.x+this.w*rx,this.y+this.h*ry)
	}
	round(){
		c:=this.clone()
		c.x:=round(this.x)
		c.y:=round(this.y)
		c.w:=round(this.w)
		c.h:=round(this.h)
		return c
	}
	
	keepInRect(rec,b){
		ret:=this.clone()
		
		d:=ret.x2()+b-rec.x2()
		if(d>0){
			ret.x:=ret.x-d
		}
		
		d:=ret.y2()+b-rec.y2()
		if(d>0){
			ret.y:=ret.y-d
		}
		
		d:=rec.y+b-ret.y
		if(d>0){
			ret.y:=ret.y+d
		}
		
		d:=rec.x+b-ret.x
		if(d>0){
			ret.x:=ret.x+d
		}
		
		return ret
	
	}
	
	
	isFullScreen(){
		mos("TODO")
		rs:=callfunc("rectfromScreen")
		ret:= this.covers(rs)
		;mos(rs,this,ret)
		return ret
	}
}

equalrect(r1,r2){
	ret:=r1.w==r2.w && r1.h==r2.h && r1.x==r2.x && r1.y==r2.y
	return ret
}



class WinRect {
	;~ rect:=""
	;~ id:=0
	;~ Style:=0
	;~ ExStyle:=0
	;~ top:=0
	;~ trans:=0


	__New(id:=""){
		if (id=="") {
			MouseGetPos,,,id
		}
		this.rect:=new rect(id)
		this.id:=id
		WinGet, lStyle, Style, ahk_id %id%
		WinGet, lExStyle, ExStyle, ahk_id %id%
		this.Style:=lStyle
		this.ExStyle:=lExStyle
		this.top:=istopmost(id)
		this.trans:=gettrans(id)
		return this
	}
	restorePosSize(){
		;tt("restorePosSize")
		this.movetorect(this.rect)
	}
	
	moveIDtorect(id,rect){
		;tt(tos(this.rect))
		WinMove, % "ahk_id " id,,rect.x, rect.y,rect.w,rect.h
	}
	
	movetorect(rect){
		WinRect.moveIDtorect(this.id,rect)
	}
}


class PointWatch {
	
	class Job {
		pw:=""
		
		__New(){
			
		}
		
		onpos(){
		}
		offpos(){
		}
	}
	
	class Oncejob extends PointWatch.Job {
		called:=false
		
		__New(){
			base.__New()
		}
		
		onpos(){
			if(!this.called && this.canRun()){
				this.doJob()
				this.called:=true
			}
		}
		offpos(){
			this.init()
		}
		init(){
			this.called:=false
		}
		canRun(){
			return true
		}
	}

	p := ""
	onPosTime := 0
	
	jobs := Object()
	
	__New(p){
		this.p:=p
		this.init()
		;mos(this, callstack())
		;return this
	}
	
	addJob(job) {
		;mos(job)
		job.pw := this
		this.jobs.push(job)
	}
	
	init(){
		this.onPosTime:=0
	}
	
	update(np){
		if(this.p.equal(np)){
			if(this.onPosTime==0){
				this.onPosTime:=A_TickCount
			}
			for index,job in this.jobs {
				job.onPos()
			}
			
		} else{
			for index,job in this.jobs {
				job.offPos()
			}
		}
	}
}

initFullFunc(kill:=true) {
	global
	 tt("INITFULL")
	Run,C:\ProgrammeUser\AHK\AutoHotkeyResistents\init.cmd,C:\ProgrammeUser\AHK\AutoHotkeyResistents
	return
	
}

RestartStrokeItFunc(){

	RunWait taskkill.exe /im strokeit.exe /F,,Hide
	run,C:\Program Files (x86)\TCB Networks\StrokeIt\strokeit.exe,C:\Program Files (x86)\TCB Networks\StrokeIt
}

mpcsend_Open_File(id:="") {
mpcsend( 800 ,id)
}
mpcsend_Open_DVD(id:="") {
mpcsend( 801 ,id)
}
mpcsend_Open_Device(id:="") {
mpcsend( 802 ,id)
}
mpcsend_Save_As(id:="") {
mpcsend( 805 ,id)
}
mpcsend_Save_Image(id:="") {
mpcsend( 806 ,id)
}
mpcsend_Save_Image_auto(id:="") {
mpcsend( 807 ,id)
}
mpcsend_Load_Subtitle(id:="") {
mpcsend( 809 ,id)
}
mpcsend_Save_Subtitle(id:="") {
mpcsend( 810 ,id)
}
mpcsend_Close(id:="") {
mpcsend( 804 ,id)
}
mpcsend_Properties(id:="") {
mpcsend( 814 ,id)
}
mpcsend_Exit(id:="") {
mpcsend( 816 ,id)
}
mpcsend_Play_Pause(id:="") {
mpcsend( 889 ,id)
}
mpcsend_Play(id:="") {
mpcsend( 887 ,id)
}
mpcsend_Pause(id:="",post:=false) {
mpcsend( 888 ,id,post)
}
mpcsend_Stop(id:="") {
mpcsend( 890 ,id)
}
mpcsend_Framestep(id:="") {
mpcsend( 891 ,id)
}
mpcsend_Framestep_back(id:="") {
mpcsend( 892 ,id)
}
mpcsend_Go_To(id:="") {
mpcsend( 893 ,id)
}

rateNormal(id,val){
	;tt("rateNormal:script:" . A_ScriptName . " id:" . id . " val:" . val)
	
	post:=false
	if (val!=0) {
		if (val>0) {
			mpcsend( 895 ,id,post)
		}else{
			mpcsend( 894 ,id,post)
		}
	} else{
		mpcsend( 896 ,id,post)
		setVarById("rateNormal",true,id)
	}

}


mpcsend_Increase_Rate(id) {
	rateNormal(id,1)
}
mpcsend_Decrease_Rate(id) {
	rateNormal(id,-1)
}


mpcsend_Reset_Rate(id) {
	rateNormal(id,0)
}

mpcsend_Audio_Delay_ADD_10ms(id:="") {
mpcsend( 905 ,id)
}
mpcsend_Audio_Delay_SUB_10ms(id:="") {
mpcsend( 906 ,id)
}
mpcsend_Jump_Forward_small(id:="") {
mpcsend( 900 ,id)
}
mpcsend_Jump_Backward_small(id:="") {
mpcsend( 899 ,id)
}
mpcsend_Jump_Forward_medium(id:="") {
mpcsend( 902 ,id)
}
mpcsend_Jump_Backward_medium(id:="") {
mpcsend( 901 ,id)
}
mpcsend_Jump_Forward_large(id:="") {
mpcsend( 904 ,id)
}
mpcsend_Jump_Backward_large(id:="") {
mpcsend( 903 ,id)
}
mpcsend_Jump_Forward_keyframe(id:="") {
mpcsend( 898 ,id)
}
mpcsend_Jump_Backward_keyframe(id:="") {
mpcsend( 897 ,id)
}
mpcsend_Next(id:="") {
mpcsend( 922 ,id)

}
mpcsend_Previous(id:="") {

mpcsend( 921 ,id)

}
mpcsend_Next_Playlist_Item(id:="") {
mpcsend( 920 ,id)
}
mpcsend_Previous_Playlist_Item(id:="") {
mpcsend( 919 ,id)
}
mpcsend_Toggle_CaptionMenu(id:="") {
mpcsend( 817 ,id)
}
mpcsend_Toggle_Seeker(id:="") {
mpcsend( 818 ,id)
}
mpcsend_Toggle_Controls(id:="") {
mpcsend( 819 ,id)
}
mpcsend_Toggle_Information(id:="") {
mpcsend( 820 ,id)
}
mpcsend_Toggle_Statistics(id:="") {
mpcsend( 821 ,id)
}
mpcsend_Toggle_Status(id:="") {
mpcsend( 822 ,id)
}
mpcsend_Toggle_Subresync_Bar(id:="") {
mpcsend( 823 ,id)
}
mpcsend_Toggle_Playlist_Bar(id:="") {
mpcsend( 824 ,id)
	;mos()
}
mpcsend_Toggle_Capture_Bar(id:="") {
mpcsend( 825 ,id)
}
mpcsend_Toggle_Shader_Editor_Bar(id:="") {
mpcsend( 826 ,id)
}
mpcsend_View_Minimal(id:="") {
mpcsend( 827 ,id)
}
mpcsend_View_Compact(id:="") {
mpcsend( 828 ,id)
}
mpcsend_View_Normal(id:="") {
mpcsend( 829 ,id)
}
mpcsend_Fullscreen(id:="") {
	;tt("mpcsend_Fullscreen")
mpcsend( 830 ,id)
}
mpcsend_Fullscreen_w_o_res_change(id:="") {
mpcsend( 831 ,id)
}
mpcsend_Zoom_50(id:="") {
mpcsend( 832 ,id)
}
mpcsend_Zoom_100(id:="") {
mpcsend( 833 ,id)
}
mpcsend_Zoom_200(id:="") {
mpcsend( 834 ,id)
}
mpcsend_Zoom_Auto_Fit(id:="") {
mpcsend( 967 ,id)
}
mpcsend_Next_AR_Preset(id:="") {
mpcsend( 860 ,id)
}
mpcsend_VidFrm_Half(id:="") {
mpcsend( 835 ,id)
}
mpcsend_VidFrm_Normal(id:="") {
mpcsend( 836 ,id)
}
mpcsend_VidFrm_Double(id:="") {
mpcsend( 837 ,id)
}
mpcsend_VidFrm_Stretch(id:="") {
mpcsend( 838 ,id)
}
mpcsend_VidFrm_Inside(id:="") {
mpcsend( 839 ,id)
}
mpcsend_VidFrm_Outside(id:="") {
;debugbreak()
;Mos(callstack(),"mpcsend_VidFrm_Outside")
mpcsend( 840 ,id,false)
}
mpcsend_Always_On_Top(id:="") {
mpcsend( 884 ,id)
}
mpcsend_PnS_Reset(id:="") {
;Mos(callstack(),"mpcsend_PnS_Reset")
mpcsend( 861 ,id,false)
}
mpcsend_PnS_Inc_Size(id:="") {
mpcsend( 862 ,id)
}
mpcsend_PnS_Inc_Width(id:="") {
mpcsend( 864 ,id)
}
mpcsend_PnS_Inc_Height(id:="") {
mpcsend( 866 ,id)
}
mpcsend_PnS_Dec_Size(id:="") {
mpcsend( 863 ,id)
}
mpcsend_PnS_Dec_Width(id:="") {
mpcsend( 865 ,id)
}
mpcsend_PnS_Dec_Height(id:="") {
mpcsend( 867 ,id)
}
mpcsend_PnS_Center(id:="") {
mpcsend( 876 ,id)
}
mpcsend_PnS_Left(id:="") {
mpcsend( 868 ,id)
}
mpcsend_PnS_Right(id:="") {
mpcsend( 869 ,id)
}
mpcsend_PnS_Up(id:="") {
mpcsend( 870 ,id)
}
mpcsend_PnS_Down(id:="") {
mpcsend( 871 ,id)
}
mpcsend_PnS_Up_Left(id:="") {
mpcsend( 872 ,id)
}
mpcsend_PnS_Up_Right(id:="") {
mpcsend( 873 ,id)
}
mpcsend_PnS_Down_Left(id:="") {
mpcsend( 874 ,id)
}
mpcsend_PnS_Down_Right(id:="") {
mpcsend( 875 ,id)
}

mpcsend_PnS_Rotate_X(up,id:="") {
	if (up) {
		mpcsend_PnS_Rotate_XADD(id)
	}
	else {
		mpcsend_PnS_Rotate_XSUB(id)
	}
}

mpcsend_PnS_Rotate_XADD(id:="") {
mpcsend( 877 ,id)
}
mpcsend_PnS_Rotate_XSUB(id:="") {
mpcsend( 878 ,id)
}


mpcsend_PnS_Rotate_Y(up,id:="") {
	if (up) {
		mpcsend_PnS_Rotate_YADD(id)
	}
	else {
		mpcsend_PnS_Rotate_YSUB(id)
	}
}

mpcsend_PnS_Rotate_YADD(id:="") {
mpcsend( 879 ,id)
}
mpcsend_PnS_Rotate_YSUB(id:="") {
mpcsend( 880 ,id)
}


mpcsend_PnS_Rotate_Z(up,id:="") {
	if (up) {
		mpcsend_PnS_Rotate_ZADD(id)
	}
	else {
		mpcsend_PnS_Rotate_ZSUB(id)
	}
}

mpcsend_PnS_Rotate_ZADD(id:="") {
mpcsend( 881 ,id)
}
mpcsend_PnS_Rotate_ZSUB(id:="") {
mpcsend( 882 ,id)
}
mpcsend_Volume_Up(id:="") {
mpcsend( 907 ,id)
}
mpcsend_Volume_Down(id:="") {
mpcsend( 908 ,id)
}
mpcsend_Volume_Mute(id:="") {
mpcsend( 909 ,id)
}
mpcsend_Volume_boost_increase(id:="") {
;tt("mpcsend_Volume_boost_increase")
mpcsend( 969 ,id)
}
mpcsend_Volume_boost_decrease(id:="") {
	;tt("mpcsend_Volume_boost_decrease")
mpcsend( 970 ,id)
}
mpcsend_Volume_boost_Min(id:="") {
mpcsend( 971 ,id)
}
mpcsend_Volume_boost_Max(id:="") {
mpcsend( 972 ,id)
}
mpcsend_DVD_Title_Menu(id:="") {
mpcsend( 922 ,id)
}
mpcsend_DVD_Root_Menu(id:="") {
mpcsend( 923 ,id)
}
mpcsend_DVD_Subtitle_Menu(id:="") {
mpcsend( 924 ,id)
}
mpcsend_DVD_Audio_Menu(id:="") {
mpcsend( 925 ,id)
}
mpcsend_DVD_Angle_Menu(id:="") {
mpcsend( 926 ,id)
}
mpcsend_DVD_Chapter_Menu(id:="") {
mpcsend( 927 ,id)
}
mpcsend_DVD_Menu_Left(id:="") {
mpcsend( 928 ,id)
}
mpcsend_DVD_Menu_Right(id:="") {
mpcsend( 929 ,id)
}
mpcsend_DVD_Menu_Up(id:="") {
mpcsend( 930 ,id)
}
mpcsend_DVD_Menu_Down(id:="") {
mpcsend( 931 ,id)
}
mpcsend_DVD_Menu_Activate(id:="") {
mpcsend( 932 ,id)
}
mpcsend_DVD_Menu_Back(id:="") {
mpcsend( 933 ,id)
}
mpcsend_DVD_Menu_Leave(id:="") {
mpcsend( 934 ,id)
}
mpcsend_Boss_key(id:="") {
mpcsend( 943 ,id)
}
mpcsend_Player_Menu_short(id:="") {
mpcsend( 949 ,id)
}
mpcsend_Player_Menu_long(id:="") {
mpcsend( 950 ,id)
}
mpcsend_Filters_Menu(id:="") {
mpcsend( 951 ,id)
}
mpcsend_Options(id:="") {
mpcsend( 886 ,id)
}
mpcsend_Next_Audio(id:="") {
mpcsend( 951 ,id)
}
mpcsend_Prev_Audio(id:="") {
mpcsend( 952 ,id)
}
mpcsend_Next_Subtitle(id:="") {
mpcsend( 953 ,id)
}
mpcsend_Prev_Subtitle(id:="") {
mpcsend( 954 ,id)
}
mpcsend_On_Off_Subtitle(id:="") {
mpcsend( 955 ,id)
}
mpcsend_Reload_Subtitles(id:="") {
mpcsend( 2302 ,id)
}
mpcsend_Next_Audio_OGM(id:="") {
mpcsend( 956 ,id)
}
mpcsend_Prev_Audio_OGM(id:="") {
mpcsend( 957 ,id)
}
mpcsend_Next_Subtitle_OGM(id:="") {
mpcsend( 958 ,id)
}
mpcsend_Prev_Subtitle_OGM(id:="") {
mpcsend( 959 ,id)
}
mpcsend_Next_Angle_DVD(id:="") {
mpcsend( 960 ,id)
}
mpcsend_Prev_Angle_DVD(id:="") {
mpcsend( 961 ,id)
}
mpcsend_Next_Audio_DVD(id:="") {
mpcsend( 962 ,id)
}
mpcsend_Prev_Audio_DVD(id:="") {
mpcsend( 963 ,id)
}
mpcsend_Next_Subtitle_DVD(id:="") {
mpcsend( 964 ,id)
}
mpcsend_Prev_Subtitle_DVD(id:="") {
mpcsend( 965 ,id)
}
mpcsend_On_Off_Subtitle_DVD(id:="") {
mpcsend( 966 ,id)
}
mpcsend_Tearing_Test(id:="") {
mpcsend( 32769 ,id)
}
mpcsend_Remaining_Time(id:="") {
mpcsend( 32778 ,id)
}
mpcsend_Toggle_Pixel_Shader(id:="") {
mpcsend( 1021 ,id)
}
mpcsend_Toggle_Screen_Shader(id:="") {
mpcsend( 1022 ,id)
}
mpcsend_Toggle_Direct3D_fullscreen(id:="") {
mpcsend( 32779 ,id)
}
mpcsend_Goto_Prev_Subtitle(id:="") {
mpcsend( 32780 ,id)
}
mpcsend_Goto_Next_Subtitle(id:="") {
mpcsend( 32781 ,id)
}
mpcsend_Shift_Subtitle_Left(id:="") {
mpcsend( 32782 ,id)
}
mpcsend_Shift_Subtitle_Right(id:="") {
mpcsend( 32783 ,id)
}
mpcsend_Display_Stats(id:="") {
mpcsend( 1042 ,id)
}
mpcsend_Subtitle_Delay_SUB(id:="") {
mpcsend( 24000 ,id)
}
mpcsend_Subtitle_Delay_ADD(id:="") {
mpcsend( 24001 ,id)
}
mpcsend_Save_thumbnails(id:="") {
mpcsend( 808 ,id)
}
mpcsend_frametimecorrection(id:="") {
mpcsend( 33265 ,id)
}
mpcsend_VSync(id:="") {
mpcsend( 33243 ,id)
}
mpcsend_AccurateVSync(id:="") {
mpcsend( 33260,id)
}
mpcsend_IncVSyncOffset(id:="") {
mpcsend( 33247,id)
}
mpcsend_DecVSyncOffset(id:="") {
mpcsend( 33246,id)
}


mpcsend_Bright(up,id:="",post:=false) {
	if (up) {
		mpcsend_BrightADD(id,post)
	}
	else {
		mpcsend_BrightSUB(id,post)
	}
}




mpcsend_BrightADD(id:="",post:=false) {
;tt("mpcsend_BrightADD")
;return
setvarbyid("colorNormal",false,id)
mpcsend( 984,id,post)
}
mpcsend_BrightSUB(id:="",post:=false) {

;;tt("mpcsend_BrightubbD")
;return	
setvarbyid("colorNormal",false,id)
mpcsend( 985,id,post)
}


mpcsend_Contrast(up,id:="",post:=false) {
	if (up) {
		mpcsend_ContrastADD(id,post)
	}
	else {
		mpcsend_ContrastSUB(id,post)
	}
}
mpcsend_ContrastADD(id:="",post:=false) {
	;tt("ADDDDD")
	;return
	setvarbyid("colorNormal",false,id)
	mpcsend( 986,id,post)
}
mpcsend_ContrastSUB(id:="",post:=false) {
	;;tt("SUBBB")
	;return
	setvarbyid("colorNormal",false,id)
	mpcsend( 987,id,post)
}

mpcsend_Sat(up,id:="",post:=false) {
	if (up) {
		mpcsend_SatADD(id,post)
	}
	else {
		mpcsend_SatSUB(id,post)
	}
}
mpcsend_SatADD(id:="",post:=false) {
	setvarbyid("colorNormal",false,id)
mpcsend( 990,id,true)
}
mpcsend_SatSUB(id:="",post:=false) {
	setvarbyid("colorNormal",false,id)
mpcsend( 991,id,true)
}

mpcsend_farbton(up,id:="",post:=false) {
	if (up) {
		mpcsend_farbtonADD(id,post)
	}
	else {
		mpcsend_farbtonSUB(id,post)
	}
}
mpcsend_farbtonADD(id:="",post:=false) {
	setvarbyid("colorNormal",false,id)
mpcsend( 988,id,true)
}
mpcsend_farbtonSUB(id:="",post:=false) {
	setvarbyid("colorNormal",false,id)
mpcsend( 989,id,true)
}

mpcsend_ColorReset(id:="",force:=false) {
	;tt("mpcsend_ColorReset")
	if(!getvarbyid("colorNormal",id) || force){
		setvarbyid("colorNormal",true,id)
		mpcsend( 992,id,true)
	}
	;funcName:="activatePreShaders"
	;%funcName%(id,false,"foo")
	;activatePreShaders(mid,false,s)
}
;~ mpcsend_(id:="") {
;~ mpcsend(  ,id)
;~ }
;~ mpcsend_(id:="") {
;~ mpcsend(  ,id)
;~ }

isIdFromExe(id,ss){
	WinGet,ProcessName,ProcessName,ahk_id %id%
	if(ProcessName=ss){
	    return id
	}Else{
		Return 0
	}
}
isPreviewwin(id){
	WinGetTitle,t,ahk_id %id%
	ss:=Substr(t,3,1)
	if (StrLen(t)==8 && ss==":") {
		;mos(t,"isPreviewwin")
		return true
	}
	return false

}
ismpcwin(id){
	WinGet,ProcessName,ProcessName,ahk_id %id%
	ret:=((ProcessName="mpc-be64.exe")||(ProcessName="mpc-hc64.exe")||(ProcessName="mpc-hc.exe")||(ProcessName="mpc-be.exe")||(ProcessName="zplayer.exe"))
	&& !isPreviewwin(id)
	
	
	return ret
	
}

ismpcwinVideo(id){
	WinGetClass, cls, ahk_id %id%
	if (cls=="MPC-BE") {
		return true
	}
	return false
}

mpcSend(msg,id:="",post:=false) {
	if(id==""){
		MouseGetPos,x,y
		id:=getctid()
	}
	;ttos("mpcSend",getwininfobase(id),msg)
	if (!isMPCWin(id)) {
		cs:=callstack()
		WinGetTitle,t,ahk_id %id%
	
		;info:=getwininfo(id)
		;msgbox,%t%    not mpcwin %cs%     
		return
	}
	
	
	
	; For "msg" use a number from the list of commands at the bottom of the page.
	;tt("mpcSend msg " msg "  id" id)
	if (post) {
		PostMessage,0x0111,msg,,,ahk_id %id% ; MediaPlayerClassicW
	}
	else{
		SendMessage,0x0111,msg,,,ahk_id %id% ; MediaPlayerClassicW
	}	
	
	;
}

getWindowFromPointExact(x,y) {

	
	x:=Round(x)
	y:=Round(y)

	; ttos(x,y,callstack())
	
	if (Is64Bit()) {
		if( !isInteger(x) || !isInteger(y)    ){
			mos(x,y)
		}
		Old_IsCritical := A_IsCritical 
		Critical,100
		VarSetCapacity(xt,8)
		VarSetCapacity(yt,8)
		VarSetCapacity(p,8)
		xt:=x
		yt:=y
		p:= xt | (yt << 32)
		VarSetCapacity(id,8)
		id := DllCall("WindowFromPoint", "int64", p, "ptr")
		;id := DllCall("WindowFromPoint", "int64", x | (y << 32), "ptr")
		Critical %Old_IsCritical%
	}
	else {
		id:= DllCall( "WindowFromPoint", "int", x, "int", y )

	}
	
	return id
}


getWindowFromPoint(x,y:="") {
	if (y=="") {
		y:=x.Y
		x:=x.x
	}
	x:=x+0
	y:=y+0
	id:= getWindowFromPointExact(x,y)
	
	rid:= getRootWin(id)
	; ttos("getWindowFromPoint",x,y,getWinInfobase(id),getWinInfobase(rid))
	return rid
}



CallStack(deepness = 5, printLines = 1)
{
	loop % deepness
	{
		lvl := -1 - deepness + A_Index
		oEx := Exception("", lvl)
		oExPrev := Exception("", lvl - 1)
		FileReadLine, line, % oEx.file, % oEx.line
		if(oEx.What = lvl)
			continue
		stack .= (stack ? "`n" : "") "File '" oEx.file "', Line " oEx.line (oExPrev.What = lvl-1 ? "" : ", in " oExPrev.What) (printLines ? ":`n" line : "") "`n"
	}
	return stack
}

hasVisibleStyle(id){
	winget, Style, style, ahk_id %id%
		visible:=(style&0x10000000)!=0
		return visible
}

getStartButton(){
	winget,id,id, Start ahk_class Button
	return id
}
gettasklist() {
	WinGet,id,id,ahk_class Shell_TrayWnd
	return id
}
stb(onTop:=true,trans:=120) {
	;tt("stb")
	id:=gettasklist()
	if(id){
		if (!hasVisibleStyle(id)) {
			WinShow, ahk_id %id%
		}
		
		WinActivate, ahk_id %id%
		if (onTop) {
			WinSet, AlwaysOnTop, ON, ahk_id %id%
		}	
		removetrancparency(id)
		
		;settrans(trans,id)		
	}
	id:=getStartButton()
	winshow, ahk_id %id%

}


ctTransTime(){
	return 1500
}

removetrancparency(id,fader:=""){
	DetectHiddenWindows, on
	WinSet, ExStyle, -0x00000020, AHK_id %id% ;,WS_EX_TRANSPARENT          := 
	WinSet, ExStyle, -0x00080000, AHK_id %id% ;WS_EX_LAYERED := 
	if(fader){
		fader.(id,255,ctTransTime())
	}else{
		WinSet, Transparent, 255, AHK_id %id%
	}
	
	WinSet, TransColor, Off, ahk_id %id%

	DllCall("RedrawWindow", "Uint", id, "Uint", 0, "Uint", 0, "Uint", RDW_ERASE:=0x0004|RDW_INVALIDATE:=0x0001|RDW_FRAME:=0x0400|RDW_ALLCHILDREN:=0x0080)
}


isTrans(id){
	WinGet, Transparent, Transparent,ahk_id %id%
	if(Transparent="") {
		Return False
	}
	Return True
}

getTrans(id){
	WinGet, Transparent, Transparent,ahk_id %id%
	if(Transparent="") {
		Transparent:=256
	}
	Return Transparent
}

settrans(d,id){
	;setVarById("lastSettrans",d,id)
	;nv:=getvarbyid("lastSettrans",id)
	;mos(d,nv)
	;mos("settrans" . d . callstack())
	WinGet, TransColor, TransColor, ahk_id %id% 
	if(d>255){
		d:=255
		if(istrans(id) && !isclickthrough(id)){ ;
			if (TransColor==""){
				WinSet, Transparent,Off,ahk_id %id%
			}Else{
				WinSet, TransColor, %TransColor% 255, ahk_id %id%
			}
		}
	}else{
		
		if(!istrans(id)){
			;ToolTip TransparentOn
			WinSet,ExStyle,+0x00080000,AHK_id %id%
			;WinSet, Transparent,ON,ahk_id %id%
		}
		
		if(d<1){
			d:=1
		} 
		d:=round(d)
		if (TransColor==""){
			WinSet, Transparent,%d%,ahk_id %id%
		}Else{
			WinSet, TransColor, %TransColor% %d%, ahk_id %id%
		}
		;mm(callstack())
	}
}


newline(){
	return "`n"
}
sendToAllScripts(lParam){
	;mos("sendToAllScripts called lParam:" lParam)
	a2 := A_DetectHiddenWindows, b2 := A_TitleMatchMode
	DetectHiddenWindows, On
	SetTitleMatchMode, Regex

	WinGet, id,List,ahk_exe AutoHotkey.exe
	
	Loop, %id%
	{
		id := id%A_Index%
		wi:=getWinInfobase(id)
		s.= newline() newline() wi
		senddata(getScriptNameFromId(id),lParam)
		
		
		; SendMessage, 0x4a, 0, &c, , ahk_id %id% ; edit this regular expression to your liking
		; If (ErrorLevel <> True) and UseError
			; MsgBox, 262160, %A_ScriptName% - %A_ThisFunc%(): Error, % "ErrorLevel:`t" ErrorLevel "`n" ErrorLevel ? "Script  %wi%  did not receive the message; the script may not exist." : "Message sent but the target window responded with 0, which may mean it ignored it."
		
		
		
	}
	
	DetectHiddenWindows, %a2%
	SetTitleMatchMode, %b2%
	
	;msgbox, % s

}

baseexitallapps(){
	callInRunningScript("KeepRunning2","KRExit")
	calltoAllProc("baseExitApp")
}

baseExitApp(){
	ExitApp
}

RemoveAll(AssocArray) {
	ListOfKeysToRemove := []			; helper object in which we'll store names of all keys of AssocArray to remove
	For k in AssocArray
		ListOfKeysToRemove.push(k)	; build list
	For k,v in ListOfKeysToRemove
		AssocArray.Remove(v)			; remove all keys from AssocArray
}	



MyGet(this ,Key){
	mos(this,Key)
	if("__hv"=Key){
		return this.base.__hv
	}
	ooo:=this.base.__hv.obj
	mos(ooo)
	if(ooo.haskey(Key)){
		return ooo[Key]
	}else{
		return 0
	}

}
MySet(this,Key,Value){
	mos(this,Key,Value) ;this.base
	;mos(this.__hv)
	ooo:=this.__hv.obj
	mos(ooo)
	;__hv.obj[Key]:=Value
	ObjInsert(ooo,Key,Value)
	mos(Key)
	;ObjtoFile(this.base.__hv.obj,this.base.__hv.fpath)
	return Value
}
;MyCall(this, Name [, Params...])

MyRemoveAll(this){
	__hv.obj:=Object()
}
conBase(path){
	baseObj := { __Get: Func("MyGet"), __Set: Func("MySet"),__hv: {obj:Object(),fpath:path}}
	return baseObj
}
normalizeMaxPlaying(maxPlaying){
	if maxPlaying is not integer
		def:=true
	else if (maxPlaying<0	)
		def:=true
	if(def){
		return 3
	}
	
	return maxPlaying
}

getmaxplaying(){
	mp:=persistSetting()["MaxPlaying"]
	return normalizeMaxPlaying(mp) 
}

query(defaul,c,tout){
fn:="keyboard"
%fn%()
;keyboard()
title=AhkQuery %title%
InputBox, locvar , %title%,%title%,,,,,,,%tout%,%defaul%
		o := Object()
		
		if( ErrorLevel !=0 ){
			o["Cancel"]:=true
		}
		o["value"]:=locvar
		
		WinHide, ahk_exe osk.exe
		
		return o
}
setmaxplaying(maxPlaying:="",adjust:=false){


	;mos("setmaxplaying" maxPlaying adjust)
	if(maxPlaying==""){
		;keyboard()
		
		mp:=getmaxplaying()
		r:=query(mp,"setmaxplaying",15)
		maxplaying:=r["value"]
		maxPlaying:=normalizeMaxPlaying(maxPlaying)
		
	}
	persistSetting()["MaxPlaying"]:=maxPlaying
	;mos(mp,maxPlaying)
	;if(mp!=maxPlaying){
	if(1){
		;sendToAllScripts("fcL,setmaxplayingloc," . maxPlaying)
		if(adjust){
			fn:=Func("setMaxPlayingAdjust")
			fn.(maxPlaying)
		}

	}
}


playLastN(n){

}

setmaxplayingloc(maxPlaying){
	global gMaxPlaying:=maxPlaying
}

class _Object {
    Remove(prm*) {
        if prm.MaxIndex() = 1 {
            k := prm[1]
            if k is integer
                return ObjRemove(k, "")
        }
        return ObjRemove(prm*)
    }
}

activeMonitorInfo( ByRef X, ByRef Y, ByRef Width,  ByRef  Height  )
{ ; retrieves the size of the monitor, the mouse is on
	
	CoordMode, Mouse, Screen
	MouseGetPos, mouseX , mouseY
	SysGet, monCount, MonitorCount
	Loop %monCount%
    { 	SysGet, curMon, Monitor, %a_index%
        if ( mouseX >= curMonLeft and mouseX <= curMonRight and mouseY >= curMonTop and mouseY <= curMonBottom )
		{
			X      := curMonTop
			y      := curMonLeft
			Height := curMonBottom - curMonTop
			Width  := curMonRight  - curMonLeft
			return
		}
    }
}

isInteger(p){
	if p is Integer
		return true
	return false
}


getExplorerWinOfClover(id){
	WinGet, ActiveControlList, ControlListHwnd, ahk_id %id%
	mos(ActiveControlList)
	obs:=Object()

	Loop, Parse, ActiveControlList,`n,
	{
		cid:=A_LoopField
		WinGetClass, class, ahk_id %cid%
		if(class=="CabinetWClass"){
			return cid
		}
		obs.push(cid . " " . class)
		;MsgBox, 4,, id %id% is %class%
		
	}
	;mos(obs)
	mos("exp win not fou",ActiveControlList)
	return ""
}

setTopMost(id,top){
	if(!top && ismpcwin(id)){
		mos("test player always on top")
		top:=true
	}
	WinGetTitle, thistit, ahk_id %id%
;	wi:=getwininfo(id)
	;ttos(thistit)
	WinGetClass, class, ahk_id %id%
	if(class=="Clover_WidgetWin_0"){
			;eid:=getExplorerWinOfClover(id)
			;mos("eid of cid",id,eid)
			
	}
	
	if(top){
		;tt(callstack())
		WinSet, AlwaysOnTop, On,ahk_id %id%
		if(eid){
			;WinSet, AlwaysOnTop, On,ahk_id %eid%
			oldP:=DllCall( "SetParent", "uint", eid, "uint", 0 )
			WinSet, ExStyle,+0x00000008,ahk_id %eid%
			DllCall( "SetParent", "uint", eid, "uint", oldP )
		}
		;winset,Top,,ahk_id %id%
		
	}Else{
		WinSet, AlwaysOnTop, Off,ahk_id %id%
		if(eid){
			WinSet, AlwaysOnTop, Off,ahk_id %eid%
		}
	}
}


SWP_ASYNCWINDOWPOS(){
Return 0x4000
}

SWP_DEFERERASE(){
Return 0x2000
}

SWP_DRAWFRAME(){
Return 0x0020
}

SWP_FRAMECHANGED(){
Return 0x0020
}

SWP_HIDEWINDOW(){
Return 0x0080
}

SWP_NOACTIVATE(){
Return 0x0010
}

SWP_NOCOPYBITS(){
Return 0x0100
}

SWP_NOMOVE(){
Return 0x0002
}

SWP_NOOWNERZORDER(){
Return 0x0200
}

SWP_NOREDRAW(){
Return 0x0008
}

SWP_NOREPOSITION(){
Return 0x0200
}

SWP_NOSENDCHANGING(){
Return 0x0400
}

SWP_NOSIZE(){
Return 0x0001
}

SWP_NOZORDER(){
Return 0x0004
}

SWP_SHOWWINDOW(){
Return 0x0040 
}


WS_EX_TRANSPARENT(){
Return 0x00000020
}

WS_EX_TOPMOST(){
Return 0x00000008
}


WS_EX_LAYERED(){
Return 0x00080000 
}



HWND_BOTTOM(){
	return 1
}
	
HWND_NOTOPMOST(){
	return -2
}
	

HWND_TOP(){
	return 0
}
	


HWND_TOPMOST(){
	return -1
}

exModeset(v){
	if(!assureRunningScript("bp2",a_thisFunc,v)){
		return
	}
	ExMode.inst().set(v)
}
exModetoggle(){
	if(!assureRunningScript("bp2",a_thisFunc)){
		return
	}
	ExMode.inst().toggle()
}
class ExMode{
	__New(){
		this.on:=false
		return this
	}

	inst(){
		static o
		if(!o){
			o:=new ExMode()
			
		}
		return o
	}
	set(val){
		if( val!=this.on){
			persistSetting()["actOtherTempDisable"]:=true
			id:=getctid()
			WinActivate, % "ahk_id" id
			if(val){
				;tooltip
				send, {F9}
			}else{
				send, {F10}
			}
			persistSetting()["actOtherTempDisable"]:=false
			this.on:=val
		}
	}
	
	toggle(){
		this.set(!this.on)
	}
}

getMutex(){
	return
	global gMutex
	if(gMutex==""){
		gMutex:=0
	}
	t1:=a_tickcount
	while(gMutex==1){
		if(a_tickcount-t1>4000){
			mos("a_tickcount-t1>3000",gMutex)
			return
		}
		sleep, 20
	}
	gMutex:=1
	ttos("getMutex", gMutex)
}

releaseMutex(){
	return
	global gMutex
	if(!gMutex){
		mos("releaseMutex but0")
	}
	gMutex:=0
	ttos("releasedMutex", gMutex)
}


/*
	Function: EnumDisplayDevices
		
	Parameters:
		Index 				- Adapter index OR if adapter parameter is specified, monitor index. Starts at 0.
		Adapter 			- Adapter name (string)
		GetInterfaceName	- ???
		
	Remarks:
		Function fails if given index is greater than the largest device index.
	
	Returns:
		On success returns object containing returned DISPLAY_DEVICE members. FALSE on failure.
	
	Returned Object Members:
		
		Name 		- DeviceName ???
		String		- DeviceString ???
		Flags		- StateFlags (see below)
		ID			- DeviceID ???
		Key			- DeviceKey ???
	
	Adapter Flags:
		
		0x00000001		- DISPLAY_DEVICE_ATTACHED_TO_DESKTOP
		0x00000002		- DISPLAY_DEVICE_MULTI_DRIVER
		0x00000004		- DISPLAY_DEVICE_PRIMARY_DEVICE
		0x00000008		- DISPLAY_DEVICE_MIRRORING_DRIVER
		0x00000010		- DISPLAY_DEVICE_VGA_COMPATIBLE
		0x00000020		- DISPLAY_DEVICE_REMOVABLE
		0x02000000		- DISPLAY_DEVICE_DISCONNECT
		0x04000000 		- DISPLAY_DEVICE_REMOTE
		0x08000000		- DISPLAY_DEVICE_MODESPRUNED
		
	Monitor Flags:
		
		0x00000001		- DISPLAY_DEVICE_ACTIVE
		0x00000002		- DISPLAY_DEVICE_ATTACHED
	
	Links:
		- <EnumDisplayDevices function at http://msdn.microsoft.com/en-us/library/dd162609%28v=vs.85%29.aspx>.
		- <DISPLAY_DEVICE structure at http://msdn.microsoft.com/en-us/library/aa932948.aspx>.
	
	Examples:
(start code)

; Shows all display adapters and monitors in a treeview
Gui, Add, TreeView, r20 w400
i=0
While AdapterInfo := EnumDisplayDevices(i++) {
	TV_Adapter := TV_Add(AdapterInfo.Name)
	While MonInfo := EnumDisplayDevices(A_Index-1, AdapterInfo.Name) {
		TV_AdapterMonitor := TV_Add(MonInfo.Name, TV_Adapter)
		TV_Add(MonInfo.String, 	TV_AdapterMonitor)
		TV_Add(MonInfo.Flags, 	TV_AdapterMonitor)
		TV_Add(MonInfo.ID, 		TV_AdapterMonitor)
		TV_Add(MonInfo.Key, 	TV_AdapterMonitor)
	}
}
Gui, Show

(end)
*/
EnumDisplayDevices(Index, Adapter = 0, GetInterfaceName=False) {

	NumPut(VarSetCapacity(DISPLAY_DEVICE, A_IsUnicode ? 840 : 424, 0), &DISPLAY_DEVICE )
	
	If ! DllCall("EnumDisplayDevices" . (A_IsUnicode ? "W" : "A")
			, "UInt", Adapter ? &Adapter : 0
			, "UInt", Index
			, "UInt", &DISPLAY_DEVICE
			, "UInt", GetInterfaceName ? 1 : 0)	; EDD_GET_DEVICE_INTERFACE_NAME
		Return False
	
	CharSize := A_IsUnicode ? 2 : 1
	Return { "Name" 	: StrGet(&DISPLAY_DEVICE + (Offset := 4))
			, "String"	: StrGet(&DISPLAY_DEVICE + (Offset += 32*CharSize))
			, "Flags"	: NumGet(&DISPLAY_DEVICE + (Offset += 128*CharSize), 0, "Uint")
			, "ID"		: StrGet(&DISPLAY_DEVICE + (Offset += 4))
			, "Key"		: StrGet(&DISPLAY_DEVICE + (Offset += 128*CharSize))}
}

runAsync(params*){
	fp:=Object()
	for i,p in params{
		if(i==1){
			fn:=p
		}else{
			fp.push(p)
		}
	}
	FO:=Func(fn).Bind(fp)
	SetTimer,%FO%,-50
	return
}
visibleAndNotMinimized(id){
	WinGet, WinState, MinMax, AHK_id %id%
	minimized:=WinState == -1
	;ttos(minimized)
	return hasVisibleStyle(id) && !minimized
}
arrayContains(a,val){ 
	for index, element in a {
		if(val= element){
			return true
		}
	}
	return false
}

ensureRBTray() {
    Process,Exist,RBTray.exe
    if (!ErrorLevel) {
		run,C:\ProgrammeUser\RBTray\RBTray.exe,C:\ProgrammeUser\RBTray
        Sleep,500
    }
}

restoreFromtray(id:=""){
	
	;mos("passed id",getwininfobase(id))
	ensureRBTray()
	PostMessage,0x0402,,id,,RBTrayHook
}
minimize2tray(id:=""){
	if(id=="") {
		id:=getctid()
		;mos("getctid",getwininfobase(id))
	}else{
		;mos("passed id",getwininfobase(id))
	}
	;mos("passed id",getwininfobase(id))
	ensureRBTray()
	PostMessage,0x0401,,id,,RBTrayHook
}

isFullScreen(id){
	rw:=new rect(id)
	ret:=rw.isFullScreen()
	;mos("isFullScreen",rw,rs,ret)
	return ret
}

class MyRange{
	from(l,u){
	
		r:=new MyRange()
		r.l:=l
		r.u:=u
		return r
	}
	
	isWithin(y){
		return y>this.l && y<this.u
	}


}

getActiveWin() {
	aid:=WinExist("A")
		if(!aid){
			;mos(aid)
		}
		return aid
}
	
assureActive(id){
	aid:=getActiveWin()
	if (aid!=id) {
		WinActivate,ahk_id %id%
		return aid
	}else{
		return 0
	}
}

lowerabsToZero(ByRef a,ByRef b){

	if (abs(a)<abs(b)) {
		a:=0
	}
	else if (abs(a)>abs(b))  {
		b:=0
	}
}

getCtrlC(){

	prevClipboard = %clipboard%
	clipboard =
	Sleep, 50
	Send, ^c
	;BlockInput, off
	ClipWait, 5,1	
	if ErrorLevel = 0
	{
		ret:=clipboard
	}else{
		ttos("errorWith Clip",clipboard)
		ret:=""
	}
	clipboard = %prevClipboard%
	return ret
}

concat(sep,ps){
	str:=""
	first:=true
	for index,p in ps
	{
		if (first) {
			first:=false
			str .= p
		}else{
			str .= sep . p
		}
	}
	return str

}

randomizeArray(items){
	ret:=Object()
	while (items.maxindex()){
		mitems:=items.maxindex()
		Random,  rn, 1, mitems
		
		item:=items.remove(rn)
		ret.push(item)
	}
	return ret
}

getscreenFromPoint(p){
	return getscreenFromCoord(p.x,p.y)
}

getscreenFromMouse(){
	return getscreenFromCoord()
}

getscreenFromCoord(Mx := "", My := "")
{
	if  (!Mx or !My) 
	{
		; if Mx or My is empty, revert to the mouse cursor placement
		Coordmode, Mouse, Screen	; use Screen, so we can compare the coords with the sysget information`
		MouseGetPos, Mx, My
	}

	SysGet, MonitorCount, MonitorCount	; monitorcount, so we know how many monitors there are, and the number of loops we need to do
	Loop, %MonitorCount%
	{
		SysGet, mon%A_Index%, Monitor, %A_Index%	; "Monitor" will get the total desktop space of the monitor, including taskbars

		if ( Mx >= mon%A_Index%left ) && ( Mx < mon%A_Index%right ) && ( My >= mon%A_Index%top ) && ( My < mon%A_Index%bottom )
		{
			ActiveMon := A_Index
			break
		}
	}
	return ActiveMon
}

getScreenpos(monNumber, ByRef x,ByRef y,ByRef w,ByRef h){
	SysGet, Monitor, Monitor, %monNumber%
	;mos("nn", monNumber,MonitorLeft,MonitorTop,MonitorRight,MonitorBottom)
	x:=MonitorLeft
	y:=MonitorTop
	w:=MonitorRight-x
	h:=MonitorBottom-y
	;mos(monNumber,  x, y, w, h)
}

getPidFromWin(id){
	winget pid, pid , ahk_id %id%
	return pid
}

getSimpleAudioVolume(lookuppidOrName) {

	IID_IAudioSessionManager2 := "{77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F}"
	IID_ISimpleAudioVolume := "{87CE5498-68D6-44E5-9215-6DA47EF883D8}"

	dev := VA_GetDevice()
	if !dev
		throw "Can't get device"
	if VA_IMMDevice_Activate(dev, IID_IAudioSessionManager2, 7, 0, mgr) != 0
		throw "Can't get session manager"
	ObjRelease(dev)
	if VA_IAudioSessionManager2_GetSessionEnumerator(mgr, enm) != 0
		throw "Can't get session enumerator"
	ObjRelease(mgr)
	VA_IAudioSessionEnumerator_GetCount(enm, count)
	retSAV:=""
	Loop % count
	{
		; IAudioSessionControl *session;
		VA_IAudioSessionEnumerator_GetSession(enm, A_Index-1, ssn)
		VA_IAudioSessionControl_GetDisplayName(ssn, name)
		VA_IAudioSessionControl2_GetProcessId(ssn, pid)
		if (pid!=lookuppidOrName && name!=lookuppidOrName) {
			ObjRelease(ssn)
			continue
		}
		retSAV := ComObjQuery(ssn, IID_ISimpleAudioVolume)
		ObjRelease(ssn)
	}
	ObjRelease(enm)
	return retSAV
	
}

ShowTaskbar() {
	Send #t
}