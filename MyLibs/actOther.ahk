activateOther() {
    fid:=WinExist("Form1")
    ;tt(fid)
    if (!fid) {
        runwait, C:\ProgrammeUser\AHK_New\WindowsFormsApplication1.exe
    }
    fid:=WinExist("Form1")
    if (fid) {
        WinActivate, ahk_id %fid%
    } else {
        tt("could not run form1")
    }
}
