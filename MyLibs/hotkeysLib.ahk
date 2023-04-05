
randomAndPlayStoreClipboard(copy:=true){
	items:=getFilesThroughClipboard(copy)
	if(items && items.maxindex()>0){
		lc:=1
		r:=query(1,"pls",6)
		;if IsObject(r)
			lc:=r["value"]
		loop %lc%
		{
			items:=randomizeArray(items)
			createAndPlayTempPls(items)
			pause()
			sleep 1000
		}
	}
}

calcTitleInfo(menposid,ByRef fpath,ByRef fpathOrTitle, ByRef schedTo,ByRef tfpath){
	WinGetTitle,title,ahk_id %menposid%
	
	fpath:=moveToMenu.extractPathFromString(title,"")
	
	if (fpath=="") {
		fpathOrTitle :=  title
	}else{
		fpathOrTitle :=  fpath
	}
	
	;
	if (fpath!="") {
		jobpath:=movetomenu.jobFilePathFromSourceFile(fpath)
		;mm(jobpath)
		IfExist, %jobpath%
		{
			movetoMenu.readJob(jobpath, fpath, tfpath)
			;mm(jobpath . fpath . tfpath . )
			SplitPath, tfpath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
			schedTo:="`n SCHEDULED TO: " . OutDir
			fpathOrTitle .= schedTo
		}
	}
}

getFilesThroughClipboard(copy:=true){
	if (copy) {
		mc1:=getCtrlC()
	} else {
		mc1:=clipboard
	}
	
	mc := StrReplace(mc1, "`r`n" ,"`n", OutputVarCount) 
	items:=StrSplit(mc,"`n")
	;mos(mc,items)
	return items
}

class DynWinSubMenu{
	static submenus := getDynWinSubMenus()

	getParentMenu(){
		return this.parentmenu
	}
	inlineMenuu(){
		return false
	}
	setParentAndAddsubmenu(parentmenuParam){
		this.parentmenu:=parentmenuParam
		this.addsubmenu(this.getParentMenu())
	}
	
	
	addsubmenu(mainmenu){
		global
		this.addItem("dummy")
		name:=this.__Class
		if(!this.inlineMenuu()){
			Menu, %mainmenu%, Add, %name%, clickRoot
		}else{
			Menu, %mainmenu%, Add, %name%, :%name%
		}
		return
		
		clickRoot:
			name:=A_ThisMenuItem
			submenu:=DynWinSubMenu.submenus[name]
			submenu.buildmenu()
			Menu, %name%, Show
		return
	}
	
	addWins(c){
		;global
	}
	
	gettitle(id) {
		return gettitle(id) 
	}
	
	id2MenuItem(id){
		s:=this.gettitle(id) . "     $" . id
		return s
	}
	
	extactIdFromMenuItem(MenuItem){
		return SubStr(MenuItem, InStr(MenuItem, "$")+1)
	}
	
	needsBuild(){
		return true
	}
	
	buildmenu(){
		global
		name:=this.__Class
		if (this.needsBuild()) {
			Menu, %name%, DeleteAll
			wins:=Object()
			this.addWins(wins)
			for,index,id in wins{
				this.addItem(this.id2MenuItem(id))
			}
		}
		return
	}
	addItem(string){
		global
		name:=this.__Class
		Menu, %name%, Add, %string%, DynWinSubMenuHandler		
		return
		
		DynWinSubMenuHandler:
		;ttt()
		name:=A_ThisMenu
		submenu:=DynWinSubMenu.submenus[name]
		
		id:=submenu.extactIdFromMenuItem(A_ThisMenuItem)
		
		submenu.click(id)
		return
	}
}


class ExplorerTestClass extends DynWinSubMenu{

	instance() {
		static inst:=""
		if (!inst) {
			inst:=new ExplorerTestClass()
		}
		return inst

	}
	inlineMenuu(){
		return true
	}
	getParentMenu(){
	
		return "MyMenu"
	}
	
	needsBuild() {
		if (!this.frf) {
			this.frf:=true
			return true
		}
		return false
	}

	click(fn){
		global menposx,menposy,menposid 
		o:=this.instance()
		fnval:=o[fn]
		%fnval%(o)

		;mos(o,fn)
	}
	
	extactIdFromMenuItem(id){
		return id
	}
	
	id2MenuItem(id){
		return id
	}
	
	addWins(ByRef c){
		For k,v in ExplorerTestClass
		{
			if(regexmatch(k,"^___")){
					c.push(k)
			}
		}
	}

	___setTransColor() {
		global menposx,menposy,menposid
	
		;    tt(menposx menposy menposid)
	
	id:= menposid
	  id:=getRoot(id)
		   ;    return
			removetrancparency(id)
			PixelGetColor, MouseRGB, %menposx%, %menposy%, RGB
			;In seems necessary to turn off any existing transparency first:
		WinSet, TransColor, Off, ahk_id %id%
		WinSet, TransColor, %MouseRGB%, ahk_id %id%
		;    mm(menposx " " menposy " " " "colortostring(MouseRGB) getWinInfo(id))
	
		;    ttt()
	}

	___fixTransparency() {
		global menposx,menposy,menposid
		id:= menposid
	  	id:=getRoot(id)
		fixTransparency(id)
	}
	
	___getFilesThroughClipboard(){
		res:=""
		msg:=""
		mc:=0
		dq :="="
		for i,item in getFilesThroughClipboard()
		{
			if(!FileExist(item)) {
				++mc
				;FileGetSize, size , %item%
				msg := dq item dq newline()
				;mos(item,isObject(item),size)
			}	
			res := res item newline()
			

		}
		Clipboard:=res
		if(msg){
			mos("copied but don't exist " mc, msg)
		}
	}
	
	___minimize2Tray(){
		global menposx,menposy,menposid
		minimize2Tray(menposid)
	}
	
