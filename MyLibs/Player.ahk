#NoEnv

isMpcVideoCtrl(cnn:="") {
	if (cnn=="") {
		MouseGetPos,,,,cnn

	}
	;tt("cnn " cnn)
	return RegExMatch(cnn,"^Afx")  ||RegExMatch(cnn,"^madVR")

}

isMpcVideoCtrlOrSeekBar(cnn:="") {
	if(cnn==""){
		MouseGetPos,,,,cnn	
	}

	;tt(cnn)
	if (cnn=="#327704") { ;seekbar
		return true
	}
	mpcvid:=isMpcVideoCtrl(cnn)
	return mpcvid
}

mouseOnCtrlBoarder(){
	MouseGetPos,mx,my,cid,2
	WinGetPos,x,y,w,h,ahk_id %cid%
	
	ret:= mx==x || mx==x+w-1 || my==y || my==y+h-1
	;s(mx,my,x,y,w,h)
	;tt(ret)
	return ret
}

isMpcWinWithCtrlCheck(id:="") {
    if(id==""){
        id:=getWindowFromPoint(point.frommouse())
    }
    ret := ismpcwin(getctid(true)) || ismpcwin(id) && (isMpcVideoCtrlOrSeekBar()||mouseOnCtrlBoarder())
        ;      tt(ret)
    return ret
}


sizeplayer(id,up,loopc:=1) {
    global lastsizeplayer
    if (!lastsizeplayer) {
        lastsizeplayer:=0
     }

    if (A_TickCount-lastsizeplayer <100) {
        return
    }
    lastsizeplayer := A_TickCount
    WinGetClass,class,ahk_id %id%

    loopc:=getLoopc(true)

    loop, %loopc% {
        if (up) {
            mpcsend_PnS_Inc_Size(id)
        } else {
            mpcsend_PnS_Dec_Size(id)
        }
    }
}

getLoopc(withFactor){

    ;return 1
        loopc:=1
        if(A_EventInfo>1) {
            ;tt("A_EventInfo" . A_EventInfo)
            loopc:=A_EventInfo
        }
        ;tt("loopc" . loopc)
        if (withFactor) {
            loopc:=getWheelFactor(loopc)
        }
        ;tt("loopcgetWheelFactor" . loopc)
        return loopc
    }
    getWheelFactor(loopc){
        in:=loopc
        nt:=A_TickCount
        static lt
        if (lt) {
            
            d:=nt-lt
            
            rd:=200/d
            
            rd:=(rd*rd) + 1
            
            loopc:=	loopc*rd
        
            loopc:=	Round(loopc)
            
        }
        lt:=nt
        out:=loopc
        ;ttt(in,out)
        return loopc
    
    }

    rate(up,fast,id:="") {
        if(id==""){
            id:=getctid()
        }
        c:=1
        if (fast) {
            c:=5
         }
    
        loop %c% {
            if (up) {
                mpcsend_Increase_Rate(id)
            } else {
                mpcsend_Decrease_Rate(id)
            }
        }
    }