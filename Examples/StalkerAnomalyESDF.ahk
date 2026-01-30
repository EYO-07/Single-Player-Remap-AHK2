#Requires AutoHotkey v2.0
#include GameKeybindAutoLib.ahk 

b_active := true
cyc_knife := [1,"Numpad1","Numpad2"]
cyc_weaps := [1,"Numpad3","Numpad4"]

Pause:: {
    global b_active
    b_active := !b_active
}

; ====================================================================================================
#HotIf (b_active && isGameActive("AnomalyDX")) 
\::LShift 
LWin::LCtrl 
LCtrl::Send("{WheelDown}") 
LShift::Send("{WheelUp}") 
Tab::AssignLongPress_Action( "Tab", (*)=>DoubleTap("LButton"), (*)=>Send("{Enter}") )
n::LButton 
m::RButton 
q::Autowalk("e") 
w::AssignLongPress("w","w","i")
r::AssignLongPress("r","r","o")
t::AssignLongPress("t","t","p")
a::AssignLongPress("a","a","Numpad5")
z::AssignLongPress("z","z","n")
c::AssignLongPress("c","c","RButton")
v::AssignLongPress("v","v","Numpad9")
LAlt::AssignLongPress("LAlt", "LAlt", "RAlt")
1::Numpad1
2::ToggleKeys(cyc_knife)
3::ToggleKeys(cyc_weaps)
toggle_detect_weap := 1
get_state_detect_weap() {
	global toggle_detect_weap
	aux := toggle_detect_weap
	if (toggle_detect_weap = 1) {
		toggle_detect_weap := 2 
	} else {
		toggle_detect_weap := 1
	}
	return aux 
}
get_current_detector(){
	return "Numpad5"
}
4::ToggleKeysByGetters(get_state_detect_weap, get_current_detector, get_current_weap)
; g::AssignLongPress("g","g","Numpad6")
g::AssignLongPress_Action( "g", (*)=>Send("g"), (*)=>G_Long() )
G_Long(){
	global toggle_detect_weap
	Send("{Numpad6}")
	toggle_detect_weap := 2 
}
toggle_melee := 1 
get_state_toggle_melee() {
	global toggle_melee 
	aux := toggle_melee
	if (toggle_melee = 1) {
		toggle_melee := 2 
	} else {
		toggle_melee := 1
	}
	return aux 
}
get_current_knife(){
	global cyc_knife
	return cyc_knife[2]
}
get_current_weap(){
	global cyc_weaps 
	return cyc_weaps[ cyc_weaps[1]+1 ]
} 
5::ToggleKeysByGetters( get_state_toggle_melee, get_current_knife, get_current_weap )
6::Tab  