	___searchWithEverything(){
		global menposx,menposy,menposid
		if(ismpcwin(menposid)){
			calcTitleInfo(menposid,fpath,fpathOrTitle, schedTo,schedTotfpath)
			SplitPath, fPath, fName, sDir, sExtension, sNameNoExt, sDrive
			fn:=fName
			;mos(fn,fPath, fName, sDir, sExtension, sNameNoExt, sDrive)
		}else{
			fns:=Object()

			cp:=getCtrlC()
			liness := StrSplit(cp, "`r`n")
			;mos(liness)
			for index,line in  liness {
				SplitPath, line, fn, sDir, sExtension, sNameNoExt, sDrive
				reg:=regexmatch(fn,"O)^[0-9]+(.*)", resobj)
				if(reg){
					;mos(resobj.Count(), resobj.Value(1))
					fn:=resobj.Value(1)
					qtfn="""%fn%"""
					fns.Insert(qtfn)
				}
			}
			;mos(fns)
			fn:=concat("|",fns)
			;mos(fn)
		}
		Run, "C:\Program Files\Everything\Everything.exe" -s "%fn%" -filter Videos
	
	
	}
	___randomAndPlayStoreClipboard(){
		randomAndPlayStoreClipboard(true)
	}
	___randomAndPlayStoreClipboardNoCopy(){
		randomAndPlayStoreClipboard(false)
	}
	
	
	
	___ToGo(){
		global menposx,menposy,menposid
		if(ismpcwin(menposid)){
			calcTitleInfo(menposid,fpath,fpathOrTitle, schedTo,schedTotfpath)
			if(!calcToGoPaths(fpath,schedTotfpath, tfpath, tsDir)){
				return
			}
			
			
			FileCreateDir, %tsDir%
			qtfpath="%tfPath%"
			qfpath="%fpath%"
			cmd=%comspec% /c mklink /H %qtfpath% %qfpath%
			;Clipboard:=cmd
			;mos(cmd)
			
			RunWait, %cmd%, , Hide
			if(!FileExist(tfPath)){
				mos("!FileExist()",cmd)
			}
		}
	}

    ___SHOWExplorerwins(){
		global menposx,menposy,menposid
        showExplorerwins()
    }

    ___HIDEExplorerwins(){
		global menposx,menposy,menposid
        hideExplorerwins()
    }

	___Monitor() {
		SysGet, MonitorCount, MonitorCount
		SysGet, MonitorPrimary, MonitorPrimary
		MsgBox, Monitor Count:`t%MonitorCount%`nPrimary Monitor:`t%MonitorPrimary%
		Loop, %MonitorCount%
		{
			SysGet, MonitorName, MonitorName, %A_Index%
			SysGet, Monitor, Monitor, %A_Index%
			SysGet, MonitorWorkArea, MonitorWorkArea, %A_Index%
			MsgBox, Monitor:`t#%A_Index%`nName:`t%MonitorName%`nLeft:`t%MonitorLeft% (%MonitorWorkAreaLeft% work)`nTop:`t%MonitorTop% (%MonitorWorkAreaTop% work)`nRight:`t%MonitorRight% (%MonitorWorkAreaRight% work)`nBottom:`t%MonitorBottom% (%MonitorWorkAreaBottom% work)
		}
	}

	___PauseAll() {
		ps :=getPlayerIdsOrderedTopFirst(getfilter())
		For index, id in ps {
			pause(id)
		}
	}

	___PauseAll_AllScreens() {
		ps :=getPlayerIdsOrderedTopFirst("ch")
		For index, id in ps {
			pause(id)
		}
	}
}

getfilter(){
	return "chs"
}

class Lay extends ExplorerTestClass{

	instance() {
		static inst:=""
		if (!inst) {
			inst:=new Lay()
		}
		return inst
	}
	
	addWins(ByRef c){
		For k,v in Lay
		{
			if(regexmatch(k,"^___")){
					c.push(k)
			}
		}
	}

	___SizeToScreen() {
		ps :=getPlayerIdsOrderedTopFirst(getfilter())
		mi:=ps.maxindex()
		rect:=rectfromScreen(getscreenFromMouse())
		rects:=Object()
		loop %mi% 
		{
			rects.push(rect)
		}
        moveTopFirstPlayerIdsOnRects(ps,rects)
	}

	___SizeToScreen_All() {
		ps :=getPlayerIdsOrderedTopFirst("ch")
		mi:=ps.maxindex()
		rect:=rectfromScreen(getscreenFromMouse())
		rects:=Object()
		loop %mi% 
		{
			rects.push(rect)
		}
        moveTopFirstPlayerIdsOnRects(ps,rects)
	}

	___MoveToStaple() {
		ps :=getPlayerIdsOrderedTopFirst(getfilter())
		mi:=ps.maxindex()
		rects:=getstaplerects(mi)
        moveTopFirstPlayerIdsOnRects(ps,rects,2)
	}

	___MoveToStapleVert() {
		ps :=getPlayerIdsOrderedTopFirst(getfilter())
 		mi:=ps.maxindex()
          ;        mm(mi)
		rects:=getstapleVertrects(mi)
        layoutPlayers(ps,rects,2)
    }
	

	___MoveTo3Grid() {
		ps :=getPlayerIdsOrderedTopFirst(getfilter())
		mi:=ps.maxindex()
		rects:=get3gridrects(mi)
         layoutPlayers(ps,rects)
	}

	___MoveTo4Grid() {
		ps :=getPlayerIdsOrderedTopFirst(getfilter())
		mi:=ps.maxindex()
		;        mm(mi)
		rects:=get4gridrects(mi)
		layoutPlayers(ps,rects)
	}

	___MoveToGrid() {
		pso :=getPlayerIdsOrderedTopFirst(getfilter())
		;mos(pso)
		rects:=getgridrects(pso.maxindex())
		layoutPlayers(pso,rects)
	}
}


class moveToMenu extends DynWinSubMenu{
	;this.needsB := true
	
	jobspath(){
		return "C:\_TEMPUSER\moveJobs\"
	}
	
	needsBuild() {
		if (!this.frf) {
			this.frf:=true
			return true
		}
		return false
	}
	
	extractPath(){
		global menposx,menposy,menposid 
		;mm(menposid)
		t:=gettitle(menposid)
		;tt(t)
		;mm(t)
		return moveToMenu.extractPathFromString(t)
	}
	
	extractPathFromString(t,d:="") {
		i:= InStr(t, " - MPC-BE")
		if (i>0) {
			return substr(t,1,i-1)
		}
		return d
	}
	
	writeJob(jobpath, fpath, tfpath) {
		IniWrite, %fpath%, %jobpath%,main, source
		IniWrite, %tfpath%, %jobpath%,main, dest
	}
	
