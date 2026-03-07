; Inventories for Autohotkey v2 Syntax 

/* Inventory [ Hotkey Syntax ] { AHK v2 } 
1. x::Func()                    ; assign key x to call Func()
2. x:: {                        ; block hotkey
       MsgBox("Pressed X")
   }
3. ^x::                         ; Ctrl+X
4. !x::                         ; Alt+X
5. +x::                         ; Shift+X
6. #x::                         ; Win+X
7. ^!x::                        ; Ctrl+Alt+X combo
8. x up::Func()                 ; key release trigger
9. ~x::Func()                   ; pass-through (do not block native key)
10. *x::Func()                  ; wildcard (ignore modifiers)
11. $x::Func()                  ; prevent self-trigger via Send
12. #HotIf WinActive("ahk_exe notepad.exe") ; context-sensitive hotkeys
13. #HotIf                      ; reset context
14. Hotkey("x", Func("MyFunc")) ; dynamic hotkey creation
15. Hotkey("x", "Off")          ; disable dynamically 
*/

/* Inventory [ Strings ] { AHK v2 } 
1. str := "text"                ; literal string
2. str := 'text'                ; single-quoted literal
3. str := "Line1`nLine2"        ; newline (`n)
4. str := "Tab`tSeparated"      ; tab (`t)
5. str := "Quote `""            ; escaped quote
6. StrLen(str)                  ; string length
7. SubStr(str, start, len?)     ; substring
8. InStr(haystack, needle)      ; find substring
9. StrReplace(str, search, repl)
10. StrSplit(str, delim)        ; returns Array
11. Trim(str, chars?)           ; trim both sides
12. LTrim(str, chars?)          ; trim left
13. RTrim(str, chars?)          ; trim right
14. StrUpper(str)               ; uppercase
15. StrLower(str)               ; lowercase
16. Format("Value: {}", x)      ; formatted string
17. str .= "more"               ; append (concatenate)
*/

/* Inventory [ Arrays ] { AHK v2 } 
1. arr := []                    ; empty literal
2. arr[1]                       ; first element (1-based index)
3. arr.Length                   ; number of elements
4. arr.Push(value*)             ; append (variadic)
5. arr.Pop()                    ; remove last
6. arr.InsertAt(index, value*)
7. arr.RemoveAt(index, count:=1)
8. arr.Has(index)               ; index exists?
9. arr.Clone()                  ; shallow copy
10. for i, v in arr             ; iteration
11. arr.Sort(Func?)             ; sort (optional comparator)
12. arr.Reverse()               ; reverse order
*/

/* Inventory [ Maps/Dictionaries ] { AHK v2 }
1. map := Map()                 ; empty map
2. map[key] := value            ; assign
3. value := map[key]            ; access (throws if missing)
4. map.Has(key)                 ; key exists?
5. map.Get(key, default?)       ; safe retrieval
6. map.Set(key, value)
7. map.Delete(key)
8. map.Clear()
9. map.Count                    ; number of entries
10. for k, v in map             ; iteration
11. map.Clone()                 ; shallow copy
*/ 

/* Inventory [ Functions ] { AHK v2 } 
1. MyFunc() {                   ; basic function
       return 123
   }
2. MyFunc(x := 0)               ; default parameter
3. MyFunc(&refVar)              ; ByRef parameter
4. MyFunc(params*)              ; variadic (rest parameters)
5. return value                 ; return statement
6. global varName               ; access global inside function
7. static counter := 0          ; static local variable
8. local x := 1                 ; explicit local
9. Func("MyFunc")               ; function reference
10. fn := (*) => MsgBox("Hi")   ; lambda (fat arrow)
11. fn.Call()                   ; explicit call
12. IsSet(var)                  ; check if variable exists
*/

/* Inventory [ Loops/Iterations ] { AHK v2 } 
1. Loop 10 { }                  ; repeat 10 times
2. Loop { }                     ; infinite loop (break manually)
3. while (condition) { }
4. until (condition) { }
5. for key, value in collection { }
6. break                        ; exit loop
7. continue                     ; next iteration
8. A_Index                      ; current loop index
9. Loop Files, "C:\*.txt"       ; file iteration
10. Loop Read, "file.txt"       ; read file line by line
11. Loop Parse, str, ","        ; parse string
*/ 

/* Inventory [ Conditionals ] { AHK v2 }
1. if (x = 1)
2. if (x != 1)
3. if (x > 5 && y < 10)
4. if (x = 1 || y = 2)
5. else
6. switch value {
       case 1:
       case 2:
           MsgBox("One or Two")
       default:
           MsgBox("Other")
   }
*/

/* Inventory [ GUI ] { AHK v2 } 
1. gui := Gui()
2. gui.Title := "My Window"
3. gui.Add("Text", "w200", "Hello")
4. gui.Add("Button", "Default", "OK")
5. gui.Show("w300 h200")
6. gui.Destroy()
7. gui.OnEvent("Close", (*) => ExitApp())
8. control := gui.Add("Edit", "vMyEdit")
9. value := gui["MyEdit"].Value
10. gui.Submit()                ; update variables
*/

