
extractKey(pk){
	NewStr := pk
	NewStr := RegExReplace(NewStr, "~", "")  
	NewStr := RegExReplace(NewStr, "\*", "") 
	NewStr := RegExReplace(NewStr, "\$", "") 
	;tt(NewStr)
	return NewStr
}

class KeyCounter{
	__New(k, cf:="",maxInterval:=800,maxDownTime:=500){
		this.k:=k
		this.resetData()
		this.cf:=cf
		this.maxDownTime:=maxDownTime
		this.maxInterval:=maxInterval
		this.timerfo:=Func("KeyCounterTime").Bind(this)
	}

	

	resetData() {
		;tt("reset")
		this.downCount:=0
		this.upCount:=0
		this.mouseButtonHit:=0
		this.mpos:=""
		KeyCounter.Wheel:=0
	}

	MouseDown(){
		this.mouseButtonHit :=1
	}

	keydown() {
		this.t1Down:=A_TickCount
		;tt(this.k . " keydoun")
		this.priorKey:=A_ThisHotkey
		if (this.downCount==0) {
			this.mouseButtonHit :=0
			this.mpos:=ClassPoint.frommouse()
		}
		this.downCount:=this.downCount+1
		;tt("newdc" . this.downCount)
		return this.downCount
	}
	
	keyUp(){
		tkeydown:=A_TickCount-this.t1Down
		;tt("keyUp")
		if (this.downCount <= this.upCount){ ;this.downCount <= this.upCount) {
			;tt(this.k, "strange reset")
			;timer inbetween->cleanup
			this.resetData()
			return
		}
		

		pm:=ClassPoint.frommouse()
		if(this.mpos){
			dist:=this.mpos.dist(pm)
		}
	
		
		;mos(dist,this,pm)
		
		if( !this.mpos || (dist > 4)){
			;ttos("move reset",this.mpos,dist)
			this.resetData()
			return
		}
		
		
		;tt(this.k . " keyUp")
		;tt("LShift up ")
		this.upCount:=this.upCount+1

		;if (((A_PriorHotkey <> "~" . this.k)&&(A_PriorHotkey <> "~" . this.k . " up")) or A_TimeSincePriorHotkey > 400  || A_PriorKey <> || this.priorKey==A_PriorKey || this.mouseButtonHit)
		pk:=A_Priorkey
		;tt("A_PriorHotkey:" . pk)
		epk:=extractKey(pk)
		ok:=RegExMatch(epk,"^" . this.k)
		if(!ok){
			;ttos("!ok",pk,epk, this.k)
		}
		
		;tt(epk . " ok:" . ok)
		
		
		mb:=this.mouseButtonHit
		
		;tt("A_TimeSincePriorHotkey:" . A_TimeSincePriorHotkey)
		;tt("mb:" . mb)
		;tt(":" . )
		;tt(":" . )
		
		;tt("this.maxInterval:" this.maxInterval "  this.maxDownTime:" this.maxDownTime "   A_TimeSincePriorHotkey"A_TimeSincePriorHotkey "  tkeydown"tkeydown "  mb:" mb)

		if (mb) {
			ttos("mb:" . mb)
			this.resetData()
			return
		}

		if ((!ok) || (A_TimeSincePriorHotkey > this.maxInterval)  ||  mb || (tkeydown > this.maxDownTime))
		{
			;mos(this.upCount,this.k, ok,A_TimeSincePriorHotkey,this.maxInterval, mb ,tkeydown , this.maxDownTime)
			;debugbreak()
			;tt("OFF timer" . this.upCount)
			this.configTimer(true)
		} else {
			;tt("conf timer" . this.upCount)
			this.configTimer(false) 
		}
	}
	
	configTimer(off) {
		fo:=this.timerfo
		;tt("configTimer:" . off)
		if (off){
			;tt("configTimerOFF")
			SetTimer,%fo%, OFF
			;SetTimerF( "KeyCounterTime", 0,0, 0 )
			this.resetData()
			
		}else{
			tim:=0-this.maxInterval
			SetTimer,%fo%, %tim%
			;SetTimerF( "KeyCounterTime", tim,Object(1,this), 0 )
		}
		return
	}
	
	timeDown(){
		;tt("ALTtimeDown this.upCount:" . this.upCount)
		uc:=this.upCount
		mp:=this.mpos
		this.resetData()
		if(uc){
			this.onKeyCount(uc,mp)
		}
		
	}
	
	onKeyCount(c,mp){
		;tt(this.k . " " . c)
		if(this.cf){
			this.cf(c,mp)
		}else{
			tt(this.k . " " . c)
		}
	}
}

KeyCounterTime(obj){
	;tt("KeyCounterTime")
	obj.timeDown()
}