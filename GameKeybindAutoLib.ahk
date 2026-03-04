#Requires AutoHotkey v2.0

; Autohotkeys Library to Control Input Behaviour for Gameplay 
; 1. Not every function works on some games, sometimes the alternate version works 
; 2. Functions and Variables with preceding underscore are for internal use 
; 3. Read and modify an example first before testing functions directly from this file 

_longPressTime := 500  ; milliseconds 
_is_main_hotkeys_active := true 

; Examples - Vanilla AHK
; Rebind q for w 
;
; q::w
;
; Control mouse wheel with z and x 
;
; z::Send("{WheelUp}")
; x::Send("{WheelDown}")

; isGameActive(namePart) - return true if the game window is active
; 1. Use the name of the process or a substring
; 2. To be used on #HotIf statement to apply the keybinds only on the target window 

isGameActive(namePart) {
    hwnd := WinActive("A")
    if !hwnd 
        return false 

    proc := WinGetProcessName(hwnd) 
    return InStr(proc, namePart, true) 
} 

; isScriptActive - similar to isGameActive, but using a global variable and a toggle function which can be assigned to a key 

isScriptActive() {
	global _is_main_hotkeys_active 
	return _is_main_hotkeys_active 
}

; ToggleScript - toggle the variable returned by isScriptActive 

ToggleScript() {
	global _is_main_hotkeys_active 
	_is_main_hotkeys_active := !_is_main_hotkeys_active 
	if ( _is_main_hotkeys_active ) {
		DisplayMessage("Script Active")
	} else {
		DisplayMessage("Script Inactive")
	}
}

; Autowalk - Simple autopress, the triggering key must be different from the autopressing key. 
; Example to configure q as a autopress w: 
;
; q::Autowalk("w") 

_autowalk_key := ""
Autowalk(key) {
	_autowalk_key := key
	SendInput "{" key " down}"
}

; DoubleTap - Send double tap event, useful to emulate double click.
; Example to emulate double click with tab  

; Tab::DoubleTap("LButton")

DoubleTap(key) {
	Send("{" key "}")
	Sleep 100 
	Send("{" key "}")
}

DoubleTapAlt(key, delay) {
	Send("{" key "}")
	Sleep delay 
	Send("{" key "}")
}

; SendAlt - Some games don't understand the Send(key) command, this command send key down and after a delay sends a key up 

SendAlt(key, delay) {
	Send("{" key " down}")
	Sleep(delay)
	Send("{" key " up}")
}

; KeyStateToggle - Toggle between key up and key down states 
; Example to set run toggle with shift. To this example works p must be the bind assigned to run in the game options, because the key up event will be send whenever shift is pressed, interfering with the logic.
; 
; LShift::KeyStateToggle("p") 

_KeyStateToggleMap := Map()
KeyStateToggle(bind_key) {
	if ( !_KeyStateToggleMap.Has(bind_key) ) {
		_KeyStateToggleMap[bind_key] := false
	}
	if ( _KeyStateToggleMap[bind_key] ) {
		Send("{" bind_key " up}")
	} else {
		Send("{" bind_key " down}")
	}
	_KeyStateToggleMap[bind_key] := !_KeyStateToggleMap[bind_key] 
}

; ToggleKeys - Toggle between binds with same key 
; Example Cycling between 3,4,5, the first entry is to store the current index

; PrimaryWeaps := [1,"3","4","5"]
; g::ToggleKeys(PrimaryWeaps)

_ToggleKeysMap := Map()
GetCurrentKey_ToggleKeys(key, fallback_key) {
	global _ToggleKeysMap
	if ( !_ToggleKeysMap.Has(key) ) {
		return fallback_key
	}
	arr := _ToggleKeysMap[key]
	if ( arr.Length <= 1 ) {
		return fallback_key
	}
	return arr[ arr[1]+1 ]
}
ActSetCurrentKey_ToggleKeys(key, index, fallback_key) {
	global _ToggleKeysMap
	if ( !_ToggleKeysMap.Has(key) ) {
		Send("{" fallback_key "}")
		return 
	}
	arr := _ToggleKeysMap[key] 
	arr[1] := index 
	Send("{" arr[ index+1 ] "}")
}
ToggleKeys(key, cycled_keys*) {
	global _ToggleKeysMap
	if ( !_ToggleKeysMap.Has(key) ) {  
		_ToggleKeysMap[key] := [1]
		arr := _ToggleKeysMap[key]
		for (index, value in cycled_keys) {
			arr.Push(value)
		}
	}
	arr := _ToggleKeysMap[key]
	if ( arr[1]+1 = arr.Length ) {
		arr[1] := 1
	} else {
		arr[1] := arr[1] + 1
	}
	Send("{" arr[ arr[1]+1 ] "}")
}