/* Inventory [ Objects ] { AHK v2 }
1. obj := {} ; empty object 
2. obj.HasOwnProp(propName) ; True if property exists directly on the object (not inherited)
3. HasProp(obj, propName) ; True if property exists (own or inherited)
4. HasMethod(obj, methodName) ; True if callable method exists
5. obj.GetOwnPropDesc(propName) ; Returns property descriptor (value, get/set, etc.) for own property
6. obj.OwnProps() ; Enumerator for own property names (for-loop compatible)
7. ObjGetBase(obj) ; Returns the base object (prototype)
8. ObjSetBase(obj, baseObj) ; Sets the object's base (prototype)
; --- Access / Mutation ---
9. obj.DeleteProp(propName) ; Deletes own property (if exists)
10. obj.Clone() ; Shallow copy of object
11. obj.DefineProp(name, descriptor) ; Define property with getter/setter/value
12. obj.%dynamicName% ; Dynamic property access
13. obj.%dynamicName% := value ; Dynamic property assignment
; --- Enumeration ---
14. for key, value in obj ; Iterates enumerable properties (own + inherited enumerable)
15. for key in obj.OwnProps() ; Iterate own property names only
; --- Error-safe patterns ---
16. try value := obj.prop catch; safe fallback
17. if HasProp(obj, "prop") value := obj.prop 
*/

/* Inventory [ Built-in Variables ] { AHK v2 } 
1. A_ScriptDir
2. A_ScriptName
3. A_TickCount
4. A_Now
5. A_Clipboard
6. A_Index
7. A_ThisHotkey
8. A_ThisFunc
9. A_WorkingDir
*/

/* Inventory [ Built-in Functions ] { AHK v2, General Utility } 
1. MsgBox(text, title?, options?)
2. ToolTip(text?, x?, y?)
3. Sleep(milliseconds)
4. ExitApp(exitCode?)
5. Reload()
6. Pause(state?)
7. SetTimer(FuncOrLabel, period, priority?)
8. Run(target, workingDir?, options?, &pid?)
9. RunWait(target, workingDir?, options?, &pid?)
10. ProcessExist(nameOrPID?)
11. ProcessClose(nameOrPID)
12. WinExist(title?)
13. WinActive(title?)
14. SoundBeep(freq?, duration?)
*/

/* Inventory [ Built-in Functions ] { AHK v2, Input/Keyboard/Mouse } 
1. Send(keys)
2. SendText(text)
3. SendEvent(keys)
4. SendInput(keys)
5. SendPlay(keys)
6. GetKeyState(key, mode?)
7. KeyWait(key, options?)
8. Click(options?)
9. MouseMove(x, y, speed?)
10. MouseGetPos(&x?, &y?, &win?, &ctrl?)
11. Hotkey(keyName, callback, options?)
*/

/* Inventory [ Built-in Functions ] { AHK v2, Window Management } 
1. WinActivate(title?)
2. WinClose(title?)
3. WinKill(title?)
4. WinMove(x?, y?, w?, h?, title?)
5. WinMinimize(title?)
6. WinMaximize(title?)
7. WinRestore(title?)
8. WinGetTitle(title?)
9. WinGetClass(title?)
10. WinGetPID(title?)
11. WinSetTitle(newTitle, title?)
12. WinSetAlwaysOnTop(value, title?)
13. WinSetTransparent(level, title?)
*/

/* Inventory [ Built-in Functions ] { AHK v2, String Functions } 
1. StrLen(str)
2. SubStr(str, start, length?)
3. InStr(haystack, needle, caseSense?, startPos?, occurrence?)
4. StrReplace(haystack, search, replace?, &count?, limit?)
5. StrSplit(str, delim?, omitChars?)
6. StrUpper(str)
7. StrLower(str)
8. Trim(str, chars?)
9. LTrim(str, chars?)
10. RTrim(str, chars?)
11. Format(formatStr, values*)
12. RegExMatch(haystack, pattern, &match?, pos?)
13. RegExReplace(haystack, pattern, replacement?, &count?, limit?)
*/

/* Inventory [ Built-in Functions ] { AHK v2, File System } 
1. FileExist(path)
2. FileDelete(path)
3. FileCopy(source, dest, overwrite?)
4. FileMove(source, dest, overwrite?)
5. FileAppend(text, filename, encoding?)
6. FileRead(filename, encoding?)
7. DirCreate(path)
8. DirDelete(path, recurse?)
9. DirCopy(source, dest, overwrite?)
10. DriveGetList(type?)
*/

/* Inventory [ Built-in Functions ] { AHK v2, Math } 
1. Abs(number)
2. Ceil(number)
3. Floor(number)
4. Round(number, decimals?)
5. Mod(dividend, divisor)
6. Sqrt(number)
7. Sin(rad)
8. Cos(rad)
9. Tan(rad)
10. ASin(value)
11. ACos(value)
12. ATan(value)
13. Exp(power)
14. Log(number)
15. Random(min?, max?) 
*/

/* Inventory [ Built-in Functions ] { AHK v2, Date/Time } 
1. FormatTime(dateTime?, format?)
2. DateAdd(dateTime, value, units)
3. DateDiff(dateTime1, dateTime2, units)
*/

/* Inventory [ Built-in Functions ] { AHK v2, Object/Type/Meta } 
1. Type(value) 
2. IsObject(value)
3. IsNumber(value)
4. IsInteger(value)
5. IsFloat(value)
6. IsString(value)
7. ObjGetBase(obj)
8. ObjSetBase(obj, base)
9. HasProp(obj, name)
10. HasMethod(obj, name)
*/

/* Inventory [ Built-in Functions ] { AHK v2, Flow/Error Handling } 
1. Try / Catch / Finally (statement form)
2. Throw(value?)
3. Error(message?, what?, extra?)
*/

/* Inventory [ Built-in Functions ] { AHK v2, Misc } 
1. A_Clipboard            ; (variable)
2. ClipWait(timeout?, waitForAnyData?)
3. ComObject(type, value?, flags?)
4. ComObjActive(progID)
5. ComObjCreate(progID)
6. DllCall(dllFunc, args*)
7. OutputDebug(text)
8. ListHotkeys()
9. ListVars()
10. KeyHistory()
*/


















; -- END 
