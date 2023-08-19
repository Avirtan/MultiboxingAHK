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
            Run(this.pathToGame, , , &tmpPid)
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
                    WinSetTitle(this.jsonData["users"][A_Index]["role"], "ahk_pid " pid)
                }
                WinMove(posX, posY, height, width, "ahk_pid " pid)
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
        for pid in this.pidWindows {
            if ProcessExist(pid)
            {
                ControlSend(key, , "ahk_pid " pid)
            }
        }
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

    Close() {
        for pid in this.pidWindows {
            ProcessClose(pid)
        }
        ExitApp
    }
}