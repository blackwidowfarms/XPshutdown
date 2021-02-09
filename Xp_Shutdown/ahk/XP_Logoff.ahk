#SingleInstance, force														; forces new instance of script
#Persistent																	; keeps script active
#NoTrayIcon																	; hides tray icon
SetBatchLines, -1															; runs at full speed
SetWorkingDir %A_ScriptDir%													; sets script directory as working directory
OnExit, OnExitCommand														; if script exits by any method, OnExitCommand subroutine is run
#Include, misc\functions.ahk												; gets shared program functions

Process, Close, XP_Shutdown.exe												; terminates this process
Process, Close, XP_Settings.exe												; terminates this process

IniRead, Language, misc\options.ini, MainOptions, Language, English			; gets chosen language, "English" if error
IniRead, DesktopChange, misc\options.ini, MainOptions, DesktopChange, 0		; gets "change desktop" information, "No" if error
IniRead, FadeInTips, misc\options.ini, MainOptions, FadeInTips, 0			; gets "fade-in bubble-tips" information, "No" if error
IniRead, JapaneseSize, misc\options.ini, MainOptions, JapaneseSize, 0		; if Japanese, checkbox for "Original Size" saved here, "0" if error
if DesktopChange = 1														; if "Desktop FX" is "Yes"...
	gosub, TurnOnHotkeys													; disables keys and mouse clicks, makes "ding" sound instead
