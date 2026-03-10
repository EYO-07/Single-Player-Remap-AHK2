# Single-Player-Remap-AHK2

### Current Features:
1. Short and Long Press 
2. Autowalk and Long Press Autowalk 
3. Cardinal Radial Menu (Don't work on fullscreen gameplay)
4. Keys Toggles and Keys Cycles 
5. Key State Toggle (Key Up and Key Down toggle) 

Scripts for single player gameplay using autohotkeys version 2, don't use on multiplayer games, as they can be considered cheat ;D

### Usage:
1. Download and Install Autohotkeys V2 on https://www.autohotkey.com/ 
2. Download the `CoreFiles` folder
3. Create a new script `myGameKeyBindScript.ahk` for your game in this folder (you can create an empty text file and rename it changing the extension or use the context-menu option to create an empty script)
4. Insert these lines on top:

```AutoHotkey
#Requires AutoHotkey v2.0
#include GameKeybindAutoLib.ahk ; main library

; play in windowed mode to full script compatibility 
Pause::ToggleScript() ; use keyboard pause to activate or deactivate the hotkeys in-game.
ScrollLock::Borderless() ; use keyboard scrollock to change between windowed and borderless windowed, the function will center the game window.

; #HotIf ( isGameActive(GAMENAME) && isScriptActive() )  
; always put this statement before assigning custom binds, this ensure the keybinds is contained in case of game crash
; Everything below this hotif statements only works with script active 
; Additionaly you can use isGameActive(GAMENAME) to filter the functionality only for your game 
; the function argument for isGameActive should be any substring from the process name of your desired game
; for instance if your process name is FarCry.exe you can put "FarCry" as argument
; you can inspect the process name in taskmanager on details section or the name of executable
#HotIf ( isGameActive("FarCry") && isScriptActive() )

; === your custom keymaps ===
q::Autowalk("w") ; example for autowalk using q for normal wasd movement in-game keybinds 
e::AutoLongpress("e", "e", "y")
```

5. Use the functions on GameKeybindAutoLib to write your custom script
6. Double-Click on your script to activate
7. Start your game and make sure the keymap in game settings is consistent with your script. For instance, you should assign functionality for e and y for the longpress functionality. 

Avoid remapping everything, use the script to assign functionality to keys which you can't achieve in game options interface, for example: longpress input, autowalk, key toggle. 

## Snippets

### Forward Autowalk by Long Press

```AutoHotkey
; assuming h is not binded to anything in-game
; remap in game options the movements to h forward, and (a,s,d) to (left, backward, right) respectively.
w::KeypressAutowalk_VI("w", "h", 5500) ; 5.5 seconds
~s::CancelKeys("h") ; cancel the autowalk with s or pressing w again
```

### Smart Weapon Toggle using TripleToggle function

```AutoHotkey
; Assuming, change it if not the case ...
; 1 - as in-game keybind for secondary weapon/side weapon (pistol, knife)
; 2 - as in-game keybind for primary weapon 1 (main weapon)
; 3 - as in-game keybind for primary weapon 2 (alternate weapon)
2::TripleToggle(2,2,3,1) ; short tap to toggle between primaries, hold to toggle between secondary or the last primary
```

### Radial Menu in Cardinal Directions

```AutoHotkey
; this is the cardinal menu, radial menu in cardinal directions and a default action 
; it can map 5 binds in one key 
; rename the description for each key as you wish
CapsLock_Names := Map()
CapsLock_Actions := Map()
CapsLock_Names["Up"] := "number key 1"
CapsLock_Actions["Up"] := (*)=>Send(1)
CapsLock_Names["Right"] := "number key 2"
CapsLock_Actions["Right"] := (*)=>Send(2)
CapsLock_Names["Down"] := "number key 3"
CapsLock_Actions["Down"] := (*)=>Send(3)
CapsLock_Names["Left"] := "number key 4"
CapsLock_Actions["Left"] := (*)=>Send(4)
; don't use backslash for radial menu, the backslash is used for special characters in strings and the ahk have limited support
; backslash can be used for direct binds
CapsLock::CardinalMenu("CapsLock", CapsLock_Actions, CapsLock_Names)
```

### Smart Toggle using MatrixActionToggle 

```AutoHotkey
; Assuming 1,2,3 are keybinds for weapons in game menu
; ... 4,5,6 are keybinds for items in game menu
RegisterToggleActions("weapons", (*)=>Send(1), (*)=>Send(2), (*)=>Send(3))
RegisterToggleActions("items", (*)=>Send(4), (*)=>Send(5), (*)=>Send(6))
CapsLock::MatrixActionToggle("CapsLock", "weapons", "items") ; short press to use the current cycle, long press to change cycles
```



