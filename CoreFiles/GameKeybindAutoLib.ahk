; GameKeybindAutoLib - Autohotkeys Library to Control Input Behaviour for Gameplay 
; 1. Not every function works on some games, sometimes the alternate version works. 
; 2. Functions and Variables with preceding underscore are for internal use.
; 3. Read and modify an example first before testing functions directly from this file.
; 4. Don't use on multiplayer/competitive games, ahk scripts can be considered cheat.

#Requires AutoHotkey v2.0
#include GuiAutoLib.ahk 

/* Inventory [ GameKeybindAutoLib ] { AHK V2 } 

-- Basic Autohotkey Syntax
1. q::w ; autohotkey syntax to rebind q for w 
2. q::Function() ; autohotkey syntax to bind Function function with a key press q 

-- Script Toggle
1. isGameActive(namePart) - return true if the window with process name has namePart as substring is active
2. isScriptActive() - use with a keybind to ToggleScript to toggle the script functionality
3. ToggleScript() - assign a key as a bind to this function to toggle the value returned from isScriptActive

-- Autowalk
1. Autowalk(keybind) - Simple autopress. The triggering key (the key assigned on script) must be different from the keybind key (the key assigned on game menu) to work. 
2. KeypressAutowalk(keypressed, keybind, ms_threshould) - Autowalk detected if you press the key long enough. The triggering key (the key assigned on script) must be different from the keybind key (the key assigned on game menu) to work. 

-- Key/Action Cycle
1. KeyStateToggle(bind_key) - Toggle between key up and key down states 
2. ToggleKeys(key, cycled_keys*) - Toggle between binds with same key ex. e::ToggleKeys("e",1,2,3,4,5,6)
3. GetCurrentKey_ToggleKeys(key, fallback_key) - Try to Get the current key from ToggleKeys 
4. ActSetCurrentKey_ToggleKeys(key, index, fallback_key) - Sets and Send the key event for the key with corresponding index 
5. ToggleActions(name, action_1, action_2) - Functional Version of ToggleKeys 
6. ToggleKeySet, KeySetFilter ; Create a keyset toggle to create toggleable modes for keybinds

-- Quick and Long Press 
1. LongPress(keybind, normal_press_key, long_press_key) - Assign two keybinds in one, short tap will send one key, a long press will send another.
2. LAlt_LongPress() - Assign LAlt for short and Alt gr for long press
3. LongPress_SendInput - Same as LongPress but using SendInput instead of Send. Some games don't recognize Send as keydown event. 
4. LongPress_Action - Functional version of LongPress with normal_action and longpress_action both functions.

; -- Graphical User Interface 
1. CardinalMenu(keybind, actions, names) - Radial Menu on Cardinal Directions 
2. Message(text) - Display Message 

-- 
1. SendAlt(key) - Some games don't understand the Send(key) command, this command send key down and after  delay sends a key up 
2. DoubleTap() - Send double tap event, useful to emulate double click.
3. DoubleTapAlt(key, delay) - Alternate version with delay in milliseconds.

*/

; -- Script Toggle
_is_main_hotkeys_active := true ; used on isScriptActive 
isGameActive(namePart) {
	; 1. Use the namePart as the process or a substring
	; 2. To be used on #HotIf statement to apply the keybinds only on the target window 
	; 3. Statement Suggestion: #HotIf ( isScriptActive() && isGameActive(GAMENAME) )
    hwnd := WinActive("A")
    if !hwnd 
        return false 

    proc := WinGetProcessName(hwnd) 
    return InStr(proc, namePart, true) 
} 
isScriptActive() {
	global _is_main_hotkeys_active 
	return _is_main_hotkeys_active 
}
ToggleScript() {
	global _is_main_hotkeys_active 
	_is_main_hotkeys_active := !_is_main_hotkeys_active 
	if ( _is_main_hotkeys_active ) {
		DisplayMessage("Script Active")
	} else {
		DisplayMessage("Script Inactive")
	}
}