Loop, 33																	; reads INI file for keys' contents
{
	IniRead, Text%A_Index%, misc\options.ini, %Language%, key%A_Index%		; reads each key and assigns to variable
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
Gui, Default: Add, Picture, x1 y1 w%BkgWidth% h%BkgHeight%, images\Bitmap20142.jpg			; exact JPG copy of Windows background BMP image
Gui, Default: Add, Picture, x%FlagXpos% y%FlagYpos% w%FlagWidth% h%FlagHeight%, images\Bitmap20141.png			; exact PNG copy of Windows logo BMP image (smoothest)
AddGraphicBtn("x" Button1xPos,"y" ButtonsYpos,"h" ButtonsHeight,"w" ButtonsWidth,"Btn1","images\SwitchUser.bmp","images\SwitchUserHover.bmp","images\SwitchUserDown.bmp")	; loads all 3 states of "Switch User" button
AddGraphicBtn("x" Button2xPos,"y" ButtonsYpos,"h" ButtonsHeight,"w" ButtonsWidth,"Btn2","images\LogOff.bmp","images\LogOffHover.bmp","images\LogOffDown.bmp")				; loads all 3 states of "Log Off" button
ButtonCount = 2																; there are 2 buttons
MouseOnButton = 0															; mouse is neither on any button...
ButtonMouseOn =																; ...nor is any button in the down position
MidClick = 0																; mouse button is not in the down position

LoadCustomFonts()															; loads custom fonts from "misc" folder

Gui, Default: Font, cWhite s%Text28% %FontWeight%, %Text27%					; sets font type and size for main text, bold (norm for Japanese)
Gui, Default: Add, Text, x10 y12 w290 +BackgroundTrans, %Text8%				; "Log Off Windows" main text
Gui, Default: Font, s%Text30% bold, %Text29%								; sets font type and size for buttons, bold
Gui, Default: Add, Text, x%Text1xpos% y%TextYpos% w%Text1width% +BackgroundTrans Center, %Text9%		; adds "Switch User" text
Gui, Default: Add, Text, x%Text2xpos% y%TextYpos% w%Text2width% +BackgroundTrans Center, %Text10%	; adds "Log Off" text
Loop, 3
	GuiControl, Default: Hide, Btn%A_Index%Hvr								; hides all 3 "hover-state" button images
Loop, 3
	GuiControl, Default: Hide, Btn%A_Index%Dwn								; hides all 3 "down-state" button images
SysGet, MainMonitorNumber, MonitorPrimary									; gets primary monitor id
SysGet, MainMonitor, Monitor, %MainMonitorNumber%							; gets dimensions of primary monitor
Yposition := Round(MainMonitorBottom / 4)									; divides height by 4 to get Y position of main GUI

; ---Bubble-tip main hidden GUI--------------------------------------------------------------------------------------------------------------|
TransAmount = 0
Gui, BubbleWindow: new														; creates new GUI to work on, BubbleWindow
Gui, BubbleWindow: +LastFound -Caption +ToolWindow +AlwaysOnTop +E0x20		; no titlebar or taskbar button, topmost and click-through
Gui, BubbleWindow: Color, 0x008000											; sets BubbleWindow background color something unique
WinSet, TransColor, 0x008000 %TransAmount% 									; sets transparent color the same as unique GUI color
Gui, BubbleWindow: Show, y%Yposition% w800 h285 NoActivate, BubbleWindow	; shows bubble-tip window without activating it
; ---Bubble-tip window 1---------------------------------------------------------------------------------------------------------------------|
Gui, BubbleWindow: Add, Picture, x%Bubble1xpos% y%BubblesYpos% w322 h-1 +BackgroundTrans vMyPic1 Hidden, images\%Text22%.png	; bubble image 1
Gui, BubbleWindow: Font, s%Text31% bold, %Text29%							; bold font
Gui, BubbleWindow: Add, Text, x%BubbleText1xpos% y%BubbleTitlesYpos% w302 +BackgroundTrans vMyText1 Hidden, %Text9%	; "Switch User" bubble text title
Gui, BubbleWindow: Font, s%Text31% norm, %Text29%							; normal font
Gui, BubbleWindow: Add, Text, x%BubbleText1xpos% y%BubbleTextsYpos% w302 r6 +BackgroundTrans vMyText2 Hidden, %Text11%	; "Switch User" bubble text description
; ---Bubble-tip window 2---------------------------------------------------------------------------------------------------------------------|
Gui, BubbleWindow: Add, Picture, x%Bubble2xpos% y%BubblesYpos% w322 h-1 +BackgroundTrans vMyPic2 Hidden, images\%Text23%.png	; bubble image 2
Gui, BubbleWindow: Font, s%Text31% bold, %Text29%							; bold font
Gui, BubbleWindow: Add, Text, x%BubbleText2xpos% y%BubbleTitlesYpos% w302 +BackgroundTrans vMyText3 Hidden, %Text10%	; "Log Off" bubble text title
Gui, BubbleWindow: Font, s%Text31% norm, %Text29%							; normal font
Gui, BubbleWindow: Add, Text, x%BubbleText2xpos% y%BubbleTextsYpos% w302 r6 +BackgroundTrans vMyText4 Hidden, %Text12%	; "Log Off" bubble text description
; ---Bubble-tip window 3---------------------------------------------------------------------------------------------------------------------|
Gui, Default: -Caption +ToolWindow +AlwaysOnTop								; no titlebar, no taskbar button, always on top
Gui, Default: Show, y%Yposition% w%WindowWidth% h%WindowHeight%, LogoffWindow	; distance from top, calculated earlier
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

OnMessage(0x200, "MouseMove")							; detects when mouse is moved
OnMessage(0x201, "MouseLDown")							; detects when left mouse button is clicked down
OnMessage(0x202, "MouseLUp")							; detects when left mouse button is released
SetTimer, CheckHoverDesktop, 50							; checks if mouse over desktop 20 times per second
return

CheckHoverDesktop:										; checks if the mouse is over program window or desktop.
MouseGetPos,,,, hwnd									; gets mouse position
if DesktopChange = 1									; if "Desktop FX" option is set to "Yes"...
{
	if (hwnd = "Button1") or (hwnd = "Static1") or (hwnd = "Static3") or (hwnd = "Static4") or (hwnd = "Static5") or (hwnd = "Static6") or (hwnd = "Static7") or (hwnd = "Static8") or (hwnd = "Static9") or (hwnd = "Static10") or (hwnd = "Static11")
		gosub, TurnOffHotkeys							; enables keys and mouse clicks if mouse is in any of above controls
	else
		gosub, TurnOnHotkeys							; disables keys and mouse clicks, makes "ding" sound instead
}
return

TurnOffHotkeys:											; enables keys and mouse clicks
Hotkeys = LButton|MButton|RButton|XButton1|XButton2|WheelUp|WheelDown|LWin|RWin|Tab|Space|Enter|Control|Alt|!Tab|^+Tab
Loop, Parse, Hotkeys, |									; uses pipe delimiter "|" as separator
Hotkey, %A_LoopField%,, Off								; key mapping suspended, so the above keys and buttons operate normally
return

TurnOnHotkeys:											; disables keys and mouse clicks, makes "ding" sound instead
Hotkeys = LButton|MButton|RButton|XButton1|XButton2|WheelUp|WheelDown|LWin|RWin|Tab|Space|Enter|Control|Alt|!Tab|^+Tab
Loop, Parse, Hotkeys, |									; uses pipe delimiter "|" as separator
Hotkey, %A_LoopField%, ding, On							; plays ding sound instead of regular key functions
return
ding:
SoundPlay, misc\ding.wav								; plays ding sound when mouse clicks out of window
return

S::														; original XP shortcut for Switch User
Btn1_up:												; mouse-up event on button 1
Run, rundll32.exe user32.dll LockWorkStation			; command for switch user
ExitApp													; exits script

L::														; original XP shortcut for Log Off
Btn2_up:												; mouse-up event on button 2
Shutdown, 0												; command for log off
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
Loop, 2
	GuiControl, BubbleWindow: Hide, MyPic%A_Index%		; hides bubble text windows
Loop, 4
	GuiControl, BubbleWindow: Hide, MyText%A_Index% 	; hides text controls	
return

Nothing:												; does nothing but fakes a gLabel for button images
return

; if Language is Japanese and "Original Size" is selected in options
OriginalJapaneseDimensions:
WindowWidth = 364			; entire menu GUI width
WindowHeight = 182			; entire menu GUI height
BkgWidth = 362				; background image width
BkgHeight = 180				; background image height
FlagXpos = 313				; windows flag X-position
FlagYpos = 1				; windows flag Y-position
FlagWidth = 46				; windows flag width
FlagHeight = 38				; windows flag height
ButtonsWidth = 39			; both buttons' widths (39 reported)
ButtonsHeight = 30			; both buttons' heights (30 reported)
ButtonsYpos = 74			; both buttons' Y-position
Button1xPos = 97			; button 1 (Switch User) X-position
Button2xPos = 232			; button 2 (Log Off) X-position
TextYpos = 110				; both buttons' text descriptions' Y-positions
Text1xpos = 48				; button 1 text description's X-position
Text2xpos = 93				; button 2 text description's X-position
Text1width = 138			; button 1 text description's width
Text2width = 315			; button 2 text description's width
BubblesYpos = 104			; both bubble windows' Y-positions
Bubble1xpos = 317			; bubble 1 X-position
Bubble2xpos = 452			; bubble 2 X-position
BubbleTitlesYpos = 135		; both bubble windows' titles Y-positions
BubbleTextsYpos = 165		; both bubble windows' description texts Y-positions
BubbleText1xpos = 329		; bubble window 1 description text X-position
BubbleText2xpos = 464		; bubble window 2 description text X-position
CancelXpos = 270			; Cancel button X-position
CancelYpos = 154			; Cancel button Y-position
FontWeight = norm			; font weight for main "Turn off computer" text
return

; if Language is not Japanese
RegularDimensions:
WindowWidth = 315			; entire menu GUI width
WindowHeight = 200			; entire menu GUI height
BkgWidth = 313				; background image width
BkgHeight = 198				; background image height
FlagXpos = 266				; windows flag X-position
FlagYpos = 2				; windows flag Y-position
FlagWidth = 48				; windows flag width
FlagHeight = 40				; windows flag height
ButtonsWidth = 33			; both buttons' widths
ButtonsHeight = 33			; both buttons' heights
ButtonsYpos = 82			; both buttons' Y-position
Button1xPos = 83			; button 1 (Switch User) X-position
Button2xPos = 198			; button 2 (Log Off) X-position
TextYpos = 120				; both buttons' text descriptions' Y-positions
Text1xpos = 0				; button 1 text description's X-position
Text2xpos = 110				; button 2 text description's X-position
Text1width = 205			; button 1 text description's width
Text2width = 210			; button 2 text description's width
BubblesYpos = 115			; both bubble windows' Y-positions
Bubble1xpos = 324			; bubble 1 X-position
Bubble2xpos = 439			; bubble 2 X-position
BubbleTitlesYpos = 146		; both bubble windows' titles Y-positions
BubbleTextsYpos = 176		; both bubble windows' description texts Y-positions
BubbleText1xpos = 334		; bubble window 1 description text X-position
BubbleText2xpos = 449		; bubble window 2 description text X-position
CancelXpos = 225			; Cancel button X-position
CancelYpos = 170			; Cancel button Y-position
FontWeight = bold			; font weight for main "Turn off computer" text
return

MakeTrans:
Loop
{
	MouseGetPos,,, ControlID							; gets name of control under mouse
	WinGetTitle, WindowTitle, ahk_id %ControlID%		; gets title of window under mouse
	if (hwnd = "Static1") or (hwnd = "Static2") or (hwnd = "Static9") or (hwnd = "Static10") or (hwnd = "Static11") or (hwnd = "Button1")  or !(WindowTitle = "LogoffWindow")
	{
		GuiControl, Hide, BubbleWindow
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
		GuiControl, BubbleWindow: Show, MyText1			; shows "Switch User" bubble window title text
		GuiControl, BubbleWindow: Show, MyText2			; shows "Switch User" bubble window description text
	}
	if(BubbleNumber=2)									; if bubble window 2 is the chosen window
	{
		GuiControl, BubbleWindow: Show, MyText3			; shows "Log Off" bubble window title text
		GuiControl, BubbleWindow: Show, MyText4			; shows "Log Off" bubble window description text
	}
	if (hwnd = "Static3") or (hwnd = "Static4") or (hwnd = "Static5") ; if mouse pointer is over "Switch User" button 1
	{
		GuiControl, BubbleWindow: Hide, MyPic2			; hides bubble-tip image 2
		GuiControl, BubbleWindow: Hide, MyText3			; hides bubble-tip title text 2
		GuiControl, BubbleWindow: Hide, MyText4			; hides bubble-tip description text 2
	}
	if (hwnd = "Static6") or (hwnd = "Static7") or (hwnd = "Static8") ; if mouse pointer is over "Log Off" button 2
	{
		GuiControl, BubbleWindow: Hide, MyPic1			; hides bubble-tip image 1
		GuiControl, BubbleWindow: Hide, MyText1			; hides bubble-tip title text 1
		GuiControl, BubbleWindow: Hide, MyText2			; hides bubble-tip description text 1
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
		gosub, HideBubbleWindow									; hides bubble-tip window
		}
	}
	if (hwnd != %ButtonMouseOn%_HWND) and (hwnd != %ButtonMouseOn%Hvr_HWND) and (hwnd != %ButtonMouseOn%Dwn_HWND) and (hwnd != LogoffWindow) ; not over buttons or window
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