; ToggleKeysByGetters - Functional Version of ToggleKeys 

ToggleKeysByGetters(state_getter,key1_getter,key2_getter) {
	if (state_getter() = 1) {
		Send( "{" key1_getter() "}" )
	} else {
		Send( "{" key2_getter() "}" )
	}
}

_ToggleActions := Map()
ToggleActions(name, action_1, action_2) {
	if (! (_ToggleActions.Has(name)) ) {
		_ToggleActions[name] := true 
	}
	if ( _ToggleActions[name] ) {
		action_1()
	} else {
		action_2()
	}
	_ToggleActions[name] := !_ToggleActions[name]
}

; AssignLongPress - Assign two keybinds in one, short tap will send one key, a long press will send another.

; Example to assign distant keys for long press 
; q::AssignLongPress("q", "q", "y") 

AssignLongPress(key, normal_key, longpress) {
	start := A_TickCount 
    KeyWait key ; wait until released
    elapsed := A_TickCount - start
    if (elapsed >= _longPressTime) {
        Send("{" longpress "}") ; long press action
    } else {
        Send("{" normal_key "}") ; normal tap
    }
}

; LAlt_LongPress - Assign LAlt for short and Alt gr for long press

LAlt_LongPress() {
	AssignLongPress("LAlt", "LAlt", "RAlt")
}

; AssignLongPress_SendInput - Same as AssignLongPress but using SendInput instead of Send. Some games don't recognize Send as keydown event. 

AssignLongPress_SendInput(key, normal_key, longpress) {
	start := A_TickCount 
    KeyWait key ; wait until released
    elapsed := A_TickCount - start
    if (elapsed >= _longPressTime) {
        SendInput "{" longpress "}" ; long press action
    } else {
        SendInput "{" normal_key "}" ; normal tap
    }
}

; AssignLongPress_Action - Functional version of AssignLongPress with normal_action and longpress_action both functions.

AssignLongPress_Action(key, normal_action, longpress_action) {
	start := A_TickCount 
    KeyWait key ; wait until released
    elapsed := A_TickCount - start
    if (elapsed >= _longPressTime) {
        longpress_action() 
    } else {
        normal_action()
    }
}

; ToggleKeySet, KeySetFilter ; Create a keyset toggle to create toggleable modes for keybinds
_CurrentKeySet := 0
ToggleKeySet(keyset_1, keyset_2) {
	global _CurrentKeySet
	if (_CurrentKeySet != keyset_1) {
		_CurrentKeySet := keyset_1
	} else {
		_CurrentKeySet := keyset_2
	}
	DisplayMessage(_CurrentKeySet " active", 1)
}
KeySetFilter(keyset_1, action_1, args_1, keyset_2, action_2, args_2) {
	global _CurrentKeySet
	if ( _CurrentKeySet = keyset_1 ) {
		action_1(args_1*)
	} else if ( _CurrentKeySet = keyset_2 ) {
		action_2(args_2*)
	}
}

; StickPress ; Keep Pressing "keydown" when a key is pressed for enough time
; _StickPressStates := Map()
; _StickPressAction(state) {
	; if (state.counter<state.millisecs) {
		; ToolTip("Short Pressed")
		; Send(state.keydummy)
	; } else {
		; ToolTip("Long Pressed")
		; Send("{" state.keydummy " down}")
	; }
; }
; StickPress(keybind, keydummy, millisecs) {
	; if (!_StickPressStates.Has(keybind)) {
		; _StickPressStates[keybind] := { 
			; keydummy : keydummy,
			; ms_tick : 1,
			; millisecs : millisecs
		; }
	; }
	; _ForKeypressTicks(keybind, _StickPressAction, _StickPressStates[keybind])
; }
; z::StickPress("z","w",10)

