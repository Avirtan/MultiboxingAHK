#Requires AutoHotKey v2.0

class Multibox {
    PathFileDebug => A_WorkingDir "\debug.txt"

    __New(countWindow, jsonData, isDebug := false) {
        this.countWindow := jsonData["count_window"]
        this.pidWindows := Array()
        this.jsonData := jsonData
        this.isDebug := isDebug
        this.pathToGame := jsonData["pathToGame"]
        this.isLogin := false
    }

    Run() {
        loop this.countWindow {
            tmpPid := 0
            Sleep(500)
            Run(this.pathToGame, , "Min", &tmpPid)
            this.pidWindows.Push(tmpPid)
        }
        if (this.isDebug) {
            if FileExist(this.PathFileDebug) {
                FileDelete(this.PathFileDebug)
            }
            for pid in this.pidWindows {
                FileAppend("pid: " pid "`n", this.PathFileDebug)
            }
        }
    }

    SetWindowPosition() {
        for pid in this.pidWindows {
            if ProcessExist(pid)
            {
                posX := this.jsonData["window"][A_Index]["x"]
                posY := this.jsonData["window"][A_Index]["y"]
                isMain := this.jsonData["window"][A_Index]["main"]
                height := this.jsonData["window_height"]
                width := this.jsonData["window_width"]
                if (isMain) {
                    height := this.jsonData["main_window_height"]
                    width := this.jsonData["main_window_width"]
                } else {
                    ; WinSetTitle(this.jsonData["users"][A_Index]["role"], "ahk_pid " pid)
                }
                WinMove(posX, posY, , , "ahk_pid " pid)
            }
        }
    }

    Login() {
        if (this.isLogin)
            return
        for pid in this.pidWindows {
            if ProcessExist(pid)
            {
                user := this.jsonData["users"][A_Index]
                WinActivate("ahk_pid " pid)
                login := user["login"]
                password := user["password"]
                SendText(login)
                SendInput("{Tab}")
                SendText(password)
                SendInput("{Enter}")
            }
        }
        this.SetWindowPosition()
        this.isLogin := true
    }

    SendKey(key) {
        if (!this.CheckGameWindowIsActive()) {
            id := WinGetPID("A")
            ControlSend(key, , "ahk_pid " id)
            return
        }
        for pid in this.pidWindows {
            if ProcessExist(pid)
            {
                ControlSend(key, , "ahk_pid " pid)
            }
        }
    }

    SendMouseClick() {
        if (!this.CheckGameWindowIsActive()) {
            return
        }
        pidActive := WinGetPID("A")
        posX := 0
        posY := 0
        activeW := 0
        activeH := 0
        WinGetClientPos(, , &activeW, &activeH, "A")
        MouseGetPos(&posX, &posY)
        CoordMode("Mouse", "Client")
        for pid in this.pidWindows {
            if (pidActive == pid) {
                SetControlDelay(-1)
                ControlClick(Format("X{1} Y{2}", posX, posY), "ahk_pid " pid, , "Left", 1, "NA Pos")
                continue
            }
            if ProcessExist(pid)
            {
                w := 0
                h := 0
                coefW := 0
                coefH := 0
                tmpPosX := 0
                tmpPosY := 0
                WinGetClientPos(, , &w, &h, "ahk_pid " pid)
                if (activeH > h) {
                    coefH := activeH / h
                    tmpPosY := posY / coefH
                } else {
                    coefH := h / activeH
                    tmpPosY := posY * coefH
                }
                if (activeW > w) {
                    coefW := activeW / w
                    tmpPosX := posX / coefW
                } else {
                    coefW := w / activeW
                    tmpPosX := posX * coefW
                }
                ; WinActivate("ahk_pid " pid)
                SetControlDelay(-1)
                ; MsgBox(Format("X{1} Y{2}", tmpPosX, tmpPosY))
                ControlClick(Format("X{1} Y{2}", tmpPosX, tmpPosY), "ahk_pid" pid, , "Left", 1, "NA Pos")
                ;ControlClick(tmpPosX, tmpPosY, "ahk_pid" pid, , "Right", 1, "NA Pos")
            }
            ; WinActivate("ahk_pid " pidActive)
        }
    }

    CheckGameWindowIsActive() {
        id := WinGetPID("A")
        gameWindowIsActive := false
        for pid in this.pidWindows {
            if (pid == id) {
                gameWindowIsActive := true
                break
            }
        }
        return gameWindowIsActive
    }

    ShowWindow(id) {
        WinActivate("ahk_pid " this.pidWindows[id])
    }

    ShowNotMainWindow() {
        for pid in this.pidWindows {
            if (A_Index == 0) {
            }
            else
            {
                if ProcessExist(pid)
                {
                    WinActivate("ahk_pid " pid)
                }
            }
        }
    }

    ShowMainWindow(id) {
        WinActivate("ahk_pid " this.pidWindows[id])
    }

    CopySettingsAccounts() {
        accountName := StrUpper(this.jsonData["from_account_copy"])
        PathFromCopy := Format("{1}{2}\", this.jsonData["path_to_account"], accountName)
        Loop this.jsonData["count_window"] {
            user := this.jsonData["users"][A_Index]
            login := user["login"]
            if (StrUpper(login) == accountName) {
                continue
            }
            savedVariableCopy := Format("{1}{2}", PathFromCopy, "SavedVariables")
            PathToCopy := Format("{1}{2}\{3}", this.jsonData["path_to_account"], StrUpper(login), "SavedVariables")
            MsgBox(PathToCopy . " " . savedVariableCopy)
            DirCopy(savedVariableCopy, PathToCopy, true)
        }
        ; Loop Files PathFromCopy, "D" {
        ;     if (A_LoopFileName == accountName) {
        ;         MsgBox(A_LoopFileName)
        ;     }
        ; }
    }

    Close() {
        for pid in this.pidWindows {
            ProcessClose(pid)
        }
        ExitApp
    }
}