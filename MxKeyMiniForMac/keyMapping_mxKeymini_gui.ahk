; MX Keys Mini For Mac - Key Remapping with GUI
#NoEnv
#SingleInstance Force
#Persistent

; Check if running with GUI parameter
if (A_Args.Length() = 0 or A_Args[1] != "nogui")
{
    ShowSettingsGUI()
    return
}

; Key remapping
RWin::Send {vk15}      ; Right Win -> IME Hangul
LAlt::LWin             ; Left Alt -> Left Win
LWin::LAlt             ; Left Win -> Left Alt

return

ShowSettingsGUI()
{
    global
    
    ; Check current startup status
    RegRead, startupValue, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, MXKeysRemapper
    isInStartup := (ErrorLevel = 0)
    
    ; Create GUI with Windows 11 style
    Gui, +AlwaysOnTop
    Gui, Color, FFFFFF
    Gui, Margin, 20, 20
    
    ; Title
    Gui, Font, s11 Bold, Segoe UI
    Gui, Add, Text, x20 y15 w460 h30 c1a1a1a, MX Keys Mini - Key Remapping Settings
    
    ; Separator
    Gui, Add, Progress, x20 y50 w460 h1 BackgroundE0E0E0 Disabled
    
    ; Key mapping info section
    Gui, Font, s9 Bold, Segoe UI
    Gui, Add, Text, x20 y65 w460 h25 c333333 Background0xF5F5F5, Current Key Mappings
    
    Gui, Font, s9 Normal, Segoe UI
    Gui, Add, Text, x35 y100 w200 h25, Right Windows Key
    Gui, Add, Text, x235 y100 w30 h25 Center, ->
    Gui, Add, Text, x265 y100 w215 h25, IME Hangul (Korean/English Toggle)
    
    Gui, Add, Text, x35 y130 w200 h25, Left Alt Key
    Gui, Add, Text, x235 y130 w30 h25 Center, ->
    Gui, Add, Text, x265 y130 w215 h25, Left Windows Key
    
    Gui, Add, Text, x35 y160 w200 h25, Left Windows Key
    Gui, Add, Text, x235 y160 w30 h25 Center, ->
    Gui, Add, Text, x265 y160 w215 h25, Left Alt Key
    
    ; Separator
    Gui, Add, Progress, x20 y195 w460 h1 BackgroundE0E0E0 Disabled
    
    ; Startup option section
    Gui, Font, s9 Bold, Segoe UI
    Gui, Add, Text, x20 y210 w460 h25 c333333 Background0xF5F5F5, Startup Options
    
    Gui, Font, s9 Normal, Segoe UI
    Gui, Add, Checkbox, x35 y245 w420 h25 vStartupCheck Checked%isInStartup%, Run at Windows startup    
    ; Separator
    Gui, Add, Progress, x20 y285 w460 h1 BackgroundE0E0E0 Disabled
    
    ; Buttons
    Gui, Font, s9, Segoe UI
    Gui, Add, Button, x200 y305 w90 h32 gApplySettings, Apply
    Gui, Add, Button, x300 y305 w90 h32 gRunNow Default, Run Now
    Gui, Add, Button, x400 y305 w80 h32 gGuiClose, Cancel
    
    ; Status bar
    Gui, Font, s8 c808080, Segoe UI
    Gui, Add, Text, x20 y350 w460 h20 Center vStatusText,
    
    Gui, Show, w500 h380, MX Keys Mini Remapper
    return
}

ApplySettings:
    Gui, Submit, NoHide
    
    exePath := A_ScriptFullPath
    if (SubStr(exePath, -3) = ".ahk")
    {
        ; If running as .ahk, show warning
        GuiControl,, StatusText, Warning: Please compile to .exe for startup registration
        Sleep, 2500
        GuiControl,, StatusText,
        return
    }
    
    if (StartupCheck)
    {
        ; Add to startup
        RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, MXKeysRemapper, "%exePath%" nogui
        GuiControl,, StatusText, Successfully added to Windows startup!
    }
    else
    {
        ; Remove from startup
        RegDelete, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, MXKeysRemapper
        GuiControl,, StatusText, Successfully removed from Windows startup!
    }
    
    Sleep, 2000
    GuiControl,, StatusText,
    return

RunNow:
    ; Run the script in background (no GUI)
    Run, "%A_ScriptFullPath%" nogui
    ExitApp
    return

GuiClose:
GuiEscape:
    ExitApp
    return
