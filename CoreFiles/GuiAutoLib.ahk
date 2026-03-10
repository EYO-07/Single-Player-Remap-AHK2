#Requires AutoHotkey v2.0

; -- Graphical User Interface 
; works only with windowed or borderless gameplay 

CoordMode("Mouse", "Screen")
CoordMode("ToolTip", "Screen")

; -- utils
IsValidKey(key) {
    try {
        GetKeyState(key)
        return true
    } catch {
        return false
    }
}

CenterToSize(gui_component, parentW, parentH) {
    gui_component.GetPos(&x, &y, &w, &h)
    gui_component.Move((parentW - w)//2, (parentH - h)//2)
}

_GetKeypressedKeys := []
StoreKeypressed(excluded := []) {
    global _GetKeypressedKeys
    static keys := [
		"LShift","RShift",
		"LCtrl","RCtrl",
		"LAlt","RAlt",
        "LWin", "RWin",
        "Up", "Down", "Left", "Right",
        "Space", "Enter", "Tab",
        "a","b","c","d","e","f","g","h","i","j",
        "k","l","m","n","o","p","q","r","s","t",
        "u","v","w","x","y","z"
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
    global _GetKeypressedKeys
    for key in _GetKeypressedKeys {
		if (key = "") {
			continue 
		}
        if ( GetKeyState(key, "P") ) {
            Send("{" key " down}")
        }
    }
    _GetKeypressedKeys := []
}

GetActiveMonitor() {
	WinGetPos(&x, &y, &w, &h, "A")
    winCX := x + w // 2
    winCY := y + h // 2
	targetMon := MonitorGetPrimary() 
	count := MonitorGetCount()
    loop count {
        MonitorGet(A_Index, &mLeft, &mTop, &mRight, &mBottom)
        if (winCX >= mLeft && winCX < mRight && winCY >= mTop && winCY < mBottom) {
            targetMon := A_Index
            break
        }
    }
	return targetMon
}
GetActiveMonitor_HWND(hwnd) {
    WinGetPos(&x, &y, &w, &h, "ahk_id " hwnd)

    winCX := x + w // 2
    winCY := y + h // 2

    targetMon := MonitorGetPrimary()
	count := MonitorGetCount()
    loop count {
        MonitorGet(A_Index, &mLeft, &mTop, &mRight, &mBottom)

        if (winCX >= mLeft && winCX < mRight && winCY >= mTop && winCY < mBottom) {
            targetMon := A_Index
            break
        }
    }

    return targetMon
}

CenterActiveWindow() {
    hwnd := WinGetID("A")
    CenterActiveWindow_HWND(hwnd)
}
CenterActiveWindow_HWND(hwnd) {
    WinGetPos(&x, &y, &w, &h, "ahk_id " hwnd)
    MonitorGetWorkArea( GetActiveMonitor_HWND(hwnd), &mLeft, &mTop, &mRight, &mBottom)
    newX := mLeft + (mRight - mLeft - w) // 2
    newY := mTop + (mBottom - mTop - h) // 2
    WinMove(newX, newY, , , "ahk_id " hwnd)
}

GetWindowFrameSize(hwnd, &fx, &fy) {
    ; RECT structures
    win := Buffer(16)
    cli := Buffer(16)

    DllCall("GetWindowRect", "ptr", hwnd, "ptr", win)
    DllCall("GetClientRect", "ptr", hwnd, "ptr", cli)

    winW := NumGet(win, 8, "int") - NumGet(win, 0, "int")
    winH := NumGet(win, 12, "int") - NumGet(win, 4, "int")

    cliW := NumGet(cli, 8, "int")
    cliH := NumGet(cli, 12, "int")

    fx := winW - cliW
    fy := winH - cliH
}

_ToggleWindowedBorderlessMap := Map()
ToggleWindowedBorderless( b_center := true ) {
    global _ToggleWindowedBorderlessMap
    hwnd := WinGetID("A")
    if !hwnd
        return

    style   := WinGetStyle(hwnd)
    exstyle := WinGetExStyle(hwnd)

	if b_center
		CenterActiveWindow_HWND(hwnd)
		
    WinGetPos(&wx,&wy,&ww,&wh, hwnd)
    sw := A_ScreenWidth
    sh := A_ScreenHeight

    ; If we have stored state → restore windowed
    if _ToggleWindowedBorderlessMap.Has(hwnd) {
        data := _ToggleWindowedBorderlessMap[hwnd]
        WinSetStyle(data.style, hwnd)
        WinSetExStyle(data.exstyle, hwnd)
        WinMove(data.x, data.y, data.w, data.h, hwnd)
		_ToggleWindowedBorderlessMap.Delete(hwnd)
        return
    }
	
	; Otherwise store current windowed state
    _ToggleWindowedBorderlessMap[hwnd] := {
        style: style,
        exstyle: exstyle,
        x: wx,
        y: wy,
        w: ww,
        h: wh
    }
	
	GetWindowFrameSize(hwnd, &fx, &fy)
    newStyle := style
		& ~0x00C00000 ; WS_CAPTION
		& ~0x00800000 ; WS_BORDER
		& ~0x00040000 ; WS_THICKFRAME
		& ~0x00080000 ; WS_SYSMENU
		& ~0x00020000 ; WS_MINIMIZEBOX
		& ~0x00010000 ; WS_MAXIMIZEBOX
	WinSetStyle(newStyle, hwnd)
	WinMove(wx, wy, ww - fx, wh - fy, "ahk_id " hwnd)
	
	if b_center
		CenterActiveWindow_HWND(hwnd)
}

; -- radial menu 
global radialGui := 0
global radialCenterX := 0
global radialCenterY := 0
global radialSelection := ""
global DEADZONE := 30
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
	if ( !IsValidKey(key) ) {
		MsgBox "Invalid Expression -> " key
		return 
	}
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
	CenterToSize(pic, ww, wh)
    radialGui.SetFont("s16 c00ff99", "Consolas")
	text := radialGui.AddText("BackgroundTrans +Center w" ww " vDisplayText","")
	CenterToSize(text, ww, wh)
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
	
    if (radialGui) { 
		radialGui.Destroy() 
	}
		
	KeyWait(key)
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

; -- messages overlays 
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

_DisplayImageMessage_gui := 0 
_DestroyDisplayImageMessage() {
    global _DisplayImageMessage_gui
    if _DisplayImageMessage_gui {
        _DisplayImageMessage_gui.Destroy()
        _DisplayImageMessage_gui := 0
    }
}
DisplayImageMessage(img_path, milliseconds := 500) {
    global _DisplayImageMessage_gui
    WinGetPos(&wx, &wy, &ww, &wh, "A")
    if _DisplayImageMessage_gui {
        _DisplayImageMessage_gui.Destroy()
    }
    msgui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    msgui.BackColor := "010101"
    WinSetTransColor("010101", msgui)
    msgui.MarginX := 20
    msgui.MarginY := 15
    img := msgui.Add("Picture","+0xE", img_path)
    CenterToSize(img, ww, wh)
    msgui.Show("NA x" wx " y" wy " w" ww " h" wh)
    _DisplayImageMessage_gui := msgui
    SetTimer(() => _DestroyDisplayImageMessage(), -milliseconds)
}

; ====================================== INTERNAL ==========================================

; -- END 