	readJob(jobpath, ByRef fpath, ByRef tfpath) {
		;mos(jobpath)
		IniRead, fpath, %jobpath%,main, source
		IniRead, tfpath, %jobpath%,main, dest
	}
	
	jobFilePathFromSourceFile(fpath) {
		SplitPath, fpath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		path:=this.jobspath() . OutFileName . ".txt"
		return path
	}
	
	toCmd(fpath,  tfpath){
		return toMoveCmd(fpath,  tfpath)
	}
	
	move(fpath,  tfpath){
		;return
		SplitPath, tfpath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		
		
		path:=movetomenu.jobFilePathFromSourceFile(fpath)

		moveToMenu.writeJob(path, fpath, tfpath)

	}
	
	delete(fpath){
		;return
		dq = "
						;cmd:="C:\ProgrammeUser\AHK\RunUtiBrh.ahk playerMoveTo " . id . " " . souroundWith(fpath,  dq) . " " . souroundWith(tfpath, dq) ;. "`""
						cmd:="cmd /c del " . souroundWith(fpath,  dq)
						tt(cmd)
						
						run ,%cmd%,,Hide
	}
	
	
	

	click(targetspec){
		;tt(targetspec)
		
		global menposx,menposy,menposid 
		id:=menposid
		fPath:=this.extractPath()
		if (fPath!="") {
			
			SplitPath, fPath, fName, sDir, sExtension, sNameNoExt, sDrive
			sLetter := SubStr(sDrive, 1,1)
			
			targetspec:=RegExReplace(targetspec,"A)IN","\" sLetter "Vid")
			targetspec:=RegExReplace(targetspec,"A)OUT","")
			
			if (sDrive = "c:") {
				 targetpath:="C:\Users\Harald\Downloads\Miponyraus\tm" targetspec
			 }else{
				targetpath:=sDrive "\system" targetspec
			}
			tfPath:=targetpath . "\" . fName
			;clickth:= findctwindow(id,true)
			;tbefore:=getTitle(id)

			if (fPath = tfPath) {
				return
			}
			;mm(fPath newline() tfPath)
			
			
			fPathExist:=FileExist(fPath)
			if (fPathExist) {
				if (FileExist(tfPath)) {
					tt("the target file " . tfPath . " already exists ->to posdup")
					tfPath:="I:\System\posdup\" . fName
					if (FileExist(tfPath)) {
						tt("already in posdup -> delete")
						this.delete(fpath)
					}else{
						this.move(fpath,  tfpath)
					}
				}else{
					this.move(fpath,  tfpath)
				}
			} else {
				tt("the file " . fPath . " does not exist")
			}		
		}	
	}
	
	extactIdFromMenuItem(id){
		return id
	}
	
	id2MenuItem(id){
		return id
	}
	
	addWins(ByRef c){
		if (this.extractPath()!="") {
			Loop, read, C:\ProgrammeUser\AHK\AutoHotkeyResistents\mtmPaths.txt
			{
				l:=A_LoopReadLine
				l:=RegExReplace(l," ","")
				; SplitPath, l , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
				; s:=s(l , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive)
				; ;mm(s)
				; IfNotExist, %OutDrive%
				; {
					; mm(OutDrive . "does no exist")
				; }
				if(regexmatch(l,"^;")){
					continue
				}
				c.push(l)
			}
			;~ c.push("F:\system\Fvid\_hbc\verfyd")
			;~ c.push("F:\system\Fvid\_hbc\_g_")
			;~ c.push("F:\system\Fvid\_hbc\lesb")
			;~ c.push("F:\system\Fvid\_hbc\lesb\_g_")
			;~ c.push("H:\system\_LoRes")
			;~ c.push("H:\system\_vidout")
			;~ c.push("F:\system\Fvid\other\_fake")
			;~ c.push("F:\system\Fvid\other\_group")
			
			;~ c.push("F:\system\Fvid\other\_g_")
			;~ c.push("F:\system\Fvid\other\other")
			;~ c.push("F:\system\Fvid\other\_solo") 
			;~ c.push("F:\system\Fvid\other\_solo\_g_")
			;~ c.push("F:\system\Fvid\other\_lesb")
			;~ c.push("F:\system\Fvid\other\_lesb\_g_")
			;~ c.push("F:\system\Fvid\other\_softs")
			;~ c.push("F:\system\Fvid\soft\_g_")
			;~ c.push("F:\system\Fvid\other\_moregirls")
			;~ c.push("F:\system\Fvid\other\_moregirls\_g_")
			;~ c.push("F:\system\Fvid\other\_young")
			;~ c.push("F:\system\Fvid\other\_young\_hbc")
			;~ c.push("F:\system\Fvid\other\_young\_g_")
			;~ c.push("H:\system\z\posdup")
			;~ c.push("F:\system\L�schen")
			;c.push("")
		}else{
			c.push("not moveable")
			this.frf:=""
		}
		
		
		
	}
}

getDynWinSubMenus(){
	static c
	static ret
	if (!c) {
		c:=Object()
		c.push(new ExplorerTestClass())
		c.push(new Lay())
		; c.push(new bbMenu())
		; c.push(new ShowMenu())
		; c.push(new ctwinMenu())
		; c.push(new maxwinMenu())
		; c.push(new topmostMenu())
		; c.push(new moveToMenu())
		ret:=Object()
		for index, submenu in c {
			ret[submenu.__Class]:=submenu
		}
	}
	
	return ret
}

createPls(items){
	ofPath:="C:\_TEMPUSER\pls\tempPlaylist" a_tickcount ".mpcpl"
file:= FileOpen(ofPath, "w") ; [, Encoding])
	file.writeline("MPCPLAYLIST")
	for idx,item in items{
		file.writeline(idx ",type,0")
		file.writeline(idx ",filename," item)
	}
	File.Close()
	return ofPath
}

createAndPlayTempPls(items){
	ofPath:=createPls(items)
	;mos(items,ofPath)
	
	;mos(s)
	;run, %ofPath%
	;run, "C:\ProgrammeUser\RunAsDesktopUser\x64\Release\RunAsDesktopUser.exe" "C:\Program Files\MPC-BE x64\mpc-be64.exe" "%ofPath%"

	cmd="C:\Program Files\MPC-BE x64\mpc-be64.exe" "%ofPath%"
	
	run, %cmd%
	
}

