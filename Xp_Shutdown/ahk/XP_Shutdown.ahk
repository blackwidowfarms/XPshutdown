#SingleInstance, force														; forces new instance of script
#Persistent																	; keeps script active
#NoTrayIcon																	; hides tray icon
SetBatchLines, -1															; runs at full speed
SetWorkingDir %A_ScriptDir%													; sets script directory as working directory
OnExit, OnExitCommand														; if script exits by any method, OnExitCommand subroutine is run
#Include, misc\functions.ahk												; gets shared program functions

Process, Close, XP_Logoff.exe												; terminates this process
Process, Close, XP_Settings.exe												; terminates this process

IniRead, Language, misc\options.ini, MainOptions, Language, English			; gets chosen language, "English" if error
IniRead, DesktopChange, misc\options.ini, MainOptions, DesktopChange, 0		; gets "change desktop" information, "0" if error
IniRead, FadeInTips, misc\options.ini, MainOptions, FadeInTips, 0			; gets "fade-in bubble-tips" information, "0" if error
IniRead, JapaneseSize, misc\options.ini, MainOptions, JapaneseSize, 0		; if Japanese, checkbox for "Original Size" saved here, "0" if error
if DesktopChange = 1														; if "Desktop FX" is "Yes"...
	gosub, TurnOnHotkeys													; makes ding sound if mouse clicks outside menu
