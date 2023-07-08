#Requires AutoHotkey v2.0
#SingleInstance Force ;跳過對話框自動替換舊實例

;引用腳本
#Include %A_ScriptDir%\AutoHotkey_Library\Snipper.ahk
#Include %A_ScriptDir%\AutoHotkey_Library\MyLibrary.ahk
#Include %A_ScriptDir%\AutoHotKey_Library\ToolTipOptions.ahk

TraySetIcon "IconRun.png", , 1
TrayTip A_ScriptName, "啟動 AutoHotKey 腳本", "Iconi"

reloadDelaySecond := 1
MyClass.AddReloadHotkey(reloadDelaySecond)

;===============================================================

externalFunctionFolder := A_ScriptDir '\ExternalFunction'

;{ 快捷鍵區域
;{ Win + M ;開啟選單
#M::{
	;建立子選單
	Submenu1 := Menu()
	Submenu1.Add "Item A", MenuHandler
	Submenu1.Add "Item B", MenuHandler

	MyMenu := Menu()
	MyMenu.Add "Item &1", MenuHandler
	MyMenu.Add "I&tem 2", MenuHandler
	MyMenu.Add ;分隔線
	MyMenu.Add "My Submenu", Submenu1
	MyMenu.Add ;分隔線
	MyMenu.Add "Item 3", MenuHandler
	MyMenu.Add ;分隔線
	MyMenu.AddStandard() ;新增標準選單

	MenuHandler(Item, *) {
		MsgBox "You selected " Item
	}

	MyMenu.Show
}
;}
;{ Win + Q ;複製今天日期到剪貼簿
#Q::{
	A_Clipboard := MyClass().GetToday_yyyyMMdd()
	MyTooltip "已複製今天日期：" A_Clipboard
	;MyTooltip "test1", 1
	;MyTooltip "test2", 2
	;MyTooltip "test4", 4
}
;}
;{ Win + B ;呼叫外部檔案
#B::{
	try {
		;呼叫 .ps1 PowerShell
		;result := MyClass.RunCommand("powershell", externalFunctionFolder '\PowerShellFunction.ps1', '3 3')
		;result := MyClass.RunWaitOne('powershell', externalFunctionFolder '\PowerShellFunction.ps1', '2 3')
		;result := MyClass.RunResult("powershell", externalFunctionFolder "\PowerShellFunction.ps1", '4 4')

		;呼叫 .py Python
		;result := MyClass.RunCommand("python", externalFunctionFolder '\PythonFunction.py', '3 3 1')
		;result := MyClass.RunWaitOne('python',externalFunctionFolder '\PythonFunction.py', '2 3 3')
		result := MyClass.RunResult("python", externalFunctionFolder "\PythonFunction.py", "2 3 4")

		MsgBox result
	} catch as e {
		MyClass.ShowError(e)
	}
}
;}
;{ Win + Z ;執行指令練習
#Z::{
	timesTotal := 3
	timesRun := 0

	array := [
		["C:\Program Files", "%ProgramFiles%"],
		["C:\Program Files (x86)", "%ProgramFiles(x86)%"],
		["C:\Users\User\AppData", "appdata"],
		["C:\Users\User\AppData\Roaming", "%appdata%"],
		["cmd", "cmd"],
		["PowerShell", "powershell"],
		["PowerShell 7", "pwsh"],
		["事件檢視器", "eventvwr"],
		["剪取工具", "snippingtool"],
		["啟動時執行資料夾", "shell:startup"],
		["小畫家", "snippingtool"],
		["小畫家 3D", "ms-paint:"],
		["小算盤", "calc"],
		["工作排程器", "taskschd.msc"],
		["控制台", "control"],
		["服務", "services.msc"],
		["本機群組原則編輯器", "gpedit.msc"],
		["登錄編輯程式", "regedit"],
		["程式和功能", "appwiz.cpl"],
		["系統資訊", "msinfo32"],
		["螢幕小鍵盤", "osk"],
		["記事本", "notepad"],
		["遠端桌面", "mstsc"],
		["關於 Windows", "winver"],
	]

	;Goto 新測試
	NewTest:

	timesRun++
	if timesRun = timesTotal + 1 {
		MsgBox "測試結束"
		return
	}

	;隨機取一個題目
	number := Random(1, array.Length)
	answer := array[number][2]

	;Goto 重新測試
	Retry:

	exam :=	(
		"題目數：" array.Length "`n"
		"第 " timesRun " / " timesTotal "次測試，請輸入啟動下列服務的指令`n"
		array[number][1]
	)

	IB := InputBox(exam, "快捷鍵指令練習")

	if IB.Result = "Cancel" {
		return
	}

	if IB.value = answer {
		MsgBox "輸入 '" IB.value "' 正確。"
		goto NewTest
	}

	if MsgBox("輸入 '" IB.value "' 錯誤.", , "R/C") = "Retry" {
		goto Retry
	}

	MsgBox Format("啟動 {1} 的指令為 {2}", array[number][1], array[number][2])
	goto NewTest
}
;}

;}


