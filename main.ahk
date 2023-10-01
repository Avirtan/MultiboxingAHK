#Requires AutoHotKey v2.0
#Include %A_ScriptDir%\lib\Json.ahk
#Include %A_ScriptDir%\src\Multiboxing.ahk

pathConfigJson := A_WorkingDir "\config.json"

data := FileRead(pathConfigJson)
jsonData := Jxon_load(&data)
mb := Multibox(2, jsonData, true)
mb.Run()
; mb.CopySettingsAccounts()

+Esc:: mb.Close()

;  #HotIf WinActive("World of Warcraft")
1:: mb.SendKey(1)
2:: mb.SendKey(2)
3:: mb.SendKey(3)
4:: mb.SendKey(4)
5:: mb.SendKey(5)

+1:: mb.SendKey("{Shift down}1{Shift up}")
+2:: mb.SendKey("{Shift down}2{Shift up}")
+3:: mb.SendKey("{Shift down}3{Shift up}")
+4:: mb.SendKey("{Shift down}4{Shift up}")
+5:: mb.SendKey("{Shift down}5{Shift up}")

^1:: mb.SendKey("{Ctrl down}1{Ctrl up}")
^2:: mb.SendKey("{Ctrl down}2{Ctrl up}")
^3:: mb.SendKey("{Ctrl down}3{Ctrl up}")
^4:: mb.SendKey("{Ctrl down}4{Ctrl up}")
^5:: mb.SendKey("{Ctrl down}5{Ctrl up}")

!1:: mb.SendKey("{Alt down}1{Alt up}")
!2:: mb.SendKey("{Alt down}2{Alt up}")
!3:: mb.SendKey("{Alt down}3{Alt up}")
!4:: mb.SendKey("{Alt down}4{Alt up}")
!5:: mb.SendKey("{Alt down}5{Alt up}")

#1:: mb.ShowWindow(1)
#2:: mb.ShowWindow(2)
#3:: mb.ShowWindow(3)
#4:: mb.ShowWindow(4)
#5:: mb.ShowWindow(5)
^#1:: mb.ShowMainWindow(1)
^#2:: mb.ShowNotMainWindow()


; o:: mb.SendKey("o")
z:: mb.SendKey("z")
x:: mb.SendKey("x")
c:: mb.SendKey("c")
; v:: mb.SendKey("v")
q:: mb.SendKey("q")
e:: mb.SendKey("e")
r:: mb.SendKey("r")
t:: mb.SendKey("t")
y:: mb.SendKey("y")
f:: mb.SendKey("f")
+space:: mb.SendKey("{Space}")

; +o:: mb.SendKey("{Shift down}o{Shift up}")
+z:: mb.SendKey("{Shift down}z{Shift up}")
+x:: mb.SendKey("{Shift down}x{Shift up}")
+c:: mb.SendKey("{Shift down}c{Shift up}")

+q:: mb.SendKey("{Shift down}q{Shift up}")
+e:: mb.SendKey("{Shift down}e{Shift up}")
+r:: mb.SendKey("{Shift down}r{Shift up}")
+t:: mb.SendKey("{Shift down}t{Shift up}")
+f:: mb.SendKey("{Shift down}f{Shift up}")
+y:: mb.SendKey("{Shift down}y{Shift down}")

; ^o:: mb.SendKey("{Ctrl down}o{Ctrl up}")
^z:: mb.SendKey("{Ctrl down}z{Ctrl up}")
^x:: mb.SendKey("{Ctrl down}x{Ctrl up}")
^c:: mb.SendKey("{Ctrl down}c{Ctrl up}")
^y:: mb.SendKey("{Ctrl down}y{Ctrl down}")
; ^v:: mb.SendKey("{Ctrl down}v{Ctrl up}")
^q:: mb.SendKey("{Ctrl down}q{Ctrl up}")
^e:: mb.SendKey("{Ctrl down}e{Ctrl up}")
^r:: mb.SendKey("{Ctrl down}r{Ctrl up}")

F1:: mb.SendKey("{F1}")
F2:: mb.SendKey("{F2}")
F3:: mb.SendKey("{F3}")
F4:: mb.SendKey("{F4}")

^Enter:: mb.SendKey("{Enter}")

+]:: mb.SetWindowPosition()

; +p:: mb.CopySettingsAccounts()


+Enter:: mb.Login()