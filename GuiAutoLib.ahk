#Requires AutoHotkey v2.0

; -- Graphical User Interface 
; works only with windowed or borderless gameplay 

CoordMode("Mouse", "Screen")
CoordMode("ToolTip", "Screen")
global radialGui := 0
global radialCenterX := 0
global radialCenterY := 0
global radialSelection := ""
global DEADZONE := 30
global accDX := 0
global accDY := 0
global is_radial_active := false 

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
    SetTimer(f_up, 100)
	; -- 
	KeyWait(key)
	; -- 
    SetTimer(f_up, 0)
	
	; Sleep(10)
	
    if (radialGui) { 
		radialGui.Destroy() 
	}
		
	; Sleep(10)
		
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

DisplayImageMessage(img_path, milliseconds := 500) {
    static msgGui := 0
	WinGetPos(&wx, &wy, &ww, &wh, "A")
    ; Destroy previous message if exists
    if msgGui {
        msgGui.Destroy()
        msgGui := 0
    }

    ; Create GUI
    msgGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
	msgGui.BackColor := "010101"
	WinSetTransColor("010101", msgGui)
    msgGui.MarginX := 20
    msgGui.MarginY := 15
	
	; -- 
    img := msgGui.Add("Picture","+0xE", img_path)
	_CenterToSize(img, ww, wh)

    msgGui.Show("NA x" wx " y" wy " w" ww " h" wh)
	Sleep( milliseconds )
	msgGui.Destroy()
	msgGui := 0
}

; ====================================== INTERNAL ==========================================

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

_CenterToSize(gui_component, parentW, parentH) {
    gui_component.GetPos(&x, &y, &w, &h)
    gui_component.Move((parentW - w)//2, (parentH - h)//2)
}

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

; -- END 