; -- Autowalk 
Autowalk(key) {
	; 1. Example to configure q as a autopress for w key q::Autowalk("w") 
	SendInput "{" key " down}"
}
KeypressAutowalk(keypressed, keybind, ms_threshould := 3000) {
	Send("{" keybind " down}")
	start := A_TickCount 
	while ( GetKeyState(keypressed,"P") ) {
		Sleep(1)
	}
	if (A_TickCount - start < ms_threshould) {
		Send("{" keybind " up}")
	} 
}
KeypressAutowalk_VI(keypressed, keybind, ms_threshould := 3000) {
	Send("{" keybind " down}")
	start := A_TickCount 
	dt := 0
	b_displayed := false 
	while ( GetKeyState(keypressed,"P") ) {
		Sleep(1)
		dt := A_TickCount - start
		if (dt >= ms_threshould && !b_displayed) {
			DisplayImageMessage("autowalk.png", 2000)
			b_displayed := true 
		}
	}
	if (dt < ms_threshould) {
		Send("{" keybind " up}")
	} 
}

; -- Key/Action Cycle
_KeyStateToggleMap := Map()
KeyStateToggle(bind_key) {
	; 1. Example to set run toggle with shift. To this example works p must be the bind assigned to run in the game options, because the key up event will be send whenever shift is pressed, interfering with the logic.
	; 
	; LShift::KeyStateToggle("p") 
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
ToggleKeys_VI(key, cycled_keys*) {
	ToggleKeys(key, cycled_keys*)
	DisplayImageMessage("exchange.png", 500)
}

_ToggleActions := Map()
ToggleActions(name, action_1, action_2) {
	global _ToggleActions
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
ToggleActions_VI(name, action_1, action_2) {
	ToggleActions(name, action_1, action_2)
	DisplayImageMessage("exchange.png", 500)
}

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

; -- Quick and Long Press 
LongPress(keybind, normal_key, longpress, ms_longpresstime := 500) {
	; 1. Example to assign distant keys for long press q::LongPress("q", "q", "y") 
	start := A_TickCount 
    KeyWait keybind ; wait until released
    elapsed := A_TickCount - start
    if (elapsed >= ms_longpresstime) {
        Send("{" longpress "}") ; long press action
    } else {
        Send("{" normal_key "}") ; normal tap
    }
}
LAlt_LongPress() {
	LongPress("LAlt", "LAlt", "RAlt")
}
LongPress_SendInput(key, normal_key, longpress, ms_longpresstime := 500) {
	start := A_TickCount 
    KeyWait key ; wait until released
    elapsed := A_TickCount - start
    if (elapsed >= ms_longpresstime) {
        SendInput "{" longpress "}" ; long press action
    } else {
        SendInput "{" normal_key "}" ; normal tap
    }
}
LongPress_Action(key, normal_action, longpress_action, ms_longpresstime := 500) {
	start := A_TickCount 
    KeyWait key ; wait until released
    elapsed := A_TickCount - start
    if (elapsed >= ms_longpresstime) {
        longpress_action() 
    } else {
        normal_action()
    }
}

; -- Graphical User Interface 
CardinalMenu := RadialMenu4d 
Message := DisplayMessage 
CenterGameWindow := CenterActiveWindow 
Borderless := ToggleWindowedBorderless

; -- 
SendAlt(key, delay) {
	Send("{" key " down}")
	Sleep(delay)
	Send("{" key " up}")
}
DoubleTap(key) {
	; 1. Example to emulate double click with tab Tab::DoubleTap("LButton")
	Send("{" key "}")
	Sleep 100 
	Send("{" key "}")
}
DoubleTapAlt(key, delay) {
	Send("{" key "}")
	Sleep delay 
	Send("{" key "}")
}
ScrollDown() {
	Send("{WheelDown}")
}
ScrollUp() {
	Send("{WheelUp}")
}
CancelKeys(args_cancel_keys*) {
	for k,v in args_cancel_keys {
		Send("{" v " up}")
	}
}

; ====================================== INTERNAL ==========================================

_EuclideanDist(x1, y1, x2, y2) {
    dx := x2 - x1
    dy := y2 - y1
    return Sqrt(dx*dx + dy*dy)
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

; }

























; -- END 








