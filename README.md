# Single-Player-Remap-AHK2

Scripts for single player gameplay using autohotkeys version 2

Don't use on multiplayer games, as they can be considered cheat ;D

Usage:
1. Download and Install Autohotkeys V2 on https://www.autohotkey.com/ 
2. Download these files `GameKeybindAutoLib.ahk`, `GuiAutoLib.ahk`, `cardinal.png`
3. Create a new script `myGameKeyBindScript.ahk` for your game in same folder of the script downloaded (you can create an empty text file and rename it changing the extension or use the context-menu option to create an empty script)
4. Insert these lines on top:

```AutoHotkey
#Requires AutoHotkey v2.0
#include GameKeybindAutoLib.ahk

; the function argument for isGameActive should be any substring from the process name of your desired game
; for instance if your process name is FarCry.exe you can put "FarCry" as argument
; you can inspect the process name in taskmanager on details section or the name of executable
#HotIf isGameActive("FarCry")
; === your custom keymaps ===
q::Autowalk("w") ; example for autowalk using q for normal wasd
e::AssignLongPress("e", "e", "y")
```

5. Use the functions on GameKeybindAutoLib to write your custom script
6. Double-Click on your script to activate
7. Start your game and make sure the keymap in game settings is consistent with your script. For instance, you should assign functionality for e and y for the longpress functionality. 

Avoid remapping everything, use the script to assign functionality to keys which you can't achieve in game options interface, for example: longpress input, autowalk, key toggle.  
