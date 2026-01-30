#Requires AutoHotkey v2.0
; Autohotkeys Library to Control Input Behaviour for Gameplay 
; Not every function works on some games 

; global variables 
longPressTime := 500  ; milliseconds

; Examples - Vanilla AHK
; Rebind q for w 
;
; q::w
;
; Control mouse wheel with z and x 
;
; z::Send("{WheelUp}")
; x::Send("{WheelDown}")

; Autowalk - Simple autopress, the triggering key must be different from the autopressing key. 
; Example to configure q as a autopress w: 
;
; q::Autowalk("w") 
Autowalk(key) {
	SendInput "{" key " down}"
}

; DoubleTap - Send double tap event, useful to emulate double click.
; Example to emulate double click with tab 
; 
; Tab::DoubleTap("LButton")
DoubleTap(key) {
	Send("{" key "}")
	Sleep 100 
	Send("{" key "}")
}

; KeyStateToggle - Toggle between key up and key down states 
; Example to set run toggle with shift. To this example works p must be the bind assigned to run in the game options, because the key up event will be send whenever shift is pressed, interfering with the logic.
; 
; RunToggle := [false, "p"] 
; LShift::KeyStateToggle(RunToggle)
KeyStateToggle(arr_key) {
	if (arr_key[1]) {
		Send("{" arr_key[2] " up}")
	} else {
		Send("{" arr_key[2] " down}")
	}
	arr_key[1] := !arr_key[1]
}

; ToggleKeys - Toggle between binds with same key 
; Example Cycling between 3,4,5, the first entry is to store the current index
;
; PrimaryWeaps := [1,"3","4","5"]
; g::ToggleKeys(PrimaryWeaps)
ToggleKeys(arr_cycle) {
	if (arr_cycle[1]+1 = arr_cycle.Length) {
		arr_cycle[1] := 1
	} else {
		arr_cycle[1] := arr_cycle[1] + 1
	}
	Send("{" arr_cycle[arr_cycle[1]+1] "}")
}

; ToggleKeysByGetters - Functional Version of ToggleKeys 
ToggleKeysByGetters(state_getter,key1_getter,key2_getter) {
	if (state_getter() = 1) {
		Send( "{" key1_getter() "}" )
	} else {
		Send( "{" key2_getter() "}" )
	}
}

; AssignLongPress - Assign two keybinds in one, short tap will send one key, a long press will send another.
; Example to assign distant keys for long press 
;
; q::AssignLongPress("q", "q", "y") 
AssignLongPress(key, normal, longpress) {
	start := A_TickCount 
    KeyWait key ; wait until released
    elapsed := A_TickCount - start
    if (elapsed >= longPressTime) {
        Send("{" longpress "}") ; long press action
    } else {
        Send("{" normal "}") ; normal tap
    }
}

; AssignLongPress_SendInput - Same as AssignLongPress but using SendInput instead of Send. Some games don't recognize Send as keydown event. 
AssignLongPress_SendInput(key, normal, longpress) {
	start := A_TickCount 
    KeyWait key ; wait until released
    elapsed := A_TickCount - start
    if (elapsed >= longPressTime) {
        SendInput "{" longpress "}" ; long press action
    } else {
        SendInput "{" normal "}" ; normal tap
    }
}

; AssignLongPress_Action - Functional version of AssignLongPress with normal_action and longpress_action both functions.
AssignLongPress_Action(key, normal_action, longpress_action) {
	start := A_TickCount 
    KeyWait key ; wait until released
    elapsed := A_TickCount - start
    if (elapsed >= longPressTime) {
        longpress_action() 
    } else {
        normal_action()
    }
}

; isGameActive(name_exe) - True if the game window is active
; To be used on #HotIf statement 
; isGameActive(name_exe) {
	; return WinActive("ahk_exe " name_exe) 
; }

isGameActive(namePart) {
    hwnd := WinActive("A")
    if !hwnd
        return false

    proc := WinGetProcessName(hwnd)
    return InStr(proc, namePart, true) ; case-insensitive
}

