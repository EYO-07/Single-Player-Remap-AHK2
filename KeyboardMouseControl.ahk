#Requires AutoHotkey v2.0

b_mouse_control_active := true

; mouse control 
move_step := 5 ; FLOAT pixels per tick (can be < 1)
move_interval := 2   ; ms
virt_x := 0.0
virt_y := 0.0
move_up := false
move_down := false
move_left := false
move_right := false

Numpad7:: {
    global b_mouse_control_active
    b_mouse_control_active := !b_mouse_control_active
}

Numpad8:: {
	global move_step
	if move_step = 5 
		move_step := 20
	else if move_step = 20 
		move_step := 5
}

; =========================
; Key Down
; =========================

Numpad5::  {
	global b_mouse_control_active
	if b_mouse_control_active {
		SetMove("up", true)
	} else {
		Send("{Numpad5}")
	}
} 

Numpad2::   {
	global b_mouse_control_active
	if b_mouse_control_active {
		SetMove("down", true)
	} else {
		Send("{Numpad2}")
	}
}

Numpad1::{
	global b_mouse_control_active
	if b_mouse_control_active {
		SetMove("left", true)
	} else {
		Send("{Numpad1}")
	}
}

Numpad3::  {
	global b_mouse_control_active
	if b_mouse_control_active {
		SetMove("right", true)
	} else {
		Send("{Numpad3}")
	}
}

; =========================
; Key Up
; =========================

Numpad5 Up::   SetMove("up", false)
Numpad2 Up::    SetMove("down", false)
Numpad1 Up:: SetMove("left", false)
Numpad3 Up::   SetMove("right", false)

; =========================
; Movement Control
; =========================

SetMove(dir, state) {
    global b_mouse_control_active
    global move_up, move_down, move_left, move_right

    if !b_mouse_control_active
        return

    switch dir {
        case "up":    move_up := state
        case "down":  move_down := state
        case "left":  move_left := state
        case "right": move_right := state
    }

    if (move_up || move_down || move_left || move_right)
        SetTimer(MoveMouse, move_interval)
    else
        SetTimer(MoveMouse, 0)
}

MoveMouse() {
    global move_step
    global virt_x, virt_y
    global move_up, move_down, move_left, move_right

    ; Accumulate float movement
    if move_up
        virt_y -= move_step
    if move_down
        virt_y += move_step
    if move_left
        virt_x -= move_step
    if move_right
        virt_x += move_step

    ; Convert to integer movement
    move_x := Round(virt_x)
    move_y := Round(virt_y)

    if (move_x != 0 || move_y != 0) {
        MouseMove(move_x, move_y, 0, "R")

        ; Remove applied integer movement, keep fractional remainder
        virt_x -= move_x
        virt_y -= move_y
    }
}

; =========================
; Remaps 
; =========================

#HotIf (b_mouse_control_active) 
Numpad4::LButton
Numpad6::RButton 
Numpad0::Send("{WheelDown}")
NumpadEnter::Send("{WheelUp}")