pause(id:=""){
	;tt("trace2")
	;dbgcode
	if(id==""){
		id:=getctid()
	}
	if (isplayerwin(id)) {
		;tt(getwininfo(id) . "trace5")
		if (isDebug()) {
			tt("pause " . getwininfobase(id))
		}
		mpcsend_Pause(id)
	}
}

calcToGoPaths(fpath,schedTotfpath, byref tfpath,byref tsDir){

	SplitPath, fPath, fName, sDir, sExtension, sNameNoExt, sDrive
	sLetter := SubStr(sDrive, 1,1)
	ser:="i)\\" . sLetter . "vid\\"
	if(schedTotfpath){
		inP:=schedTotfpath
	}else{
		inP:=fPath
	}
	path:=RegExReplace(inP,ser,"\_TOGO\")

	if(!path || inP==path){
		;mos(path,inP ser,callstack())
		return false
	}
	SplitPath, path, tfName, tsDir, tsExtension, tsNameNoExt, tsDrive
	tfpath:=tsDir . "\" . fName
	return true
}

hideExplorerwins(){
	
	for index, id in getExplorerwins(){
		id:= getRoot(id)
		WinHide, ahk_id %id%
	}
	hideOthers()
	
	
	;SetTimer,tryhideTMR,Off
}

showExplorerwins(){
	;if (isLabel("tryhideForPlayerTMR")) {
		;SetTimer,tryhideForPlayerTMR,4000
		
	;}	
	global gShowExplorerTick:=a_tickcount
	
	obs:=Object()
	for index, id in getExplorerwins(){
		;obs.push(getwininfo(id))
		id:= getRoot(id)
		WinShow, ahk_id %id%
		WinActivate,ahk_id %id%
		setkeepotAndtopmost(true,id)
		;setTopMost(id,false)
	}
	;mos(obs)
	
	for index, id in getExplorerwins(){
		restoreFromtray(id)
	}

	for index, id in getEverythingWins(){
		restoreFromtray(id)
		WinActivate,ahk_id %id%
		setkeepotAndtopmost(true,id)
	}
	
	return
	
tryhideTMR:
	id:=WinExist("A")
	;tt(getwininfo(id))
	title:=getTitle(id)
	isPlayer:=isPlayerWin(id)
	;tt("isPlayer" . isPlayer . "`n" . getwininfo(id))
	if (isPlayer|| title=="Form1") {
		ttos("activeWin is",getwininfobase(id)," ->hideExplorerwins")
		hideExplorerwins()
		;SetTimer,tryhideTMR,Off
	} else{
		;SetTimer,tryhideTMR,200
	}
	return
}



getExplorerwins() {
	ret:= Object()
	WinGet, ids, list, , , Program Manager
	Loop, %ids%
	{
		StringTrimRight, id, ids%a_index%, 0
		
		;WinGet,ProcessName,ProcessName,ahk_id %id%
  
		if (isExplorerWin(id)) {
			ret.push(id)
		}
	}
	return ret
}

getEverythingWins() {
	ret:= Object()
	WinGet, ids, list, ahk_class EVERYTHING
	Loop, %ids%
	{
		StringTrimRight, id, ids%a_index%, 0
		
		;WinGet,ProcessName,ProcessName,ahk_id %id%
  		ret.push(id)
	}
	;mos(ret)
	return ret
}

isAppWin(id){
	WinGetTitle,Title,AHK_id %id%
	if (Title==""||title="ActiveMovie Window"||title=="Socket Notification Sink") {
		return false
	}
	class:=getclass(id)
	if (class=="EVRFullscreenVideo"||class=="Afx:000000013F640000:0"||class=="ffdshow_remote_class"||instr(class,"ffdshow_tray")) {
		return false
	}
	r:=new rect(id)
	if (r.w <= 0 || r.h<=0) {
		return false
	}
	WinGet,ProcessName,ProcessName,ahk_id %id%
	use:=(ProcessName<>"perl.exe")  && (ProcessName<>"autohotkey.exe") 
	return use
}

isPlayerWin(id) {
	return isAppWin(id)&&isMPCWin(id)	&& !isPreviewwin(id)
}

hideOthers(){
	old:=A_DetectHiddenWindows
	DetectHiddenWindows,On
	;ControlSend,,{LShift Down}{Esc}{LShift Up},ahk_class SciTEWindow
	;WinActivate,ahk_class SciTEWindow
	;WinGetClass,cls,A
	
	;if(cls!="MPC-BE")
	;activeToTray()
	
	WinClose,StrokeIt - Command Editor
	;WinClose,Active Window Info
	WinHide,ahk_exe osk.exe
	;WinMinimize,ahk_exe mipony.exe
	
	WinGet,id,id,AutoHotkey Help
	;mos("hlp",id)
	if(id){
		minimize2tray(id)
	}
	
	WinGet,id,id,ahk_class Notepad++
	if(id){
		WinGet, MinMax, MinMax, AHK_id %id%
		minimized:=MinMax == -1
		if(minimized){
			WinRestore, AHK_id %id%
		}
		minimize2tray(id)
	}
	
	for index, id in getEverythingWins(){
		minimize2tray(id)
	}
	
	
	WinClose,JDownloader 2 BETA
	DetectHiddenWindows,%old%
}

isExplorerWin(id) {
	WinGetClass, class, AHK_id %id%
	;WinGet, Style, Style, AHK_id %id%
	;class=="CabinetWClass")||
	If(InStr(class, "CabinetWClass")) {
		
			Return True

	}
	Return False
}

