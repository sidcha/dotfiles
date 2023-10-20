; This is an AutoHotkey script to remap some keys on windows
; so it plays nice with my Mac motor memories.
;
; https://github.com/AutoHotkey/AutoHotkey
; https://www.autohotkey.com/download/

; Left Cmd key (which is Windows key by default) should be remapped to
; control with sharp keys. With that remapped, use Ctrl+Tab to do what
; Alt+Tab usually does -- switch between windows.
LCtrl & Tab:: AltTab

; Option key is already ALT key. So let's Alt + Tab to
; switch between tabs of a window.
!Tab:: Send ^{Tab}
!+Tab:: Send ^+{Tab}

; mock the Cmd+Space spotlight search
^Space:: Send ^{Esc}

; Alt + ` to cycle between windows of the same process
!`::
WinGetClass, OldClass, A
WinGet, ActiveProcessName, ProcessName, A
WinGet, WinClassCount, Count, ahk_exe %ActiveProcessName%
IF WinClassCount = 1
	Return
loop, 2 {
	WinSet, Bottom,, A
	WinActivate, ahk_exe %ActiveProcessName%
	WinGetClass, NewClass, A
	if (OldClass <> "CabinetWClass" or NewClass = "CabinetWClass")
		break
}
