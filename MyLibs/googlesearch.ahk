#Include base.ahk

googlesearch(){
    static staticsearchQuery:=""
    ;BlockInput, on
    prevClipboard = %clipboard%
    clipboard =
    Sleep, 50
    Send, ^c
    ;BlockInput, off
    ClipWait, 2
    if ErrorLevel = 0
    {
        lastsearchQuery:=staticsearchQuery
        searchQuery=%clipboard%
        staticsearchQuery:=searchQuery
        if isIdFromExe(getActiveWin(),"code.exe")
        {
            send, {LCtrl Down}{LShift Down}f{LShift Up}{LCtrl Up} ;, ahk_id %id%

        }else if isIdFromExe(getActiveWin(),"notepad++.exe")
        {
            send, {LCtrl Down}{LShift Down}f{LShift Up}{LCtrl Up} ;, ahk_id %id%
            lastChar:=substr(searchQuery,StrLen(searchQuery))
            ;if(lastChar=="("||lastChar==")") {
            funcMode:=lastsearchQuery==searchQuery||lastChar=="("
            if(funcMode){
                searchQuery:=RegExReplace(searchQuery,"\s*\(\)?$","")
                ;ttos("sameSearch")
                searchQuery.="\s*\(.*\{" ;�
            }

            SendRaw , %searchQuery%

            loop,3
                tabs.="{Tab}"
            send, %tabs%
            sendRaw,C:\ProgrammeUser\AHK
            loop,6
                tabs.="{Tab}"
            send, %tabs%
            send, i

            if(funcMode){
                send, {Down}
            }else{
                send, {Up}
            }
            send, {Enter}
        }else IfInString, searchQuery, :\
        {
            explorerpath:= "explorer /root," searchQuery
            Run, %explorerpath%
        } else IfInString, searchQuery, \\
        {
            explorerpath:= "explorer /root," searchQuery
            Run, %explorerpath%
        } else IfInString, searchQuery, http
        {
            explorerpath:= "explorer /root," searchQuery
            Run, %explorerpath%
        } else {
            StringReplace, searchQuery, searchQuery, `r`n, %A_Space%, All
            Loop
            {
                noExtraSpaces=1
                StringLeft, leftMost, searchQuery, 1
                IfInString, leftMost, %A_Space%
                {
                    StringTrimLeft, searchQuery, searchQuery, 1
                    noExtraSpaces=0
                }
                StringRight, rightMost, searchQuery, 1
                IfInString, rightMost, %A_Space%
                {
                    StringTrimRight, searchQuery, searchQuery, 1
                    noExtraSpaces=0
                }
                If (noExtraSpaces=1)
                    break
            }

            ;StringReplace, searchQuery, searchQuery, \, `%5C, All
            StringReplace, searchQuery, searchQuery, %A_Space%, +, All
            ;StringReplace, searchQuery, searchQuery, `%, `%25, All

            Search := "http://www.google.com/search?hl=de&q=" . searchQuery

            Run, %Search%
        }
    }
    clipboard = %prevClipboard%
    return
}