getINIBoolVars(){
	Array := Object()
	Array.push("fadeOutStopsVar")
	Array.push("fadeOutStopsVarEarly")
	Array.push("fadeSound")
	Array.push("fastFade")
	Array.push("loopSoundallScreens")
	Array.push("muteTotal")
	Array.push("shiftKeyboard")
				

	Array.push("enableNib")
	Array.push("sizeupWithLock")
		Array.push("pushbackPlayerAlternative")
		 		 
		 Array.push("dragSizeWithRatio")
		Array.push("enableonce")
		Array.push("sizeNotZoon")
		Array.push("MPC32")
		Array.push("actOther")
		Array.push("keepOTTask")
		Array.push("fadeCenterOnRight")
		Array.push("HideExplorerOnPlayer")
		Array.push("TaskbarSelectSetTopmost")
		Array.push("BeamerScreenSize")
		Array.push("adaptShaderToSize")
;Array.push("fadeOutStopsVar")
		 ;Array.push("fadeOutStopsVar")
		 ;Array.push("fadeOutStopsVar")
		 ;Array.push("fadeOutStopsVar")
		 ;Array.push("fadeOutStopsVar")
		 
	
return Array
}


getINIVars(){
	locVar := getINIBoolVars()
	locVar.push("fadetimeFast")
	locVar.push("fadetimeSlow")
	locVar.push("sleeptimeFast")
	locVar.push("sleeptimeSlow")
	locVar.push("clicthrouhgwinM2HWND")
	
	;Array.push("fadetimeFast")
return locVar
}


readini(){
	static inst
	if (!inst) {
		inst:=new PersistentObjectFast("C:\ProgrammeUser\AHK_New\IniVals.txt")
	}
	return inst.get()
}

getParam(paramname){
	
	return readini()[paramname]
}

killmenu() {
	;ttt()

	ret:=object()
	lmen:=""
	while (1) {
		menuid:=getmenuid()
	;tt("menuid:" . menuid)
		if (menuid && menuid != lmen) {
			IfWinExist,ahk_id %menuid%
			{
				ret.push(menuid)
				ControlSend,,{Escape},ahk_id %menuid%
				lmen:=menuid
			}else{
				mos(menuid)
			}
			
			Sleep 40			
		}
		else {
			break
		}
		
	}
return ret
}

getmenuid(){
	WinGet,id,id,ahk_class #32768
	return id
}

boarderWith(id:=""){
	px:=20
	if (id=="") {
		return px
	}
	r:=new rect(id)
	b:=(r.h + r.w) / 2 *boarderRel()
	return b
}

boarderRel(big:=false){
	if(big){
		return 0.15
	}
	return 0.05
}

isWinUpperBoarder(id:="",boarder:=""){
	if (id=="") {
		id:=getctid()
	}
	if (boarder=="") {
		boarder:=boarderWith(id)
	}
	MouseGetPos,,my,
	WinGetPos,,y,,h,ahk_id %id%
	dif:=my-y
	;difabs:=Abs(dif)
	ret:=(dif < boarder)
	;ToolTip %dif% %ret%
	return ret
}

isWinLeftBoarder(id:="",boarder:=20){
	if (id=="") {
		id:=getctid()
	}
	MouseGetPos,mx

	WinGetPos,x,y,w,h,ahk_id %id%
	dif:=mx-x
	
	ret:=(dif < boarder)
	return ret
}

isWinRightBoarder(id:="",boarder:=20){
	if (id=="") {
		id:=getctid()
	}
	MouseGetPos,mx,my,id
	id:=getctid()
	WinGetPos,x,y,w,h,ahk_id %id%
	dif:=x+w-mx
	
	ret:=(dif < boarder)
	return ret
}

isWinUpperOrBottomBoarder(id:="",boarder:=""){
	if (id=="") {
		id:=getctid()
	}
	if (boarder=="") {
		boarder:=boarderWith(id)
	}
	return isWinUpperBoarder(id,boarder)||isWinBottomBoarder(id,boarder)
}
isWinLeftOrRightBoarder(id:="",boarder:=""){
	if (id=="") {
		id:=getctid()
	}
	if (boarder=="") {
		boarder:=boarderWith(id)
	}
	return isWinLeftBoarder(id,boarder)||isWinRightBoarder(id,boarder)
}
isOnSearchBar(){
	MouseGetPos,,my,id
	if (isMpcWin(id)) {
		id:=getctid()
		WinGetPos,,y,,h,ahk_id %id%
		dif:=y+h-my
		difabs:=Abs(dif)
		ret:=(difabs < 20)
		;ToolTip %dif% %ret%
		return ret

	}
}


isWinBottomBoarder(id:="", boarder:=60,mp:=""){
	if (id=="") {
		id:=getctid()
	}
	if(mp!=""){
		my:=mp.y
		id:=mp.id
	}else{
		MouseGetPos,,my,id
	}


	WinGetPos,,y,,h,ahk_id %id%
	dif:=y+h-my
	difabs:=Abs(dif)
	ret:=(difabs < boarder)
	;ToolTip %dif% %ret%
	return ret
}

isFullscreenarea(mp:=""){
	return isWinBottomBoarder("",60,mp)
}



isOnLeftScreenBoarder() {
	getScreenpos(getscreenFromMouse(),x,y,w,h)
	MouseGetPos,mx,my,id
	ret := mx == x
	return ret
}

isleftscreenboarder(mp:=""){

	if(mp!=""){
		x:=mp.x
		y:=mp.y
		id:=mp.id
	}else{
		MouseGetPos,x,y,id
	}
	
	getScreenPos(getscreenFromId(id),sx,sy,w,h)

	if(x==sx) {
		ret:= true
	}else{
		ret:=false
	}
	 ret:=ret||isWinLeftBoarder()
	 return ret
}

isrightscreenboarder(mp:=""){

	if(mp!=""){
		x:=mp.x
		y:=mp.y
		id:=mp.id
	}else{
MouseGetPos,x,y,id
	}
	
	getScreenPos(getscreenFromId(id),sx,sy,w,h)
	;ttos(x,sx,w)
	if(x==sx+w-1) {
		;tt(true)
		ret:= true
	}else{
		ret:=false
	}
	 ret:=ret||isWinRightBoarder()
	 return ret
}


IsLeftOrRightArea(){
	return isleftscreenboarder() ||isrightscreenboarder()
}

IsTopOrBottomArea(mp:=""){
	return isFullscreenarea(mp) ||  IsOverTopScreenline(mp)
}


boarder(){
	return 80
}