;
_GetKeypressedKeys := []
StoreKeypressed(excluded := []) {
    global _GetKeypressedKeys, _autowalk_key
    static keys := [
		"LShift","RShift",
		"LCtrl","RCtrl",
		"LAlt","RAlt",
        "LWin", "RWin",
        "Up", "Down", "Left", "Right",
        "Space", "Enter", "Tab",
        "a","b","c","d","e","f","g","h","i","j",
        "k","l","m","n","o","p","q","r","s","t",
        "u","v","w","x","y","z", _autowalk_key
    ]
    _GetKeypressedKeys := []
    for key in keys {
		if (key = "") {
			continue 
		}
        if GetKeyState(key) {
			b_is_on_excluded_list := false 
			for i,v in excluded {
				if (key == v) {
					b_is_on_excluded_list := true 
					break 
				}
			}
			if ( b_is_on_excluded_list ) {
				continue
			}
            _GetKeypressedKeys.Push(key)
            Send("{" key " up}")   ; release immediately
        }
    }
}
RestoreKeypressed() {
	if (!isScriptActive()) {
		return 
	}
    global _GetKeypressedKeys, _autowalk_key
    for key in _GetKeypressedKeys {
		if (key = "") {
			continue 
		}
        if ( GetKeyState(key, "P") || key=_autowalk_key ) {
            Send("{" key " down}")
        }
    }
    _GetKeypressedKeys := []
}

; -- Mouse Keybinds 

ScrollDown() {
	Send("{WheelDown}")
}

ScrollUp() {
	Send("{WheelUp}")
}

; -- Graphical User Interface 
; works only with windowed or borderless gameplay 

CoordMode("Mouse", "Screen")
CoordMode("ToolTip", "Screen")
global radialGui := 0
global radialCenterX := 0
global radialCenterY := 0
global radialSelection := ""
global DEADZONE := 60
global accDX := 0
global accDY := 0
global is_radial_active := false 

_UpdateRadial(names) {
    global radialCenterX, radialCenterY, accDX, accDY
    global DEADZONE, radialGui, radialSelection
    MouseGetPos(&mx, &my)
    dxTick := mx - radialCenterX
    dyTick := my - radialCenterY
    accDX += dxTick
    accDY += dyTick
    ; Clamp accumulation
    accDX := Max(Min(accDX, 200), -200)
    accDY := Max(Min(accDY, 200), -200)
    ; Reset mouse back to center
    MouseMove(radialCenterX, radialCenterY, 0)
    dx := accDX
    dy := accDY
    distance := Sqrt(dx*dx + dy*dy)
    if (distance < DEADZONE) {
        radialSelection := ""
        radialGui["DisplayText"].Text := ""
        return
    }
    if (Abs(dx) > Abs(dy)) {
        radialSelection := dx > 0 ? "Right" : "Left"
    } else {
        radialSelection := dy > 0 ? "Down" : "Up"
    }
	if (names.Has(radialSelection)) {
		radialGui["DisplayText"].Text := names[radialSelection]	
	} else {
		radialGui["DisplayText"].Text := radialSelection
	}
}
RadialMenu4d(key, actions, names, default_action := 0 ) {
	global radialGui, radialCenterX, radialCenterY, radialSelection, accDX, accDY, is_radial_active 
	if (is_radial_active) {
		return 
	}
	is_radial_active := true 
	targetHwnd := WinExist("A")
	radialSelection := ""
	accDX := 0
	accDY := 0
	WinGetPos(&wx, &wy, &ww, &wh, "A")
	radialCenterX := wx + ww // 2
	radialCenterY := wy + wh // 2	
	radialGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x80000")
	radialGui.BackColor := "010101"
	WinSetTransColor("010101", radialGui)
	pic := radialGui.Add("Picture", "+0xE", "cardinal.png")
	_CenterToSize(pic, ww, wh)
    radialGui.SetFont("s16 c00ff99", "Consolas")
	text := radialGui.AddText("BackgroundTrans +Center w" ww " vDisplayText","")
	_CenterToSize(text, ww, wh)
	StoreKeypressed([key])
    radialGui.Show(
        "x" wx
        " y" wy
        " w" ww 
		" h" wh 
    )
	f_up := (*)=>_UpdateRadial(names)
    SetTimer(f_up, 5)
	; -- 
	KeyWait(key)
	; -- 
    SetTimer(f_up, 0)
	
	Sleep(10)
	
    if radialGui
        radialGui.Destroy()
		
	Sleep(10)
		
	if (targetHwnd)
		WinActivate(targetHwnd)	
	
	if (radialSelection != "") {
		if ( actions.Has(radialSelection) ) {
			f_act := actions[radialSelection]
			f_act() 
		}
	} else if ( default_action != 0) {
		default_action()
	}
	RestoreKeypressed()
    radialGui := 0
    radialSelection := ""
	accDX := 0
	accDY := 0
	is_radial_active := false 
}

