; Basic Keybinds for ESDF Movement Style 
; lines preceding with ; are comments and don't execute anything on autohotkeys syntax 
; read the script carefully, set the keymap and play in windowed mode 
; some games needs the script execution with administrative privileges
#Requires AutoHotkey v2.0

; Features Examples in this script 
; 1. Short and Long Press keybinds
; 2. Radial Menu with 5 binds 
; 3. Autowalk by Longpress in all four directions 

; make sure the file "GameKeybindAutoLib.ahk" and "GuiAutoLib.ahk" is in same folder of this script 
#include GameKeybindAutoLib.ahk 

; use pause to activate or deactivate the hotkeys in-game 
; use scrollock to change between windowed and borderless windowed, the function will center the game window
Pause::ToggleScript()
ScrollLock::Borderless() 
 
; Everything below hotif statements only works with script active 
; Additionaly you can use isGameActive(GAMENAME) to filter the functionality only for your game 
; #HotIf ( isScriptActive() && isGameActive(GAMENAME) )  
; ===================================================================================
#HotIf ( isScriptActive() )  

; Keypressed X Keybind - The keypressed is the physical key pressed on your keyboard, the Keybind is the key assigned in game options. In general, the syntax q::w in autohotkeys means that the physical key q will trigger the keybind w in your game if the script is active.

; If \ isn't located between Z and LShift change \ to that key. 
\::LShift 
LWin::LCtrl

; keyboard mouse controls 
LShift::ScrollUp() 
LCtrl::ScrollDown() 
n::LButton 
m::RButton 
CapsLock::DoubleTap("LButton")

; Keys assumed to not be physically pressed, these keys will be used for keybind functionalities 
; y,u,i,o,p,h,j,k,l,7,8,9,0

; short tap activate the keybind q, long press and release activate keybind y
q::LongPress("q","q","y")

; this is the cardinal menu, radial menu in cardinal directions and a default action 
; it can map 5 binds in one key 
; rename the zNames as you wish 
zActions := Map()
zNames := Map() 
zNames["Up"] := "Keybind u"
zActions["Up"] := (*)=>Send("u")
zNames["Down"] := "Keybind o"
zActions["Down"] := (*)=>Send("o")
zNames["Left"] := "Keybind p"
zActions["Left"] := (*)=>Send("p")
zNames["Right"] := "Keybind h"
zActions["Right"] := (*)=>Send("h")
zDefault := (*)=>Send(",")
z::CardinalMenu("z", zActions, zNames, zDefault)

; autowalk in four directions by longpress, if you press is long enough it will hold the key until you press again or press the opposite direction.
; please assign i,j,k,l as keybinds for (up,left,down,right) movement directions in game menu.
delay_ms := 3500
e::KeypressAutowalk_VI("e","i",delay_ms)
~d::CancelKeys("i")
d::KeypressAutowalk_VI("d","k",delay_ms)
~e::CancelKeys("k")
s::KeypressAutowalk_VI("s","j",delay_ms)
~f::CancelKeys("j")
f::KeypressAutowalk_VI("f","l",delay_ms)
~s::CancelKeys("l")

; -- END 