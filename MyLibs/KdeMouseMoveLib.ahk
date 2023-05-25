#Include base.ahk

getMouseRelativeWindow(ByRef x,ByRef y,id:=""){
	
	MouseGetPos,mx,my,idMouse
	if (id==""){
		id:=idMouse
	}
	
	WinGetPos,sx,sy,w,h,ahk_id %id%
	
	mx:=mx-sx
	my:=my-sy
	;ToolTip % mx . "  xy  " . my
	x:=mx/w
	y:=my/h	
	;ToolTip % mx . "  mx my  " . my . "  ---  " . w . "  wh  " . h . "  ---  " . x . "  xy  " . y
}

getMoveableWindow(id,p){
	;mos(p)
	KDE_X1:=p.x
	KDE_Y1:=p.y
	
	mw:=Object()
	mw.w:=new WinRect(id)
	mw.id:=id
	getMouseRelativeWindow(mrx,mry,id)
	mw.mrx:=mrx
	mw.mry:=mry
	onlys:=0.1
	mw.onlyy:=abs(mrx-0.5) <onlys
	mw.onlyx:=abs(mry-0.5) <onlys
	
	
	
	
	WinGet,MinMax,MinMax,ahk_id %id%
	If (MinMax) {
		WinGetPos, X, Y, Width, Height,ahk_id %id%
		;MsgBox, %X%  %Y% %Width% %Height%
		WinRestore, ahk_id %id%
		;Sleep, 500
		WinMove, ahk_id %id%,, X, Y, Width, Height
	}
	
	WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %id%

	; Define the window region the mouse is currently in.
	; The four regions are Up and Left, Up and Right, Down and Left, Down and Right.
	
	
	;mos(KDE_X1, KDE_WinX1, KDE_WinW)
	If (KDE_X1 < KDE_WinX1 + KDE_WinW / 2) {
		mw.KDE_WinLeft := 1
	} Else {
	   mw.KDE_WinLeft := -1
	}
	
	If (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2){
	   mw.KDE_WinUp := 1
	} Else {
	   mw.KDE_WinUp := -1
	}
	return mw
}


isOnBoarder(p,id) {

	router:=new rect(id)
	; t.= getwininfo(id) ObjToStr(router)
	BOARDERWITH:=20
	router.inflate(BOARDERWITH)
	
	; t.=ObjToStr(router)
	;mos(t)
	rinner:=new rect(id)
	rinner.inflate(1-BOARDERWITH)
	
	inOuter:=isPointInRect(p,router)
	inInner:=isPointInRect(p,rinner)
	if(inOuter && !inInner){
		ret:= true
	}else{
		ret:= false
	}
	
	;mos("router",router,"rinner",rinner,"p", p,id, "inOuter", inOuter, "inInner", inInner, "ret", ret)
	;tt("ret" ret)
	return ret
}

kdeMouseMove(key,activateKey) {
	; Get the initial mouse position and window id, and
	; abort if the window is maximized.
	MouseGetPos,KDE_X1,KDE_Y1,KDE_id
	p:=mypoint.frommouse()
	wins:=Object()
	isOnInitBoarder:= isOnBoarder(p,KDE_id)
	if(isOnInitBoarder){

		;mos("foo")
		WinGet, ids, list, , , Program Manager
		Loop, %ids%
		{
			StringTrimRight, id, ids%a_index%, 0
			if (1) {
				if(isVisWin(id)){
					WinGet,MinMax,MinMax,ahk_id %id%
					if (MinMax!=-1) {
						if(isOnBoarder(p,id)){
							wins.Insert(getMoveableWindow(id,p))
						}
					}
				}
			}
		}
	}else {
		wins.Insert(getMoveableWindow(KDE_id,p))
	}

	Loop
	{
		;mos(wins)
		GetKeyState,KDE_Button,%key% ,P ; Break if button has been released.
		If KDE_Button = U
			break
		GetKeyState,theActivateKey,%activateKey% ,P 	
			
		MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
		mouseDiffX := KDE_X2 - KDE_X1 ; Obtain an offset from the initial mouse position.
		mouseDiffY := KDE_Y2 - KDE_Y1
		for index, mw in wins {
			KDE_id:=mw.id
					
			KDE_WinX2 := (mw.w.rect.x + mouseDiffX) ; Apply this offset to the window position.
			KDE_WinY2 := (mw.w.rect.y + mouseDiffY)
			width := mw.w.rect.w
			heigth := mw.w.rect.h
			WinMove,ahk_id %KDE_id%,,%KDE_WinX2%,%KDE_WinY2%,%width%,%heigth% ; Move the window to the new position.

			If theActivateKey = D
				WinActivate,ahk_id %KDE_id%
		}
	}	
}


kdeMouseResizeMulti(key) {
    ; Get the initial mouse position and window id, and
    ; abort if the window is maximized.
    MouseGetPos,KDE_X1,KDE_Y1,KDE_id
    p:=mypoint.frommouse()
	;mos("nurP" , p)
    
    wins:=Object()
	isOnInitBoarder:= isOnBoarder(p,KDE_id)
	if(isOnInitBoarder){

		;mos("foo")
		WinGet, ids, list, , , Program Manager
		Loop, %ids%
		{
			StringTrimRight, id, ids%a_index%, 0
			if (1) {
				if(isVisWin(id)){
					WinGet,MinMax,MinMax,ahk_id %id%
					if (MinMax!=-1) {
						if(isOnBoarder(p,id)){
							wins.Insert(getMoveableWindow(id,p))
						}
					}
				}
			}
		}
	}else {
		wins.Insert(getMoveableWindow(KDE_id,p))
	}
    ;mos("isOnInitBoarder",isOnInitBoarder,wins)
   lc:=0
    
	singleWin:=wins.MaxIndex()==1
	
    Loop
    {
        lc++
       ; ToolTip lc%lc%
        GetKeyState,KDE_Button,%key% ,P ; Break if button has been released.
        If KDE_Button = U
            break
        MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
        
		xDif := KDE_X2 - KDE_X1 ; Obtain an offset from the initial mouse position.
		yDif := KDE_Y2 - KDE_Y1

		
        for index, mw in wins {
			KDE_id:=mw.id
            ;mos(mw,"mw in loop")
        
			onlyx := mw.onlyx && singleWin
			onlyy := mw.onlyy && singleWin
			
			ZeroIfonlyx := onlyx ? 0 : 1
			ZeroIfonlyy := onlyy ? 0 : 1

            X:=mw.w.rect.x + (mw.KDE_WinLeft+1) / 2 * xDif * ZeroIfonlyy
            Y:=mw.w.rect.y + (mw.KDE_WinUp +1) / 2 * yDif * ZeroIfonlyx
            W:=mw.w.rect.w - mw.KDE_WinLeft  		* xDif * ZeroIfonlyy
            H:=mw.w.rect.h - mw.KDE_WinUp  		* yDif * ZeroIfonlyx

			;ttos(lc, KDE_X1,KDE_Y1, xDif,yDif,X)
            WinMove,ahk_id %KDE_id%,,%X%,%Y%,%W%,%H%  
        }
    }
}