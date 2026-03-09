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
2. KeypressAutowalk(keypressed, keybind, ms_threshould) - Autowalk detected if you press the key long enough. The triggering key must be different from the keybind key assigned in the game.
3. KeypressAutowalk_VI(keypressed, keybind, ms_threshould) - Same as KeypressAutowalk but display an image indicator when the autowalk activates.

-- Key/Action Cycle
1. KeyStateToggle(bind_key) - Toggle between key up and key down states.
2. ToggleKeys(key, cycled_keys*) - Toggle between binds with same key. Example: e::ToggleKeys("e",1,2,3,4,5,6)
3. ToggleKeys_VI(key, cycled_keys*) - Same as ToggleKeys but display a visual indicator.
4. GetCurrentKey_ToggleKeys(key, fallback_key) - Return the currently selected key from ToggleKeys.
5. ActSetCurrentKey_ToggleKeys(key, index, fallback_key) - Set the ToggleKeys index and send the corresponding key.
6. ToggleActions(name, action_1, action_2) - Functional version of ToggleKeys that alternates between two functions.
7. ToggleActions_VI(name, action_1, action_2) - Same as ToggleActions but display a visual indicator.
8. ToggleKeySet(keyset_1, keyset_2) - Toggle between two keybind sets (modes).
9. KeySetFilter(keyset_1, action_1, args_1, keyset_2, action_2, args_2) - Execute different actions depending on the active keyset.
10. TripleToggle(keybind, primary1, primary2, secondary) - Toggle between two primary keys with short press and toggle the first cycle with a secondary key with long press.

-- Quick and Long Press 
1. LongPress(keybind, normal_press_key, long_press_key) - Assign two keybinds in one. Short tap sends one key, long press sends another. The long press need a key up event (key release) to activate.
2. LAlt_LongPress() - Assign LAlt for short press and RAlt (AltGr) for long press.
3. LongPress_SendInput(key, normal_key, longpress, ms_longpresstime) - Same as LongPress but uses SendInput for better compatibility with some games.
4. LongPress_Action(key, normal_action, longpress_action) - Functional version of LongPress where both actions are functions.
5. AutoLongpress(keypressed, shortpress, longpress, ms_threshould) - Trigger different key events depending on how long a key is held. The long press will be automatically sent without the need for key release.
6. AutoLongpress_Action(keypressed, shortaction, longaction, ms_threshould) - Functional version of AutoLongpress using functions instead of keys.

-- Graphical User Interface 
1. CardinalMenu(keybind, actions, names) - Radial menu using the four cardinal directions.
2. Message(text) - Display a message on screen.
3. CenterGameWindow() - Center the active game window on the screen.
4. Borderless() - Toggle active window between normal and borderless windowed.

