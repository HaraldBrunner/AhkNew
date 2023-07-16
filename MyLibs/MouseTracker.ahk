
class TrackInfoInternal {

	__New(callback,modKeys,allowkeys){
		this.StartInfo:=new StartInfo()
		this.cb:=callback
		this.modKeys:=modKeys
		this.allowkeys:=allowkeys
		return this
	}
	
	CheckBreak() {
		modKeys:=this.modKeys
		allowkeys:=this.allowkeys
		SetFormat, Integer, D

		allmodkeys:=getmodkeys()
		;hk:=extractKey(A_ThisHotKey)
		;tt("hk:A_ThisHotKey " . hk " __ " . A_ThisHotKey)
		for index, key in modKeys
		{
			allmodkeys.push(key) 
			;~ if(key==hk){
				;~ okFound:=true
			;~ }
		}
		
		s:=""
		for index, element in allmodkeys  
		{
			elDown:=GetKeyState(element)
			;s= %s% `n  %element% down %elDown%  
			if((elDown && !arrayContains(modKeys,element)  && !arrayContains(allowkeys,element)) || (!elDown && (arrayContains(modKeys,element))) ) {
				;s = broke w %element% down %elDown%  
				if(s) {
					tt(s)
				}
				return true
			}
		}
		return false
	}
}

class StartInfo {
	mstartpos:=0
	wstartpos:=0
	tick:=0
	__New(){
		this.init()
		
		return this
	}
	init(){
		this.mstartpos:= ClassPoint.frommouse()
		this.wstartpos:=new WinRect(this.mstartpos.id)
		tick:=A_TickCount
	}
}

class MouseTrackerCB {

	__New(){
		MouseTrackerCB.finishLastTracker(this)
	}
	
	finishLastTracker(ninst){
		global gcb
		if(IsObject(gcb)){
			gcb.breakext:=true
			
		}
		gcb:=ninst
	}
	
	
	
	startTrack(startinfo) {
	}
	tracking(startinfo, nowMPos, dx, dy,trackdata) {
		return true
	}
	stopTrack(startinfo, nowMPos, dx, dy){
	}
	getSleepTime(){
			return 200
	}
}

class MouseTracker{
	
	
	track(mtcp,modKeys,allowkeys:=""){
		if(allowkeys==""){
			allowkeys:=Object()
		}
		if (this.trackData=="") {
			this.trackData:=new TrackInfoInternal(mtcp,modKeys,allowkeys)

			this.trackData.cb.startTrack(this.trackData.startinfo)
	

			Loop{
				;tt(A_Index )
				
				if (this.trackData.CheckBreak()) {
					;tt("this.trackData.CheckBreak()")
					break
				}
			
				
				this.calcPos(nowMPos, dx, dy)
				;tt("2")
				;tt(cb)
				contnue:=this.trackData.cb.tracking(this.trackData.startinfo, nowMPos, dx, dy, this.trackData)
				if (!contnue) {
					;tt("no continue")
					break
					
				}
				Sleep, % this.trackData.cb.getSleepTime()
			}
			
			this.calcPos(nowMPos, dx, dy)
			this.trackData.cb.stopTrack(this.trackData.startinfo, nowMPos, dx, dy)

			
			this.trackData:=""
		}else{
			;tt("already tracking for ")
		}
		
	}
	calcPos(ByRef nowMPos, ByRef dx, ByRef dy){
		nowMPos:=ClassPoint.frommouse()
		dx:=nowMPos.x - this.trackData.startinfo.mstartpos.x
		dy:=nowMPos.y - this.trackData.startinfo.mstartpos.y
	}
	instance() {
			static inst:=""
			if(!inst) {
				inst:=new MouseTracker()
			}
			return inst
	}
}