IsOverRightScreenline(mp:=""){
	if(mp!=""){
		mx:=mp.x
		id:==mp.id
	}else{
		MouseGetPos ,mx,,id
	}
	
	getscreenpos(getscreenFromId(id),x,y,w,h)
	;ToolTip, %mx% %x%
	d:=(x+w-1)-mx
	
	b:=boarder()
	;ttos(x,mx,d)
if (d<b) {
	ret:= true
}else{
	ret:= false
}
;ttos(ret)
return ret
}
IsOverLeftScreenline(mp:=""){
	if(mp!=""){
		mx:=mp.x
	}else{
		MouseGetPos ,mx
	}
	
	getscreenpos(getscreenFromMouse(),x,y,w,h)
	;ToolTip, %mx% %x%
	d:=mx-x
	b:=boarder()
	
if (d<b) {
	ret:= true
}else{
	ret:= false
}
;ttos(ret)
return ret
}

IsOverScreenline(mp:=""){
if(mp!=""){
	mx:=mp.x
	my:=mp.y
	id:=mp.id
}else{
	MouseGetPos ,mx,my,id
}

getscreenpos(getscreenFromId(id),x,y,w,h)
;ToolTip, %mx% %x%
if (mx==x||mx==x+w-1||my==y||my==y+h-1) {
	ret:= true
}else{
	ret:= false
}
ret:=ret||isWinUpperBoarder()
return ret
}


IsOverTopScreenline(mp:=""){
if(mp!=""){
	mx:=mp.x
	my:=mp.y
	id:=mp.id
}else{
	MouseGetPos ,mx ,my ,id
}
	

	
if (my==1080||my==0) {
	ret:= true
}else{
	ret:= false
}
ret:=ret||isWinUpperBoarder(id)
if (ret) {
	getscreenpos(getscreenFromMouse(),x,y,w,h)
	
}
return ret
}


runkb() {
	;DllCall("Wow64DisableWow64FsRedirection", "uint*", OldValue)
	;Run,%windir%\system32\osk.exe
	Run,osk.exe
	;DllCall("Wow64RevertWow64FsRedirection", "uint", OldValue)	
}

keyboard() {
	runkb()
}

fixTransparency(id) {
  id:=getRoot(id)
       ;    return
        removetrancparency(id)
        PixelGetColor, MouseRGB, %menposx%, %menposy%, RGB
        ;In seems necessary to turn off any existing transparency first:
    WinSet, TransColor, Off, ahk_id %id%
    ;WinSet, TransColor, %MouseRGB%, ahk_id %id%
    ;    mm(menposx " " menposy " " " "colortostring(MouseRGB) getWinInfo(id))

    ;    ttt()
}

calcCount2ColsRows(N,ByRef cols,ByRef rows) {
	cols:=1
	while(1) {
		rows:=1
		while(rows <= cols) {
			if(rows*cols >= N) {
					return
			}
			rows++
		}
		cols++
	}
}

getgridrects(i) {
	if (i=3) {
		return get3gridrects()
	}
	calcCount2ColsRows(i, rs, cs)
	
	getscreenpos(getscreenFromMouse(),x,y,w,h)
	iw:=round(w/cs)
	ih:=Round(h/rs)
	rects:=Object()
	cols:=1
	;mos(i, rs, cs,x,y,w,h, iw, ih)
	
	while(cols<=cs) {
		rows:=1
		while(rows<=rs) {
			xr:=x+(cols-1)*iw
			yr:=y+(rows-1)*ih
			r:=rect.fromChoord(xr,yr,iw,ih)
			rects.push(r)
			rows++
		}

		cols++
	}
	;mos(rects)
	return rects
}

get3gridrects(i:=3) {
	getscreenpos(getscreenFromMouse(),x,y,w,h)
	iw:=round(w/cs)
	ih:=Round(h/rs)
	rects:=Object()
	hf:=0.4
	h1:=round(h*hf)
	h2:=h-h1
	w1:=w/2
	rects.push(rect.fromChoord(x,y+H1,w,h2))
	rects.push(rect.fromChoord(x,y,w1,h1))
	rects.push(rect.fromChoord(x+w1,y,w1,h1))
	ret:=Object()
	;mos(rects)
	loop 
	{
		idx:=0
		loop 3
		{
			idx++
			if(ret.maxindex() >=i){
				return ret
			}
			r:=rects[idx]
			ret.push(r.clone())
		}
	}
	return rects
}

get4gridrects(i) {
	if (i=3) {
		return get3gridrects()
	}
	getscreenpos(getscreenFromMouse(),x,y,w,h)
	iw:=w/2
	ih:=h/2
	rects:=Object()
	cols:=1
	loop %i% ;while(cols<=cs) 
	{
		modi1:=mod(A_Index-1, 4)
		modi2:=0
		if(modi1>1){
			modi1:=modi1-2
			modi2:=1
		}
		ix:=x+(modi1*iw)
		iy:=y+(modi2*ih)

		r:=rect.fromChoord(ix,iy,iw,ih)
		rects.push(r)
	}
	return rects
}


getstaplerects(i) {
	getscreenpos(getscreenFromMouse(),x,y,w,h)
	iw:=w
	ih:=h/2
	rects:=Object()
	cols:=1
	loop %i% 
	{
		modi:=mod(A_Index-1, 2)
		ix:=x
		iy:=y+(modi)*ih
		r:=rect.fromChoord(ix,iy,iw,ih)
		rects.push(r)
	}
	return rects
}



getstapleVertrects(i) {
	getscreenpos(getscreenFromMouse(),x,y,w,h)
	iw:=w/2
	ih:=h
	rects:=Object()
	cols:=1
	loop %i% 
	{
		modi:=mod(A_Index, 2)
		iy:=y
		ix:=x+(modi)*iw
		r:=rect.fromChoord(ix,iy,iw,ih)
		rects.push(r)	
	}
	return rects
}

getPlayerObjsOrderedTopFirst(filter:="cmh"){
	ret:=Object()
	psIds:=getPlayerIdsOrderedTopFirst(filter)
	for index,id in psIds
	{
		w:=new winrect(id)
		w.isplaying:="dont know"
		ret.push(w)
	}
	return ret
}