DisplayMessage(text, seconds := 2) {
    static msgGui := 0
    static fadeTimer := 0
    static currentAlpha := 0

    ; Destroy previous message if exists
    if msgGui {
        if (fadeTimer)
            SetTimer(fadeTimer, 0)
        msgGui.Destroy()
        msgGui := 0
    }

    ; Create GUI
    msgGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    msgGui.BackColor := "001a00"
	; msgGui.BackColor := "010101"
	; WinSetTransColor("010101", msgGui)
	
    msgGui.MarginX := 20
    msgGui.MarginY := 15
    msgGui.SetFont("s18 c00ff99", "Consolas")

    txt := msgGui.AddText("vMsgText", text)

    ; Show hidden first to calculate real size
    msgGui.Show("Hide AutoSize")

    ; Get text control size
    txt.GetPos(&tx, &ty, &tw, &th)

    ; Calculate final window size with margins
    finalW := tw + (msgGui.MarginX * 2)
    finalH := th + (msgGui.MarginY * 2)

    ; Center on active window
    WinGetPos(&wx, &wy, &ww, &wh, "A")
    x := wx + (ww // 2) - (finalW // 2)
    y := wy + (wh // 2) - (finalH // 2)

    msgGui.Show("NA x" x " y" y " w" finalW " h" finalH)

    currentAlpha := 175
    WinSetTransparent(currentAlpha, msgGui)

    ; Wait before fading
    SetTimer(StartFade, -seconds * 1000)

    StartFade() {
        fadeTimer := FadeStep
        SetTimer(fadeTimer, 30)
    }

    FadeStep() {
        currentAlpha -= 5
        if (currentAlpha <= 0) {
            SetTimer(fadeTimer, 0)
            msgGui.Destroy()
            msgGui := 0
            return
        }
        WinSetTransparent(currentAlpha, msgGui)
    }
}

; actions_T := Map(
	; "Up", (*)=>{},
	; "Down", (*)=>{},
	; "Left", (*)=>{},
	; "Right", (*)=>{}
; )
; names_T := Map(
	; "Up", "Testing Up",
	; "Down", "Testing Down",
	; "Left", "Testing Left",
	; "Right", "Testing Right"
; )
; CapsLock::RadialMenu4d("CapsLock", actions_T, names_T)

; ====================================== INTERNAL ==========================================

_EuclideanDist(x1, y1, x2, y2) {
    dx := x2 - x1
    dy := y2 - y1
    return Sqrt(dx*dx + dy*dy)
}

_CenterToSize(gui_component, parentW, parentH) {
    gui_component.GetPos(&x, &y, &w, &h)
    gui_component.Move((parentW - w)//2, (parentH - h)//2)
}

/* _ForKeypressTicks(...) - do action sequentially each tick count while key keep pressed as an iteration 

state.isRunning ~ bool, prevent keypress collision, only one keypress should act as an iteration 
state.counter ~ iteration counter 
state.ticks ~ tick counter 
state.

*/

_ForKeypressTicks(key, action, state) {
	if ( !HasProp(state, "isRunning") ) {
		state.isRunning := false 
	}
	if ( !HasProp(state, "counter") ) {
		state.counter := 0 
	}
	if ( !HasProp(state, "ticks") ) {
		state.ticks := 0
	}
	if ( !HasProp(state, "upperBound") ) {
		state.upperBound := 1000 
	}
	if ( !HasProp(state, "ms_stale") ) {
		if ( HasProp(state, "ms_tick") ) {
			state.ms_stale := 100*state.ms_tick  
		} else {
			state.ms_stale := 100 
		}
	}
	; -- 
	if (state.isRunning = true ) { 
		return 
	} 
	state.isRunning := true 
	if ( HasProp(state, "ms_stale") ) { 
		if ( state.ticks!=0 && A_TickCount - state.ticks > state.ms_stale ) {
			state.ticks := 0 
			state.isRunning := false 
			state.counter := 0 
			return 
		}
	}
	state.ticks := A_TickCount 
	if( state.counter>state.upperBound ) { 
		state.isRunning := false 
		state.counter := 0 
		KeyWait key
		return 
	}
	result := action(state)
	if ( result = true ) { ; end the tick loop 
		state.isRunning := false 
		state.counter := 0 
		KeyWait key
		return 
	} 
	if ( HasProp(state, "ms_tick") ) {
		Sleep( state.ms_tick )
	}
	state.counter := state.counter + 1
	state.isRunning := false 
}

; ====================================== EXPERIMENTAL ======================================

; }

























; -- END 