Loop, 39																	; reads INI file for all keys' contents
{
	IniRead, Text%A_Index%, misc\options.ini, %Language%, key%A_Index%		; reads each key under chosen language and assigns to variable
	StringReplace, Text%A_Index%, Text%A_Index%, ||, `n, All				; replaces pipe-delimiters with line breaks for accuracy
}

if Language = Japanese														; if Language is Japanese...
{
	if JapaneseSize = 1														; and if "Original Size" is selected...
		gosub OriginalJapaneseDimensions									; use Japanese (non-patched) XP menu and button dimensions (stretched)
	else																	; if "Original Size" is not selected...
		gosub, RegularDimensions											; use "US English" XP menu and button dimensions
}
else																		; if Language is not Japanese...
	gosub, RegularDimensions												; use "US English" XP menu and button dimensions

Gui, Default: New
Gui, Default: Color, black													; GUI background color, makes 1px black border effect
Gui, Default: Add, Picture, x1 y1 w%BkgWidth% h%BkgHeight%, images\Bitmap20142.jpg						; exact JPG copy of Windows background BMP image
Gui, Default: Add, Picture, x%FlagXpos% y%FlagYpos% w%FlagWidth% h%FlagHeight%, images\Bitmap20141.png	; exact PNG copy of Windows logo BMP image
AddGraphicBtn("x" Button1xPos,"y" ButtonsYpos,"h" ButtonsHeight,"w" ButtonsWidth,"Btn1","images\Standby.bmp","images\StandbyHover.bmp","images\StandByDown.bmp")	; loads all 3 states of "Stand By" button
AddGraphicBtn("x" Button2xPos,"y" ButtonsYpos,"h" ButtonsHeight,"w" ButtonsWidth,"Btn2","images\TurnOff.bmp","images\TurnOffHover.bmp","images\TurnOffDown.bmp")	; loads all 3 states of "Turn Off" button
AddGraphicBtn("x" Button3xPos,"y" ButtonsYpos,"h" ButtonsHeight,"w" ButtonsWidth,"Btn3","images\Restart.bmp","images\RestartHover.bmp","images\RestartDown.bmp")	; loads all 3 states of "Restart" button
ButtonCount = 3																; there are 3 buttons
MouseOnButton = 0															; mouse is neither on any GUI button...
ButtonMouseOn =																; ...nor is any GUI button in the down position
MidClick = 0																; mouse button is not in the down position

LoadCustomFonts()															; loads custom fonts from "misc" folder

Gui, Default: Font, cWhite s%Text28% %FontWeight%, %Text27%					; sets font type and size for main text, bold (norm for Japanese)
Gui, Default: Add, Text, x10 y12 w290 +BackgroundTrans, %Text1%				; "Shut down computer" main text
Gui, Default: Font, s%Text30% bold, %Text29%								; sets font type and size for buttons, bold
Gui, Default: Add, Text, x%Text1xpos% y%TextYpos% w%Text1width% +BackgroundTrans Center vStandByText, %Text2%	; adds "Stand By" text initially, changes to "Hibernate" when Shift key held down
Gui, Default: Add, Text, x%Text2xpos% y%TextYpos% w%Text2width% +BackgroundTrans Center, %Text3%		; adds "Turn Off" text
Gui, Default: Add, Text, x%Text3xpos% y%TextYpos% w%Text3width% +BackgroundTrans Center, %Text4%	; adds "Restart" text
Loop, 3
	GuiControl, Default: Hide, Btn%A_Index%Hvr								; hides all 3 "hover-state" buttons
Loop, 3
	GuiControl, Default: Hide, Btn%A_Index%Dwn								; hides all 3 "down-state" buttons
SysGet, MainMonitorNumber, MonitorPrimary									; gets primary monitor id
SysGet, MainMonitor, Monitor, %MainMonitorNumber%							; gets dimensions of primary monitor
Yposition := Round(MainMonitorBottom / 4)									; divides height by 4 to get Y position of main GUI

; ---Bubble-tip main hidden GUI------------------------------------------------------------------------------------------------------------|
TransAmount = 0
Gui, BubbleWindow: new														; creates new GUI to work on, BubbleWindow
Gui, BubbleWindow: +LastFound -Caption +ToolWindow +AlwaysOnTop +E0x20		; no titlebar or taskbar button, topmost and click-through
Gui, BubbleWindow: Color, 0x008000											; sets BubbleWindow background color something unique
WinSet, TransColor, 0x008000 %TransAmount% 									; sets transparent color the same as unique GUI color
Gui, BubbleWindow: Show, y%Yposition% w800 h255 NoActivate, BubbleWindow	; shows bubble-tip window without activating it
; ---Bubble-tip window 1-------------------------------------------------------------------------------------------------------------------|
Gui, BubbleWindow: Add, Picture, x%Bubble1xpos% y%BubblesYpos% w322 h-1 +BackgroundTrans vMyPic1 Hidden, images\%Text19%.png	; bubble image 1
Gui, BubbleWindow: Font, s%Text31% bold, %Text29%							; bold font
Gui, BubbleWindow: Add, Text, x%BubbleText1xpos% y%BubbleTitlesYpos% w302 +BackgroundTrans vMyText1 Hidden, %Text2%	; "Stand By" bubble text title
Gui, BubbleWindow: Font, s%Text31% norm, %Text29%							; normal font
Gui, BubbleWindow: Add, Text, x%BubbleText1xpos% y%BubbleTextsYpos% w302 r6 +BackgroundTrans vMyText2 Hidden, %Text5%	; "Stand By" bubble text description
; ---Bubble-tip window 2-------------------------------------------------------------------------------------------------------------------|
Gui, BubbleWindow: Add, Picture, x%Bubble2xpos% y%BubblesYpos% w322 h-1 +BackgroundTrans vMyPic2 Hidden, images\%Text20%.png	; bubble image 2
Gui, BubbleWindow: Font, s%Text31% bold, %Text29%							; bold font
Gui, BubbleWindow: Add, Text, x%BubbleText2xpos% y%BubbleTitlesYpos% w302 +BackgroundTrans vMyText3 Hidden, %Text3%	; "Turn Off" bubble text title
Gui, BubbleWindow: Font, s%Text31% norm, %Text29%							; normal font
Gui, BubbleWindow: Add, Text, x%BubbleText2xpos% y%BubbleTextsYpos% w302 r6 +BackgroundTrans vMyText4 Hidden, %Text6%	; "Turn Off" bubble text description
; ---Bubble-tip window 3-------------------------------------------------------------------------------------------------------------------|
Gui, BubbleWindow: Add, Picture, x%Bubble3xpos% y%BubblesYpos% w322 h-1 +BackgroundTrans vMyPic3 Hidden, images\%Text21%.png	; bubble image 3
Gui, BubbleWindow: Font, s%Text31% bold, %Text29%							; bold font
Gui, BubbleWindow: Add, Text, x%BubbleText3xpos% y%BubbleTitlesYpos% w300 +BackgroundTrans vMyText5 Hidden, %Text4%	; "Restart" bubble text
Gui, BubbleWindow: Font, s%Text31% norm, %Text29%							; normal font
Gui, BubbleWindow: Add, Text, x%BubbleText3xpos% y%BubbleTextsYpos% w302 r6 +BackgroundTrans vMyText6 Hidden, %Text7%	; "Restart" bubble text description

; ---"Shutdown with updates available"-----------------------------------------------------------------------------------------------------|
Gui, Default: Add, Picture, x1 y%UpdateBkgYpos% w%UpdateBkgWidth% h%UpdateBkgHeight% vUpdatesBkg Hidden, images\Bitmap20142updates.jpg	; blue JPG background image
Gui, Default: Add, Picture, x5 y%UpdateIconSmallYpos% w16 h-1 vUpdatesIcon +BackgroundTrans Hidden, images\ShutdownUpdates.png	; smaller instance of icon
Gui, Default: Font, cWhite s%Text31% norm, %Text29%															; sets correct font color and size
Gui, Default: Add, Text, x25 y%UpdateTextYpos% w%UpdateTextWidth% +BackgroundTrans vNonLinkText Hidden, %Text34%						; not underlined text (w266 original)
Gui, Default: Add, Text, x25 y%UpdateTextYpos% +BackgroundTrans vSpacing Hidden, %Text35%								; spaces to place following line at correct location
Gui, Default: Font, cWhite s%Text31% underline, %Text29%													; underlining applied to font
Gui, Default: Add, Text, x+0 y%UpdateTextYpos% +BackgroundTrans gShutdownNoUpdates vNoUpdateLink1 Hidden, %Text36%		; first line of second sentence (underlined link)
Gui, Default: Add, Text, x25 y+0 +BackgroundTrans gShutdownNoUpdates vNoUpdateLink2 Hidden, %Text37%		; second line of second sentence (underlined link)
; -----------------------------------------------------------------------------------------------------------------------------------------|

Gui, Default: -Caption +ToolWindow +AlwaysOnTop								; no titlebar, no taskbar button, always on top
Gui, Default: Show, y%Yposition% w%WindowWidth% h%WindowHeight%, ShutdownWindow					; distance from top was calculated earlier
Gui, Default: Font, norm													; changes to normal-size black font for Cancel button
Gui, Default: Add, Button, x%CancelXpos% y%CancelYpos% w78 h21 gCancel vCancelButton -Theme, %Text13%	; adds Cancel button

XpArrowPointer()															; loads XP arrow pointer
if DesktopChange = 1														; if "Desktop FX" is "Yes"...
{													
	if FileExist("misc\fade.exe")											; if fade function has been compiled into EXE
		Run, misc\fade.exe													; applies "fade to grey" effect (as seperate process, does not interfere)
	else																	; if misc\fade.ahk has not been compiled into EXE
	{
		gosub, TurnOffHotkeys												; allows user to click the OK button on MsgBox
		Gui, Default: +OwnDialogs											; prevents MsgBox from showing behind main menu
		MsgBox, misc\fade.exe was not found.`nPlease compile misc\fade.ahk`nFade function disabled.	; user needs to compile misc\fade.ahk
	}																		; menu keeps loading without the fade function anyway
}

Gui, IconImage: New															; new window, not picture control, for "always on top" focus purposes
Gui, IconImage: Color, 0x008000												; sets BubbleWindow background color something unique
Gui, IconImage: Add, Picture, x%UpdateIconLargeXpos% y%UpdateIconLargeYpos% w22 h-1 vOverlayIcon +BackgroundTrans Hidden, images\ShutdownUpdates.png	; icon image, placed but hidden
Gui, IconImage: +LastFound -Caption +ToolWindow +E0x20 +AlwaysOnTop			; no titlebar or taskbar button, topmost and click-through
WinSet, TransColor, 0x008000 255 											; sets transparent color the same as unique GUI color
Gui, IconImage: Show, y%Yposition% w52 h120									; shows the overlay icon image window with icon hidden

OnMessage(0x200, "MouseMove")							; detects when mouse is moved
OnMessage(0x201, "MouseLDown")							; detects when left mouse button is clicked down
OnMessage(0x202, "MouseLUp")							; detects when left mouse button is released
SetTimer, CheckHoverDesktop, 50							; checks if mouse over desktop 20 times per second
return

LShift::												; maps SHIFT keys to "Stand By" button for alternate "Hibernate" functionality
RShift::
	GuiControl, Default:, StandByText, %Text32%			; changes to "Hibernate" text
	GuiControl, BubbleWindow:, MyText1, %Text32%		; change bubble-tip title text to "Hibernate" also
	GuiControl, BubbleWindow:, MyText2, %Text33%		; change bubble-tip description text
KeyWait, Shift											; waits for SHIFT key to be released
	Guicontrol, Default:, StandByText, %Text2%			; changes back to "Stand By" text
	GuiControl, BubbleWindow:, MyText1, %Text2%			; change bubble-tip title text to "Stand By" also
	GuiControl, BubbleWindow:, MyText2, %Text5%			; change bubble-tip description text
return

~Control::												; maps CONTROL keys to toggle "Shutdown with updates" extension menu
PreventRepeating() 										; stops CONTROL from repeating and toggling the menu unnecessarily while held down
Toggle := !Toggle										; hotkey state modifier, alternates 1 or 0 on each press
if (Toggle = 1)											; if CONTROL is pressed
{
	GuiControl, BubbleWindow:, MyText4, %Text38%		; changes "Turn Off" bubble-tip text when CTRL is pressed for "Shutdown with Updates" feature
	GuiControl, Default: Show, UpdatesBkg				; shows blue background PNG
	GuiControl, Default: Move, CancelButton, y%CancelYpos2%		; moves "Cancel" button to new position on new background
	GuiControl, Default: Show, UpdatesIcon				; shows smaller instance of icon
	GuiControl, Default: Show, NonLinkText				; shows first sentence of text, not underlined
	GuiControl, Default: Show, Spacing					; shows spaces to place following line at correct location
	GuiControl, Default: Show, NoUpdateLink1			; shows first line of second sentence (underlined)
	GuiControl, Default: Show, NoUpdateLink2			; shows second line of second sentence (underlined)
	Gui, Default: Show, h%ExtendedHeight%, ShutdownWindow			; shows extended background in main GUI
	Gui, IconImage: Show								; shows the overlay icon window this way to prevent flicker
	GuiControl, IconImage: +Redraw, OverlayIcon			; larger instance of icon (over "Turn Off" button)
	GuiControl, Default: +Redraw, CancelButton			; redraws the "Cancel" button this way to ensure it gets top z-order
	Gui, BubbleWindow: +AlwaysOnTop						; if bubble-tip is active, it needs to stay on top or lose z-order
	}
else													; if CONTROL is pressed again
{
	GuiControl, BubbleWindow:, MyText4, %Text6%			; restores "Turn Off" bubble-tip text when CTRL is pressed again for default "Turn Off" mode
	GuiControl, Default: Hide, UpdatesBkg				; hides blue background PNG
	GuiControl, Default: Move, CancelButton, y%CancelYpos%				; moves "Cancel" button back to original position in main GUI
	GuiControl, Default: Hide, UpdatesIcon				; hides smaller instance of icon
	GuiControl, Default: Hide, NonLinkText				; hides first sentence, not underlined
	GuiControl, Default: Hide, Spacing					; hides spaces to place following line at correct location
	GuiControl, Default: Hide, NoUpdateLink1			; hides first line of second sentence (underlined)
	GuiControl, Default: Hide, NoUpdateLink2			; hides second line of second sentence (underlined)
	Gui, Default: Show, h%WindowHeight%, ShutdownWindow			; restores main GUI's height
	Gui, IconImage: Hide								; hides the overlay icon window this way to prevent flicker
	GuiControl, Default: +Redraw, CancelButton			; redraws the "Cancel" button this way to ensure it gets top z-order
	Gui, BubbleWindow: +AlwaysOnTop						; if bubble-tip is active, it needs to stay on top or lose z-order
}
return

CheckHoverDesktop:										; check if the mouse is over program window or desktop.
MouseGetPos,,,, hwnd									; gets mouse position
if DesktopChange = 1									; if "Desktop FX" option is "Yes"...
{
	if (hwnd = "Button1") or (hwnd = "Static1") or (hwnd = "Static3") or (hwnd = "Static4") or (hwnd = "Static5") or (hwnd = "Static6") or (hwnd = "Static7") or (hwnd = "Static8") or (hwnd = "Static9") or (hwnd = "Static10") or (hwnd = "Static11") or (hwnd = "Static12") or (hwnd = "Static13") or (hwnd = "Static14") or (hwnd = "Static15") or (hwnd = "Static16") or (hwnd = "Static17") or (hwnd = "Static18") or (hwnd = "Static19") or (hwnd = "Static20") or (hwnd = "Static21")
		gosub, TurnOffHotkeys							; enables keys and mouse clicks if mouse is in any of above controls
	else
		gosub, TurnOnHotkeys							; disables keys and mouse clicks, makes "ding" sound instead
}
return

TurnOffHotkeys:											; enables keys and mouse clicks
Hotkeys = LButton|MButton|RButton|XButton1|XButton2|WheelUp|WheelDown|LWin|RWin|Tab|Space|Enter|Alt|!Tab|^+Tab
Loop, Parse, Hotkeys, |									; uses pipe delimiter "|" as separator
Hotkey, %A_LoopField%,, Off								; key mapping suspended, so the above keys and buttons operate normally
return

TurnOnHotkeys:											; disables keys and mouse clicks, makes "ding" sound instead
Hotkeys = LButton|MButton|RButton|XButton1|XButton2|WheelUp|WheelDown|LWin|RWin|Tab|Space|Enter|Alt|!Tab|^+Tab
Loop, Parse, Hotkeys, |									; uses pipe delimiter "|" as separator
Hotkey, %A_LoopField%, ding, On							; plays ding sound instead of regular key functions
return
ding:
SoundPlay, misc\ding.wav								; plays ding sound whn mouse clicks out of window
return

S::
DllCall("PowrProf\SetSuspendState", "int", 0, "int", 1, "int", 0)	; command for Stand By (sleep) keyboard shortcut
ExitApp

H::
DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)	; command for Hibernate keyboard shortcut
ExitApp

Btn1_up:												; mouse-up event on button 1
gosub, HideBubbleWindow									; hides bubble-tip windows
ControlGetText, StandbyOrHibernate, Static13			; gets either "Stand By" or "Hibernate" text from Static 13 control
if StandbyOrHibernate = %Text2%							; if text is "Stand By"
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 1, "int", 0)	; command for Stand By (sleep)
if StandbyOrHibernate = %Text32%						; if text is "Hibernate"
	DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)	; command for Hibernate
ExitApp													; exits script

Btn2_up:												; mouse-up event on button 2
U::														; original XP shortcut for shut down
ControlGet, OpenWindowsUpdates, Visible,, Static19		; checks if Static19 text control ("Click here to turn off without installing updates") is visible
if OpenWindowsUpdates = 1								; if 1 (true)...
{
	CheckFor10 := substr(A_OSVersion, 1, 2)				; gets the first 2 digits from Windows version number to check if Windows 10
	if CheckFor10 = 10									; if number starts with 10, it is Windows 10
		Run, ms-settings:windowsupdate-action			; opens Windows Updates in Windows 10 Settings
	if A_OSVersion = WIN_8.1							; if WIN_8.1
		Run, %A_WinDir%\system32\wuapp.exe				; opens Windows Updates in "wuapp.exe"
	if A_OSVersion = WIN_8								; if WIN_8
		Run, %A_WinDir%\system32\wuapp.exe				; (same)
	if A_OSVersion = WIN_7								; if WIN_7
		Run, %A_WinDir%\system32\wuapp.exe				; (same)
	if A_OSVersion = WIN_VISTA							; if WIN_VISTA...
		Run, %A_WinDir%\system32\wuapp.exe				; (same)
	if A_OSVersion = WIN_XP								; if WIN_XP...
		Run, %A_Windir%\system32\wupdmgr.exe			; opens Windows Updates in "wupmgr.exe"
}
else													; if 0 (false)...
	Shutdown, 1											; shuts down computer
ExitApp													; exits script

ShutdownNoUpdates:										; action for "Click here to turn off without installing updates"
SoundPlay, misc\click.wav
Shutdown, 1												; shuts down computer
ExitApp													; exits script

Btn3_up:												; mouse-up event on button 3
R::														; original XP shortcut for restart
Shutdown, 2												; restarts computer
ExitApp													; exits script	

C::														; original XP shortcut for Cancel
!F4::													; ALT+F4 by itself will not work correctly
Esc::													; escape key
Cancel:													; "Cancel" button
OnExitCommand:											; everything below runs if script exits by any means
Process, Close, fade.exe
RemoveCustomPointers()									; removes custom pointers
RemoveCustomFonts()										; removes custom fonts
ExitApp													; exits script

HideBubbleWindow:
XpArrowPointer()										; sets XP arrow cursor
Loop, 3
	GuiControl, BubbleWindow: Hide, MyPic%A_Index%		; hides bubble text windows
Loop, 6
	GuiControl, BubbleWindow: Hide, MyText%A_Index% 	; hides text controls	
return

Nothing:												; does nothing but fakes a gLabel for button images
return

; if Language is Japanese and "Original Size" is selected in options
OriginalJapaneseDimensions:
WindowWidth = 366			; entire menu GUI width
WindowHeight = 184			; entire menu GUI height
ExtendedHeight = 240		; (when CTRL is pressed) entire menu GUI extended height
BkgWidth = 364				; background image width
BkgHeight = 182				; background image height
UpdateBkgWidth = 364		; (when CTRL is pressed) extra background width
UpdateBkgHeight = 96		; (when CTRL is pressed) extra background height
UpdateBkgYpos = 143			; (when CTRL is pressed) extra background Y-position
FlagXpos = 313				; windows flag X-position
FlagYpos = 1				; windows flag Y-position
FlagWidth = 46				; windows flag width
FlagHeight = 39				; windows flag height
ButtonsWidth = 39			; all buttons' widths
ButtonsHeight = 30			; all buttons' heights
ButtonsYpos = 74			; all buttons' Y-position
Button1xPos = 61			; button 1 (Stand By) X-position
Button2xPos = 161			; button 2 (Turn Off) X-position
Button3xPos = 262			; button 3 (Restart) X-position
TextYpos = 110				; all buttons' text descriptions' Y-positions
Text1xpos = 12				; button 1 text description's X-position
Text2xpos = 22				; button 2 text description's X-position
Text3xpos = 214				; button 3 text description's X-position
Text1width = 138			; button 1 text description's width
Text2width = 315			; button 2 text description's width
Text3width = 133			; button 3 text description's width
BubblesYpos = 104			; all bubble windows' Y-positions
Bubble1xpos = 281			; bubble 1 X-position
Bubble2xpos = 381			; bubble 2 X-position
Bubble3xpos = 482			; bubble 3 X-position
BubbleTitlesYpos = 135		; all bubble windows' titles Y-positions
BubbleTextsYpos = 165		; all bubble windows' description texts Y-positions
BubbleText1xpos = 293		; bubble window 1 description text X-position
BubbleText2xpos = 393		; bubble window 2 description text X-position
BubbleText3xpos = 494		; bubble window 3 description text X-position
CancelXpos = 270			; Cancel button X-position
CancelYpos = 154			; Cancel button Y-position
CancelYpos2 = 212			; (when CTRL is pressed) Cancel button secondary Y-position
UpdateIconSmallYpos = 153	; (when CTRL is pressed) small update icon (security badge) Y-position
UpdateIconLargeYpos = 70	; (when CTRL is pressed) large update icon (security badge) on "Turn Off" button Y-position
UpdateIconLargeXpos = 32	; (when CTRL is pressed) large update icon (security badge) on "Turn Off" button X-position
UpdateTextYpos = 153		; description text for "shutdown with updates" Y-position
UpdateTextWidth = 328		; width of text control for "shutdown with updates" line 1
Text36 = %Text39%			; replace contents of %Text36% (from key36 in options) with contents of %Text39%
Text37 = %Text40%			; replace contents of %Text36% (from key37 in options) with contents of %Text40%
FontWeight = norm			; font weight for main "Turn off computer" text to normal
return

; if Language is not Japanese
RegularDimensions:
WindowWidth = 315			; entire menu GUI width
WindowHeight = 200			; entire menu GUI height
ExtendedHeight = 252		; (when CTRL is pressed) entire menu GUI extended height
BkgWidth = 313				; background image width
BkgHeight = 198				; background image height
UpdateBkgWidth = 313		; (when CTRL is pressed) extra background width
UpdateBkgHeight = 94		; (when CTRL is pressed) extra background height
UpdateBkgYpos = 157			; (when CTRL is pressed) extra background Y-position
FlagXpos = 266				; windows flag X-position
FlagYpos = 2				; windows flag Y-position
FlagWidth = 48				; windows flag width
FlagHeight = 40				; windows flag height
ButtonsWidth = 33			; all buttons' widths
ButtonsHeight = 33			; all buttons' heights
ButtonsYpos = 82			; all buttons' Y-position
Button1xPos = 51			; button 1 (Stand By) X-position
Button2xPos = 141			; button 2 (Turn Off) X-position
Button3xPos = 232			; button 3 (Restart) X-position
TextYpos = 120				; all buttons' text descriptions' Y-positions
Text1xpos = 0				; button 1 text description's X-position
Text2xpos = 0				; button 2 text description's X-position
Text3xpos = 182				; button 3 text description's X-position
Text1width = 138			; button 1 text description's width
Text2width = 315			; button 2 text description's width
Text3width = 133			; button 3 text description's width
BubblesYpos = 115			; all bubble windows' Y-positions
Bubble1xpos = 293			; bubble 1 X-position
Bubble2xpos = 383			; bubble 2 X-position
Bubble3xpos = 474			; bubble 3 X-position
BubbleTitlesYpos = 146		; all bubble windows' titles Y-positions
BubbleTextsYpos = 176		; all bubble windows' description texts Y-positions
BubbleText1xpos = 303		; bubble window 1 description text X-position
BubbleText2xpos = 393		; bubble window 2 description text X-position
BubbleText3xpos = 484		; bubble window 3 description text X-position
CancelXpos = 225			; Cancel button X-position
CancelYpos = 170			; Cancel button Y-position
CancelYpos2 = 222			; (when CTRL is pressed) Cancel button secondary Y-position
UpdateIconSmallYpos = 168	; (when CTRL is pressed) small update icon (security badge) Y-position
UpdateIconLargeYpos = 77	; (when CTRL is pressed) large update icon (security badge) on "Turn Off" button Y-position
UpdateIconLargeXpos = 31	; (when CTRL is pressed) large update icon (security badge) on "Turn Off" button X-position
UpdateTextYpos = 168		; description text for "shutdown with updates" Y-position
UpdateTextWidth = 266		; width of text control for "shutdown with updates" line 1
FontWeight = bold			; font weight for main "Turn off computer" text to bold
return

MakeTrans:
Loop
{
	MouseGetPos,,, ControlID							; gets name of control under mouse
	WinGetTitle, WindowTitle, ahk_id %ControlID%		; gets title of window under mouse
	if (hwnd = "Static1")  or (hwnd = "Static2") or (hwnd = "Static12") or (hwnd = "Static13") or (hwnd = "Static14") or (hwnd = "Static15") or (hwnd = "Static16") or (hwnd = "Static17") or (hwnd = "Static18") or (hwnd = "Static19") or (hwnd = "Static20") or (hwnd = "Static21") or (hwnd = "Button1")  or !(WindowTitle = "ShutdownWindow")
	{
		GuiControl, Hide, BubbleWindow					; hides bubble tip window
		GuiControl, Default: -Redraw, %ButtonMouseOn%Dwn	; prevents redrawing button until it is loaded
		GuiControl, Default: -Redraw, %ButtonMouseOn%Hvr	; prevents redrawing button until it is loaded
		GuiControl, Default: +Redraw, %ButtonMouseOn%	; redraws button
		MouseOnButton = 0								; mouse is neither on any GUI button...
		ButtonMouseOn =									; ...nor is any GUI button in the down position
		MidClick = 0									; mouse button is not in the down position
		break											; breaks out of main loop
	}
	if A_Index = 1										; if first instance of loop
		Sleep, 400										; initial delay is applied
	TransAmount += 30									; increases opacity level by 30, range available is 0 to 255
	if(TransAmount > 255)								; when the increments of 30 surpass 255 (full opacity)
		TransAmount = 255								; opacity is set to 255 (full opacity)
	WinSet, TransColor, 0x008000 %TransAmount%, BubbleWindow	; applies to GUI here in %TransAmount%
	GuiControl, BubbleWindow: Show, MyPic%BubbleNumber%	; shows picture control with applied transparency
	Gui, BubbleWindow: +AlwaysOnTop						; sets bubble window always on top
	if(BubbleNumber=1)									; if bubble window 1 is the chosen window
	{
		GuiControl, BubbleWindow: Show, MyText1			; shows "Stand By" bubble window title text
		GuiControl, BubbleWindow: Show, MyText2			; shows "Stand By" bubble window description text
	}
	if(BubbleNumber=2)									; if bubble window 2 is the chosen window
	{
		GuiControl, BubbleWindow: Show, MyText3			; shows "Turn Off" bubble window title text
		GuiControl, BubbleWindow: Show, MyText4			; shows "Turn Off" bubble window description text
	}
	if(BubbleNumber=3)									; if bubble window 3 is the chosen window
	{
		GuiControl, BubbleWindow: Show, MyText5			; shows "Restart" bubble window title text
		GuiControl, BubbleWindow: Show, MyText6			; shows "Restart" bubble window description text
	}
	if (hwnd = "Static3") or (hwnd = "Static4") or (hwnd = "Static5") ; if mouse pointer is over "Stand By" button 1
	{
		GuiControl, BubbleWindow: Hide, MyPic2			; hides bubble-tip image 2
		GuiControl, BubbleWindow: Hide, MyText3			; hides bubble-tip title text 2
		GuiControl, BubbleWindow: Hide, MyText4			; hides bubble-tip description text 2
		GuiControl, BubbleWindow: Hide, MyPic3			; hides bubble-tip image 3
		GuiControl, BubbleWindow: Hide, MyText5			; hides bubble-tip title text 3
		GuiControl, BubbleWindow: Hide, MyText6			; hides bubble-tip description text 3
	}
	if (hwnd = "Static6") or (hwnd = "Static7") or (hwnd = "Static8") ; if mouse pointer is over "Turn Off" button 2
	{
		GuiControl, BubbleWindow: Hide, MyPic1			; hides bubble-tip image 1
		GuiControl, BubbleWindow: Hide, MyText1			; hides bubble-tip title text 1
		GuiControl, BubbleWindow: Hide, MyText2			; hides bubble-tip description text 1
		GuiControl, BubbleWindow: Hide, MyPic3			; hides bubble-tip image 3
		GuiControl, BubbleWindow: Hide, MyText5			; hides bubble-tip title text 3
		GuiControl, BubbleWindow: Hide, MyText6			; hides bubble-tip description text 3
	}
	if (hwnd = "Static9") or (hwnd = "Static10") or (hwnd = "Static11") ; if mouse pointer is over "Restart" button 3
	{
		GuiControl, BubbleWindow: Hide, MyPic1			; hides bubble-tip image 1
		GuiControl, BubbleWindow: Hide, MyText1			; hides bubble-tip title text 1
		GuiControl, BubbleWindow: Hide, MyText2			; hides bubble-tip description text 1
		GuiControl, BubbleWindow: Hide, MyPic2			; hides bubble-tip image 2
		GuiControl, BubbleWindow: Hide, MyText3			; hides bubble-tip title text 2
		GuiControl, BubbleWindow: Hide, MyText4			; hides bubble-tip description text 2
	}
	if(TransAmount = 255)								; if full opacity is reached
	{
		TransAmount = 0									; opacity is set back to 0 for next round
		break											; breaks out of loop
	}
	sleep, 30											; fade-in time increments between loops
}
return

MouseMove(wParam, lParam, msg, hwnd) 							; mouse-over images
{
	global
	Loop, %ButtonCount%
	{
		if MouseOnButton = 0
		{
			if (hwnd = Btn1_HWND)								; mouse-over image button 1
			{
				XpHandPointer()									; changes cursor to XP hand pointer
				MouseOnButton = 1								; changes this to "yes"
				ButtonMouseOn = Btn1							; mouse is over button 1
				GuiControl, Default: -Redraw, Btn1				; hides "button 1 down" image
				GuiControl, Default: -Redraw, Btn1Dwn			; hides "button 1 down" image
				GuiControl, Default: +Redraw, Btn1Hvr			; shows "button 1 default" image
				BubbleNumber = 1								; designates bubble-tip window number
				if FadeInTips = 1								; if fade-in bubble-tips is "yes"
					gosub, MakeTrans							; makes them fade in
				else											; if fade-in bubble-tips is "no"
				{
					WinSet, TransColor, 0x008000, BubbleWindow	; applies transparency
					Gui, BubbleWindow: +AlwaysOnTop				; sets bubble-text GUI on top of main GUI
					GuiControl, BubbleWindow: Show, MyPic1		; shows picture control 1
					GuiControl, BubbleWindow: Show, MyText1		; shows text control 1
					GuiControl, BubbleWindow: Show, MyText2		; shows text control 2
				}
				break
			}
			if (hwnd = Btn2_HWND)								; mouse-over image button 2
			{
				XpHandPointer()									; changes cursor to XP hand pointer
				MouseOnButton = 1								; changes this to "yes"
				ButtonMouseOn = Btn2							; mouse is over button 2
				GuiControl, Default: -Redraw, Btn2				; hides "button 2 down" image
				GuiControl, Default: -Redraw, Btn2Dwn			; hides "button 2 down" image
				GuiControl, Default: +Redraw, Btn2Hvr			; shows "button 2 default" image
				BubbleNumber = 2								; designates bubble-tip window number
				if FadeInTips = 1								; if fade-in bubble-tips is "yes"
					gosub, MakeTrans							; makes them fade in
				else											; if fade-in bubble-tips is "no"
				{
					WinSet, TransColor, 0x008000, BubbleWindow	; applies transparency
					Gui, BubbleWindow: +AlwaysOnTop				; sets bubble-text GUI on top of main GUI
					GuiControl, BubbleWindow: Show, MyPic2		; shows picture control 2
					GuiControl, BubbleWindow: Show, MyText3		; shows text control 3
					GuiControl, BubbleWindow: Show, MyText4		; shows text control 4
				}
				break
			}
			if (hwnd = Btn3_HWND)								; mouse-over image button 3 (does not apply to Logoff window, only Shutdown)
			{
				XpHandPointer()									; changes cursor to XP hand pointer
				MouseOnButton = 1								; changes this to "yes"
				ButtonMouseOn = Btn3							; mouse is over button 3
				GuiControl, Default: -Redraw, Btn3				; hides "button 3 down" image
				GuiControl, Default: -Redraw, Btn3Dwn			; hides "button 3 down" image
				GuiControl, Default: +Redraw, Btn3Hvr			; shows "button 3 default" image
				BubbleNumber = 3								; designates bubble-tip window number
				if FadeInTips = 1								; if fade-in bubble-tips is "yes"
					gosub, MakeTrans							; makes them fade in
				else											; if fade-in bubble-tips is "no"
				{
					WinSet, TransColor, 0x008000, BubbleWindow	; applies transparency
					Gui, BubbleWindow: +AlwaysOnTop				; sets bubble-text GUI on top of main GUI
					GuiControl, BubbleWindow: Show, MyPic3		; shows picture control 3
					GuiControl, BubbleWindow: Show, MyText5		; shows text control 5
					GuiControl, BubbleWindow: Show, MyText6		; shows text control 6
				}
				break
			}
		gosub, HideBubbleWindow									; hides bubble-tip window
		}
	}
	if (hwnd != %ButtonMouseOn%_HWND) and (hwnd != %ButtonMouseOn%Hvr_HWND) and (hwnd != %ButtonMouseOn%Dwn_HWND) and (hwnd != ShutdownWindow) ; not over buttons or window
	{
		gosub, HideBubbleWindow									; hides bubble-tip window
		GuiControl, Default: -Redraw, %ButtonMouseOn%Dwn		; hides "button down" image
		GuiControl, Default: -Redraw, %ButtonMouseOn%Hvr		; hides "button hover" image
		GuiControl, Default: +Redraw, %ButtonMouseOn%			; redraws button
		MouseOnButton = 0										; mouse is neither on any GUI button...
		ButtonMouseOn =											; ...nor is any GUI button in the down position
		MidClick = 0											; mouse button is not in the down position
	}
}
return
