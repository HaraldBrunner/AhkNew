panmode() {
    return true
}

class MouseTrackerCBLAlt extends MouseTrackerCB {
    pixelPerSecondWithOneDX:=0.5

    Dexp(d) {
        s:=d>0 ? 1 : -1
        r:=d + s * d *d / 400
        return r
    }

    startTrack(startinfo) {

        this.init(startinfo)
    }

    init(startinfo) {
        this.lastTick:=""

        this.lastrect:=0

        aid := getActiveWin()
        this.sid:=startinfo.wstartpos.id
        this.active:=aid == this.sid
        this.ok:=isMpcWin(this.sid)
    }
    getSign(posneg) {
        if (posneg>=0) {
            return 1
        } else {
            return -1
        }
    }

    getFullTab(flo) {
        absFullTab:=Round(abs(flo) + 0.5)-1
        if (absFullTab<0) {
            absFullTab:=0
        }
        r:=absFullTab*this.getSign(flo)
        return r
    }

    schwelle(ByRef in, absSchwelle) {
        n:=abs(in)-absSchwelle

        if (n<0) {
            n:=0
        }
        r:=n*this.getSign(in)
        r:=this.getFullTab(r)
        s.=absSchwelle . " absSchwelle in" in " n" n " r" r " "
        in:=r

        return r
    }

    addKey(k , c) {
        this.keys2.push(k)
        this.keycount += c
    }

    tracking(startinfo, nowMPos, dx, dy,trackdata) {
        global myLButtonDown
        if(myLButtonDown){
            return false
        }

        if (!this.ok) {
            return false
        }

        global myLButtonDown
        sch:=5
        this.schwelle(dx, sch)
        ;dy:=0
        this.schwelle(dy, sch)
        ;        ttc(dx, dy)
        lock:=myLButtonDown

        d:=abs(dx)-abs(dy)
        absd:=abs(d)
        l2:=absd> max(abs(dx),abs(dy)) / 2
        ;        tt(l2 . "l2")
        lock:=l2
        if (lock) {
            lowerabsToZero( dx, dy)
        }

        win:=new WinRect()
        if (this.lastrect) {
            ;            tt("lastrect" . tos(this.lastrect))
            if (!(this.lastrect.equal(win.rect))) {
                return false
            }
        } else {
            this.lastrect:=win.rect
        }
        if (win.id!=startinfo.wstartpos.id) {
            return false
        }
        nt:=A_TickCount
        if (!this.lastTick) {
            this.lastTick:=nt
            if (!panmode()) {
                return true
            } else {
                ;                no need
            }
        }
        ticks :=nt-this.lastTick
        this.lastTick:=nt

        if (panmode()) {
            s:=""
            s .= dx . " xx " . dy . "`n"
            ;            MouseGetPos,,,id
            id:=startinfo.wstartpos.id

            MAXPIXEL:=150
            MaxTabsPerSec:=100

            txps:=MaxTabsPerSec / MAXPIXEL*dx
            typs:=MaxTabsPerSec / MAXPIXEL*dy

            ;fenstersec := .5
            fenstersec := 1
            ;~ fenstersec := 2 - (sqrt(abs(dx*dy))/MAXPIXEL * 2)
            ;            ~ if (fenstersec<1) {
            ;~ fenstersec:=1
            ;                ~}

            s .= "fenstersec:" . fenstersec . "`n"

            MINDELAY:=fenstersec * 1000 / MaxTabsPerSec
            tx:=txps * fenstersec
            ty:=typs * fenstersec

            s .= tx . " x " . ty . " in`n"

            tx:= this.getFullTab(tx)
            ty:=this.getFullTab(ty)

            s .= tx . " x " . ty . " getFullTab`n"

            mint:=min(abs(tx),abs(ty))

            this.keycount:=0
            this.keys :="{Blind}"
            this.keys2 := Object()

            mint := this.getFullTab(mint)
            if (mint>0) {
                if (tx>0&&ty>0)
                    this.addKey(7,mint)
                else if (tx<0&&ty>0)
                    this.addKey(9,mint)
                else if (tx<0&&ty<0)
                    this.addKey(3,mint)
                else if (tx>0&&ty<0)
                    this.addKey(1,mint)
            }

            ;            done diag
            tx := tx - mint*this.getSign(tx)
            ty := ty - mint*this.getSign(ty)

            atx:=abs(tx)
            if (atx>=1) {
                if (tx>0)
                    this.addKey(4,atx)
                else
                    this.addKey(6,atx)
            }

            aty:=abs(ty)
            if (aty>=1) {
                if (ty>0)
                    this.addKey(8,aty)
                else
                    this.addKey(2,aty)
            }

            MAXDELAY:=1000
            MINDELAY:=100 ;            testov
            s .= "keycount:" . this.keycount . "`n"
            if (this.keycount>0) {
                delay:=fenstersec * 1000 / this.keycount
                if (delay<MINDELAY) {
                    delay:=MINDELAY
                }if (delay>MAXDELAY) {
                    delay:=MAXDELAY
                }

                s .= "delay:" . delay . "`n"
                s .= "MINDELAY:" . MINDELAY . "`n"

                ;                tt(s)
                if (trackData.CheckBreak()) {
                    return false
                } else {
                    ;delay:=0
                    this.flush(id,delay)
                }
                ;                sleep, fenstersec * 1000

                ;                TT("SEND")
            }
            ;            tt(s,0,0)
        } else {
            fact:= this.pixelPerSecondWithOneDX/1000*ticks
            x:=Round(win.rect.x-(fact*dx))
            y:=Round(win.rect.y-(fact*dy))
            this.lastrect:=rect.fromChoord(x,y,win.rect.w,win.rect.h)
            WinMove, % "ahk_id " win.id,,x , y
        }

        if (this.breakExt) {
            ;            tt("breakExt")

            return false
        } else {
            return true
        }
    }

    flush(id,delay) {
        array:=this.keys2
        for i, e in Array ;    Recommended approach in most cases.
        {

            if (e==1) {
                mpcsend_PnS_Down_Left(id)
            } else if (e==2) {
                mpcsend_PnS_Down(id)
            } else if (e==3) {
                mpcsend_PnS_Down_Right(id)
            } else if (e==4) {
                mpcsend_PnS_Left(id)
            } else if (e==6) {
                mpcsend_PnS_Right(id)
            } else if (e==7) {
                mpcsend_PnS_Up_Left(id)
            } else if (e==8) {
                mpcsend_PnS_Up(id)
            } else if (e==9) {
                mpcsend_PnS_Up_Right(id)
            }
            sleep delay
        }
    }

    flushOld(id,delay) {
        SetKeyDelay ,delay
        kys:=this.keys
        ;        assureActive(id)

        aid := getActiveWin()

        if (id==aid) {
            SendEvent ,%kys%
        } else {
            ControlSend, , %kys%, ahk_id %id%
        }
    }
    stopTrack(startinfo, nowMPos, dx, dy) {
        ;        tt("stopTrack")
        id:=startinfo.wstartpos.id
        ;        Sleep 2000
        aid := getActiveWin()
        if (id==aid) {
            ;            SendInput, {LAlt up}
        } else {
            ;            ControlSend, , {LAlt up}, ahk_id %id%
        }

        ;        ~ if (this.restoreSidActive) {
        ;~ sid:=startinfo.wstartpos.id
        ;            ~ winActivate, ahk_id %sid%
        ;            ~ Sleep 800
        ;            ~ }
    }
    getSleepTime() {
        return 1
    }
}