getPlayerIdsOrderedTopFirst(filter:="cmh"){
	ret:=Object()
	set:=Object()
	WinGet, ids, List, ahk_group grpPlayers
	;MsgBox %ids%
	Loop, %ids%
	{
		StringTrimRight, id, ids%a_index%, 0
		if (ismpcwinVideo(id)) {
			
			if(!set.HasKey(id)){
				set[id]:=1
				ret.push(id)
			}

		}
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
	if(InStr(filter,"s")){
		ret :=getNoOtherScreen(ret)
	}
	
	return ret
}



moveTopFirstPlayerIdsOnRectsOfObjs(playerObjs,playlast:=""){
	ids:=Object()
	rects:=Object()
	For index, w in playerObjs {
		ids.push(w.id)
		w.rect.isplaying:=w.isplaying
		rects.push(w.rect)
	}
	moveTopFirstPlayerIdsOnRects(ids,rects,playlast)
}


layoutPlayers(pso,rects,playlast:=""){
	ps:=pso
	moveTopFirstPlayerIdsOnRects(ps,rects,playlast)

}

moveTopFirstPlayerIdsOnRects(ps,rects,playlast:="") {
    if (playlast=="") {
		playlast:=getmaxplaying()
     }
	if( isInteger(playlast)) {
		if (playlast!="") {
			mi:=ps.maxindex()
			plAfter:=mi-playlast
		}
	}else{
		isplayingFromRect:=true
	}
	;mos(isplayingFromRect,rects)
 ;ttos(playlast "  " plAfter)
	ps:=Array_Reverse(ps)
	mi:=ps.maxindex()
	For index, id in ps {
		r:=rects[mi+1-index]
		if(isplayingFromRect){
			if(!r.isplaying){
				pause(id)
			}
		}else{
			if ((playlast!="") && (index > plAfter)) {
				;play(id)
			} else {
				if(getParam("fadeOutStopsVar")){
					pause(id)
				}
			}
		}
    }
	
	For index, id in ps {
		r:=rects[mi+1-index]
		;        mm(s(r))
		;assureNotMinimizedPlayer(id)
		move2Rect(id,r)
		;setTopmostRight(id)
		;mpcsend_PnS_Reset(id)
		;        mpcsend_VidFrm_Inside(id)
		;mpcsend_VidFrm_outside(id)
		
		if(isplayingFromRect){
			if(r.isplaying){
				play(id)
			}
		}else{
		
			if ((playlast!="") && (index > plAfter)) {
				play(id)
			} else {

			}
		}
        ;        mm("moveTopFirstPlayerIdsOnRects")
    }
    ctToTop()
}

arePlayerIdsOnRects(ps,rects) {
	;ps:=Array_Reverse(ps)
	rectsIst:=Object()
	For index, id in ps {
		w:=new WinRect(id)
		r:=w.rect
		r.id:=id
		rectsIst.push(r)
	}
	;
	For index, rist in rectsIst {
		rsoll:=rects[index]
		;equ:=rsoll.equal(rist)
		equ:=equalrect(rist,rsoll)
		if(!equ){
			;mos(rist,rsoll)
			return false
		}
	}
	return true
}

assureNotMinimizedPlayer(id,touch:=false){
	;mm("fffff")
	WinGet, WinState, MinMax, AHK_id %id%

	If (WinState == -1 ||touch) { ; If not minimized, activate 
		;Result := DllCall("ShowWindow", "UInt", id, "Int", 4)
		WinRestore,AHK_id %id%
	}
	if(!hasVisibleStyle(id)||touch){
		WinShow, ahk_id %id%
	}
	
	If (isclickthrough(id)) { 
		setTopMost(id,true)
		WinActivate, ahk_id %id%
	}
	
	if(touch){
		WinActivate, ahk_id %id%
	
	}

}

move2Rect(id,r){
	;mos(id,r)
	WinMove, % "ahk_id " id,,r.x , r.y, r.w, r.h
}

setTopmostRight(id){
	rs:=rectfromScreen(getscreenFromPoint(new rect(id).getCenter()))
	r:=new rect(id)
	wi:=getwininfobase(id)
	full:=r.equal(rs)
	;tma:=istopmost(id)
	if(full){
		setkeepOTAndTopmost(false,id)
	}else{
		setkeepOTAndTopmost(true,id)
	}
	;tmb:=istopmost(id)
	;ttos(full,wi,tma,tmb)
	
}

play(id:="",normsound:=true){
	if(id==""){
		id:=getctid()
	}
	if (ismpcwin(id)) {

		
		;Sleep 100
		if (isDebug()) {
			tt("play " . getwininfobase(id))
		}
		
		assureNotMinimizedPlayer(id)
		;ttt()
		;ControlSend  ,,{LCtrl Down}u{LCtrl Up},AHK_id %id%
		mpcsend_Play(id)
		if (normsound) {
			v2().normsound(id)
		}
	}	
}

ctToTop() {
    for index,id in Array_Reverse(getPlayerIdsOrderedTopFirst(".")) {
        If (isclickthrough(id)) {
            setTopMost(id,true)
            WinActivate, ahk_id %id%
        }

        If (gettrans(id)<30) {
            settrans(30,id)
            
        }
    }
}

rectfromScreen(Screen) {
	;mos(screen)
	getScreenPos(Screen,x,y,w,h)
	ret:= new rect()
	ret.x:=x
	ret.y:=y
	ret.w:=w
	ret.h:=h
	;mos(screen,ret,x,y,w,h)
	return ret
}

class v2Man 
{
    v2Handles := Object()
    ;static ClassVar := Expression
	
	getHandle(id){
		pid:=getPidFromWin(id)
		ret:=this.v2Handles[pid]
		if (0 || !ret) {
			ret:=getSimpleAudioVolume(pid)
			this.v2Handles[pid]:=ret
		}
		return ret
	}

	transtovol(t, ByRef top, ByRef ct){
		range:=this.getNormLevel()-this.getMinv()
		f:=t/256
		top:=f*range+this.getMinv()
		ct:=this.getNormLevel()-Top
	}

	getNormLevel(){
		return 1.0
	}

	getMuteLevel(){
		return 0.05
	}
	
	getMinv(){
		
		muteTotal:=readini()["muteTotal"]
		if (muteTotal) {
			minv:=0
		}else{
			minv:=this.getMuteLevel()
		}
		return minv
	}

	getv(id){
		VA_ISimpleAudioVolume_GetMasterVolume(this.getHandle(id), ret)
		return ret
	}

	limit(level){
		if (level<0) {
			level:=0.0
		} else if (level>1) {
			level:=1.0
		}
		return level
	}
	getfullstepcount(){
		return 100
	}
	
	getnormstepcount(){
		return this.getfullstepcount()/this.getNormLevel()
	}
	
	gettMutestepcount(){
		return this.getfullstepcount()/this.getMuteLevel()
	}
	
	getstepwidth(){
		return 1/this.getfullstepcount()
	}
	
	shiftvstep(id,up,min:=0,max:=1){
		if (up){
			this.shiftv(id,this.getstepwidth(),min,max)
		}else{
			this.shiftv(id,0-this.getstepwidth(),min,max)
		}
	}
		

	shiftv(id,diff,min:=0,max:=1){
		v:=this.getv(id)
		vnew:=v+diff
		vnew:=max(vnew,min)
		vnew:=min(vnew,max)
		this.setv(id,vnew)
	}

	

	

	
	fadeSound(id,up,volStep:=""){
		;ttc(id,up,volStep)
		if (volStep=="") {
			volStep:=this.getstepwidth()
		}
		if (up) {
			while ((cv:=this.getv(id))<1){
				;ttt(nv)
				nv:=cv+volStep
				this.setv(id,nv) 
				Sleep,50
			}
		}else{
			Minv:=this.getMinv()
			while ((cv:=this.getv(ID))>Minv){
				nv:=cv-volStep
				this.setv(id,nv) 
			}
		}
	}

	setv(id,level){
		;ttos(id,level)
		h:=this.getHandle(id)
		if(h){
			VA_ISimpleAudioVolume_SetMasterVolume(h, this.limit(level), 0)
		}
	}
	
	mutesound(id,total:=true){
		if (total) {
			this.setv(id,0.0)
		}else{
			this.setv(id,this.getMuteLevel())
		}
	}
	
	normsound(id){
		this.setv(id,this.getNormLevel())
	}
}

v2(){
	global v2
	if (!v2) {
		v2:=new v2Man()
	}
	return v2
}

loopSound(doUp,allScreensmod,meToo) {

    ;    tt("loopSound")
    loopSoundallScreens := readini()["loopSoundallScreens"]
    
allScreens:=allScreensmod || loopSoundallScreens


     ;    ToolTip %doUp% %allScreens%
    mousegetpos,x ,y,myid

myscreen:=getscreenFromId(myid)
 myclass:=getclass(myid)
    if (!x) {
myid:=0
 myscreen:=0
      }

      static gPlayerWins
  static gLastCall :=0

   nt:=A_TickCount
    if (nt-gLastCall>3000 || !IsObject(gPlayerWins)) {
        ;        tt("newBuild")

gPlayerWins:=Object()
        For id, value in getPlayers() {
screen:=getscreenFromId(id)
 scrok:=allScreens ? true : myscreen==screen
            if (meToo || id != myid && scrok) {
                gPlayerWins.push(id)
            }
        }
    }
gLastCall :=nt

    for index, id in gPlayerWins {
    if (doUp) {
            mpcsend_Volume_Up(id)
        } else {
            mpcsend_Volume_Down(id)
        }
    }

    return


}

getPlayers(){
	ret:=Object()
	For index, id in getPlayerIdsOrderedTopFirst("h"){
		ret[id]:=1
	}

	return ret
}


wheelIsTopOrBottomArea(up) {
	id:=getctid()
	 fast:=isBoarderPixelBottom() ||isBoarderPixelTop()
      mpcStep(id,up,fast,false,getLoopc(true))
 }

 isBoarderPixelBottom(){
	MouseGetPos,x,y
	getScreenpos(getscreenFromMouse(),  sx,  sy,  sw, sh )
	return y==sy+sh-1
}

isBoarderPixelTop(){
	MouseGetPos,x,y
	getScreenpos(getscreenFromMouse(),  sx,  sy,  sw, sh )
	return y==sy
}
isBoarderPixelRight(){
	MouseGetPos,x,y
	getScreenpos(getscreenFromMouse(),  sx,  sy,  sw, sh )
	return x==sx+sw-1
}

 isBoarderPixelLeft(){
	MouseGetPos,x,y
	getScreenpos(getscreenFromMouse(),  sx,  sy,  sw, sh )
	return x==sx
}


mpcStep(id,forward, fast:=false, byframe:=false,loopc:=1,vfast:=false) {
    ;cid:=getSeekbar(id)
     ;r:=new rect(cid)
    mousegetpos,mx,my
    WinGetPos,x,y,w,h,ahk_id %id%
x2:=x+3
 y2:=y+h-3
      ;    MouseMove,x2,y2,0
    ;    ControlMouseMove(X2, Y2, "", "ahk_id" %id%)

cid:=ID
     ;cid:=

        ;    PostMessage, 0x200, 0, x2 &0xFFFF | y2 <<16,, ahk_id %cid% ;WM_MOUSEMOVE
    
    ;    Sleep 1000





    ;    ttt("mpcStep",forward,  fast, byframe,loopc)
    ;    tt(loopc)
    if (loopc>18) {
        ;        tt("loopc>")
fast:=true
     }
    if (loopc>23) {
        ;        tt("loopc>")
vfast:=true
     }

 byframe:=false

    loop 1 {
        if (byframe) {
            ;            ttt5()
            if (forward) {
                mpcsend_Framestep(id)
            } else {
                mpcsend_Framestep_back(id)
            }
            global AfterByFrameid
AfterByFrameid:=id
             SetTimer,AfterByFrame,-2000
        } else if (vfast) {
            if (forward) {
                mpcsend_Jump_Forward_large(id)
            } else {
                mpcsend_Jump_Backward_large(id)
            }
        }

        else if (fast) {
            if (forward) {
                mpcsend_Jump_Forward_medium(id)
            } else {
                mpcsend_Jump_Backward_medium(id)
            }
        } else {
            if (forward) {
                mpcsend_Jump_Forward_small(id)
            } else {
                mpcsend_Jump_Backward_small(id)
            }
        }
    }
    ;SetTimer,moveMouseSeekCurTimer,-100
    return


        AfterByFrame:
            global AfterByFrameid
            normsound_play(AfterByFrameid)

            return
                ;    MouseMove,mx,my,0
}

normsound_play(id){
	v2().normsound(id) ;,alreadymute)
   
   play(id)

}