-- Utility Input Helpers
1. SendAlt(key, delay) - Send key down and after a delay send key up. Useful for games that ignore normal Send.
2. DoubleTap(key) - Send the same key twice quickly. Useful for double click or dash mechanics.
3. DoubleTapAlt(key, delay) - Double tap with configurable delay.
4. ScrollDown() - Send mouse wheel down event.
5. ScrollUp() - Send mouse wheel up event.
6. CancelKeys(args_cancel_keys*) - Force release multiple keys by sending key up events.

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
ActGetCurrentKey_ToggleKeys(key, fallback_key) {
	Send("{" GetCurrentKey_ToggleKeys(key, fallback_key) "}")
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

_ToggleActionsMap := Map()
RegisterToggleActions(name, actions*) {
	arr := []
	arr.Push(actions*)
	if ( arr.Length = 0 ) {
		return false 
	}
	_ToggleActionsMap[name] := { current : 0, actions : arr }
	return true 
}
ToggleActions(name, actions*) {
	global _ToggleActionsMap
	if ( !_ToggleActionsMap.Has(name) ) {
		if ( !RegisterToggleActions(name, actions*) ) {
			return 
		}
	}
	TAMN := _ToggleActionsMap[name]
	len := TAMN.actions.Length
	if ( len = 0 ) {
		return
	}
	if ( TAMN.current = len ) {
		TAMN.current := 1 
	} else {
		TAMN.current := TAMN.current + 1
	}
	action := TAMN.actions[ TAMN.current ]
	action()
}
CurrentToggleActions(name, actions*) {
	global _ToggleActionsMap
	if ( !_ToggleActionsMap.Has(name) ) {
		ToggleActions(name, actions*)
		return 
	}
	TAMN := _ToggleActionsMap[name]
	len := TAMN.actions.Length
	if ( len = 0 ) {
		return
	}
	if TAMN.current = 0
		TAMN.current := 1
	action := TAMN.actions[ TAMN.current ]
	action() 
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

_TripleToggleMap := Map() 
TripleToggle(keybind, primary1, primary2, secondary) {
	global _TripleToggleMap 
	if ( !_TripleToggleMap.Has(keybind) ) {
		_TripleToggleMap[keybind] := {
			last_key : "",
			last_toggle : 0,
			first_toggle : 0,
			second_toggle : 0
		}
		TTMK := _TripleToggleMap[keybind]
		first_toggle() {
			global _TripleToggleMap 
			if ( _TripleToggleMap[keybind].last_toggle = 2) {
				current := GetCurrentKey_ToggleKeys(keybind, primary1)
				if ( _TripleToggleMap[keybind].last_key = current ) { 
					ToggleKeys(keybind, primary1, primary2) 
				} else {
					Send("{" GetCurrentKey_ToggleKeys(keybind, primary1) "}")
				}
			} else {
				ToggleKeys(keybind, primary1, primary2) 
			}
			_TripleToggleMap[keybind].last_toggle := 1
			_TripleToggleMap[keybind].last_key := GetCurrentKey_ToggleKeys(keybind, primary1)
		}
		second_toggle() {
			global _TripleToggleMap 
			if ( _TripleToggleMap[keybind].last_toggle = 1) {
				Send("{" secondary "}")
				_TripleToggleMap[keybind].last_key := secondary
			} else {
				current := GetCurrentKey_ToggleKeys(keybind, primary1)
				if (current = _TripleToggleMap[keybind].last_key) {
					Send("{" secondary "}")
					_TripleToggleMap[keybind].last_key := secondary
				} else {
					Send("{" current "}")
					_TripleToggleMap[keybind].last_key := current 
				}
			}
			_TripleToggleMap[keybind].last_toggle := 2
		}
		TTMK.first_toggle := first_toggle
		TTMK.second_toggle := second_toggle 
	}
	TTMK := _TripleToggleMap[keybind]
	AutoLongpress_Action(keybind, TTMK.first_toggle, TTMK.second_toggle)
}
TripleToggle_Action(keybind, primary1_action, primary2_action, secondary_action) {
	global _TripleToggleMap 
	if ( !_TripleToggleMap.Has(keybind) ) {
		_TripleToggleMap[keybind] := {
			last_toggle : 1,
			first_toggle : 0,
			second_toggle : 0
		}
		TTMK := _TripleToggleMap[keybind]
		first_toggle() {
			global _TripleToggleMap 
			ToggleActions(keybind, primary1_action, primary2_action)
			_TripleToggleMap[keybind].last_toggle := 1
		}
		second_toggle() {
			global _TripleToggleMap 
			if ( _TripleToggleMap[keybind].last_toggle = 1 ) { 
				secondary_action()
				_TripleToggleMap[keybind].last_toggle := 2
			} else {
				; virtually on first toggle 
				CurrentToggleActions(keybind, primary1_action, primary2_action)
				_TripleToggleMap[keybind].last_toggle := 1
			}
			
		}
		TTMK.first_toggle := first_toggle
		TTMK.second_toggle := second_toggle 
	}
	TTMK := _TripleToggleMap[keybind]
	AutoLongpress_Action(keybind, TTMK.first_toggle, TTMK.second_toggle)
}

_MatrixActionToggleMap := Map()
MatrixActionToggle(keypressed, action_toggles_names*){
	global _MatrixActionToggleMap, _ToggleActionsMap
	if ( !_MatrixActionToggleMap.Has(keypressed) ){
		arr := []
		arr.Push(action_toggles_names*)
		if (arr.Length = 0) {
			return 
		}
		_MatrixActionToggleMap[keypressed] := { current : 1, toggles_names : arr, toggle : 0 }
		vertical_toggle() {
			global _MatrixActionToggleMap
			MATMN := _MatrixActionToggleMap[keypressed]
			len := MATMN.toggles_names.Length
			if ( MATMN.current = len ) {
				MATMN.current := 1 
			} else {
				MATMN.current := MATMN.current + 1
			}
			CurrentToggleActions( MATMN.toggles_names[MATMN.current] )
		}
		_MatrixActionToggleMap[keypressed].toggle := vertical_toggle
	}
	MATMN := _MatrixActionToggleMap[keypressed]
	current_name := MATMN.toggles_names[ MATMN.current ]
	AutoLongpress_Action(
		keypressed, 
		(*)=>ToggleActions(current_name), 
		MATMN.toggle 
	)	
}

; RegisterToggleActions("line 1", (*)=>ToolTip("11"), (*)=>ToolTip("12"))
; RegisterToggleActions("line 2", (*)=>ToolTip("21"), (*)=>ToolTip("22"))
; z::MatrixActionToggle("z", "line 1", "line 2")

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

_AutoLongpress_isRunning := false 
AutoLongpress(keypressed, shortpress, longpress, ms_threshould := 500) {
	global _AutoLongpress_isRunning 
	if _AutoLongpress_isRunning
		return 
	_AutoLongpress_isRunning := true 
	start := A_TickCount 
	while ( GetKeyState(keypressed,"P") ) {
		if (A_TickCount - start > ms_threshould) {
			Send("{" longpress "}")
			KeyWait(keypressed)
			_AutoLongpress_isRunning := false 
			return 
		} 
		Sleep(1)
	}
	Send("{" shortpress "}")
	_AutoLongpress_isRunning := false 
}
AutoLongpress_Action(keypressed, shortaction, longaction, ms_threshould := 500) {
	global _AutoLongpress_isRunning 
	if _AutoLongpress_isRunning
		return 
	_AutoLongpress_isRunning := true 	
	start := A_TickCount 
	while ( GetKeyState(keypressed,"P") ) {
		if (A_TickCount - start > ms_threshould) {
			longaction()
			KeyWait(keypressed)
			_AutoLongpress_isRunning := false 
			return 
		} 
		Sleep(1)
	}
	shortaction() 
	_AutoLongpress_isRunning := false 
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








