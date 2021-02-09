CurrentBuildDate = February 01, 2021												; current date which displays in About msgbox

#SingleInstance, force																; forces new instance of script
#Persistent																			; keeps script active
#NoTrayIcon																			; hides tray icon
SetWorkingDir %A_ScriptDir%															; sets script directory as working directory
OnExit, OnExitCommand																; if script exits by any method, OnExitCommand subroutine is run

Process, Close, XP_Shutdown.exe														; terminates this process
Process, Close, XP_Logoff.exe														; terminates this process

IniRead, Language, misc\options.ini, MainOptions, Language, English					; gets chosen language, "English" default
IniRead, DesktopChange, misc\options.ini, MainOptions, DesktopChange, 0				; gets "change desktop" information, "0" default
IniRead, FadeInTips, misc\options.ini, MainOptions, FadeInTips, 0					; gets "fade-in bubble-tips" information, "0" default
IniRead, FadeTime, misc\options.ini, MainOptions, FadeTime, 4						; gets number of seconds of desktop fade feature's duration, "4" default
IniRead, JapaneseSize, misc\options.ini, MainOptions, JapaneseSize, 0				; gets checkbox number for "Original Size", "0" default
#Include, misc\functions.ahk														; gets shared program functions
gosub, PopulateTexts																; assigns variable contents to each control's text (Text14 to Text18)

Gui, Color, black																	; behind gui background image, makes 1px black border
Gui, Add, Picture, x1 y1 w313 h198, images\Bitmap20142.jpg							; exact JPG copy of Windows background BMP image
Gui, Add, Picture, x266 y2 w48 h40, images\Bitmap20141.png							; exact PNG copy of Windows logo BMP image
Gui, Font, cWhite s14 bold, Microsoft Sans Serif									; white size 14 bold Microsoft Sans Serif font
Gui, Add, Text, x10 y12 w290 +BackgroundTrans vOptionsText, %Text14%				; adds white "Options" text in chosen language
Gui, Font, cWhite s9 bold, Microsoft Sans Serif										; size 9 bold font
Gui, Add, Text, x0 y50 w165 +BackgroundTrans Right vLanguageChoice, %Text15%`:		; adds "choose language" menu 
Gui, Font																			; clears font back to default
Gui, Add, DropDownList, x170 y50 w100 Choose%Text24% gChangeLanguage vLanguage, Afrikaans|Albanian|Amharic|Arabic|Armenian|Azerbaijani|Basque|Belarusian|Bengali|Bosnian|Bulgarian|Catalan|Cebuano|Chichewa|Chinese|Corsican|Croatian|Czech|Danish|Dutch|English|Esperanto|Estonian|Filipino|Finnish|French|Frisian|Galician|Georgian|German|Greek|Gujarati|Haitian|Hausa|Hawaiian|Hebrew|Hindi|Hmong|Hungarian|Icelandic|Igbo|Indonesian|Irish|Italian|Japanese|Javanese|Kannada|Kazakh|Khmer|Kinyarwanda|Klingon|Korean|Kurdish|Kyrgyz|Lao|Latin|Latvian|Lithuanian|Luxembourgish|Macedonian|Malagasy|Malay|Malayalam|Maltese|Maori|Marathi|Mongolian|Myanmar|Nepali|Norwegian|Odia|Pashto|Persian|Polish|Portugese|Punjabi|Romanian|Russian|Samoan|ScotsGaelic|Serbian|Sesotho|Shona|Sindhi|Sinhala|Slovak|Slovenian|Somali|Spanish|Sundanese|Swahili|Swedish|Tajik|Tamil|Tatar|Telugu|Thai|Turkish|Turkmen|Ukrainian|Urdu|Uyghur|Uzbek|Vietnamese|Welsh|Xhosa|Yiddish|Yoruba|Zulu
Gui, Font, cWhite s9 bold, Microsoft Sans Serif									; size 9 bold font
Gui, Add, Text, x0 y70 w165 +BackgroundTrans Right vDesktopFxChoice, %Text16%`:		; adds "Desktop FX" checkbox text
Gui, Add, Checkbox, x170 y70 w12 h12 gChangeLanguage vDesktopChange Checked%DesktopChange%	; adds "Desktop FX" checkbox
Gui, Add, Text, x0 y90 w165 +BackgroundTrans Right vTooltipFxChoice, %Text17%`:		; adds "Tooltip FX" checkbox text
Gui, Add, Checkbox, x170 y90 w12 h12 gClick vFadeInTips Checked%FadeInTips%			; adds "Tooltip FX" checkbox

Gui, Add, Text, x0 y110 w165 +BackgroundTrans Right vJapaneseSizeChoice Hidden, 実際のXPに基づいた仕様`:	; adds "Original Size" checkbox text in Japanese
Gui, Add, Checkbox, x170 y110 w12 h12 gClick vJapaneseSize Hidden Checked%JapaneseSize%		; adds "Original Size" checkbox
gosub, CheckIfJapanese																; checks if Japanese is the chosen language

Gui, Add, Text, x210 y70 w80 +BackgroundTrans Right, seconds						; adds "seconds" as suffix to dropdown menu
Gui, Font																			; clears font back to default

if DesktopChange = 1																; if "Desktop FX" is checked
	SecondsMenuState =																; dropdown menu for "seconds" is enabled
if DesktopChange = 0																; if "Desktop FX" is not checked
	SecondsMenuState = Disabled														; dropdown menu for "seconds" is disabled
Gui, Add, DropDownList, x186 y68 w50 gClick Choose%FadeTime% vFadeTime %SecondsMenuState%, 1|2|3|4|5	; adds dropdown menu for "seconds"
Gui, Add, Button, x100 y130 w120 h21 gCheckForUpdates vUpdateButton -Theme, Check for Updates					; adds "Check for Updates" button, checks server for "LatestVersion.txt"

Gui, Add, Button, x12 y173 w20 h21 gAbout -Theme, `?										; adds "About" button
Gui, Add, Button, x224 y173 w84 h21 gSave Default vSaveText -Theme, %Text18%				; adds Save button, makes default so "enter" triggers it
Gui, Font, s9 Bold																	; size 9 bold font
Gui, Add, Text, cWhite x50 y165 w170 h21 +BackgroundTrans vWebsiteLink, %Text26%`:	; "My Website" text in chosen language
Gui, Font, Underline																; size 9 bold underlined
Gui, Add, Text, cWhite x50 y180 w170 h21 +BackgroundTrans gLink, www.weedtrek.ca
SysGet, MainMonitorNumber, MonitorPrimary											; gets primary monitor id
SysGet, MainMonitor, Monitor, %MainMonitorNumber%									; gets dimensions of primary monitor
Yposition := Round(MainMonitorBottom / 4)											; divides height by 4 to get Y position
Gui, +AlwaysOnTop +ToolWindow														; always on top unless Weed Trek link is clicked
SoundPlay, misc\pop.wav																; plays pop sound
Gui, Show, y%Yposition% w315 h200, %Text25%											; uses calculated "y" position and selected language in title
XpArrowPointer()																	; loads XP arrow pointer
return

CheckForUpdates:
SoundPlay, misc\click.wav																					; plays click sound
Gui, +OwnDialogs																							; ensures msgboxes are on top of the menu window
FileDelete, %A_Temp%\LatestVersion.txt																		; deletes any existing LatestVersion.txt file
URLDownloadToFile, http://weedtrek.ca/software/LatestVersion.txt, %A_Temp%\LatestVersion.txt				; downloads latest version file from server
if Errorlevel																								; if something goes wrong
{
	MsgBox, Could not check for newest version.`nPlease try again.											; prompts user to try again, proceeds no further
	return
}
FileRead, LatestVersion, %A_Temp%\LatestVersion.txt															; if no problems, reads the version number
Loop, read, misc\info.txt																					; reads information text file in "misc" folder
	LastLine := A_LoopReadLine																				; finds last line of text file
CurrentVersion := SubStr(LastLine, 2, 5)																	; extracts current version number from last line
if(CurrentVersion < LatestVersion)																			; if "current" is older than "latest"e
{
	MsgBox,4,, Latest Version`: %LatestVersion%`nYour Version`: %CurrentVersion%`nDownload newer version`?	; prompts user to download newer version
	ifMsgBox, Yes																							; if yes
	{
		FileSelectFolder, DownloadLocation,, 0, Select where to save the update package.					; prompts user to choose location
		if (ErrorLevel != 1)																				; if no error at this point
		{
			Gui, +OwnDialogs																				; makes sure splashtext is on top of menu
			SplashTextOn, 600, 200,, `nDownloading Update...												; shows "downloading update" text
			URLDownloadToFile, http://weedtrek.ca/software/XP_shutdown.zip, %DownloadLocation%\XP_Shutdown.zip	; downloads updated software
			if (ErrorLevel = 1)																				; if there is a problem...
			{
				SplashTextOff																				; "downloading update" text turns off
				MsgBox, There was a problem.`nPlease try saving again in`na different location.				; user is prompted to try something else
				return
			}
		}
		else																								; if user presses "cancel" or there was a problem
			return																							; nothing happens
		if !FileExist(DownloadLocation "\XP_Shutdown.zip")													; if the downloaded file doesn't exist, maybe problem
		{
			SplashTextOff																					; "downloading update" text turns off
			MsgBox, There was a problem.`nPlease try saving again in`na different location.					; user is prompted to try something else
			return																								
		}
		SplashTextOff																						; "downloading update" text turns off after success
		SoundPlay, misc\ba-ding.wav																			; plays ba-ding sound
		MsgBox, File successfully downloaded to`:`n%DownloadLocation%\XP_Shutdown.zip						; success message
	}
	ifMsgBox, No																							; if user presses "no"
		return																								; nothing happens
}
if(CurrentVersion = LatestVersion) or (CurrentVersion > LatestVersion)										; if version numbers match or user has higher number
	MsgBox, Latest Version`: %LatestVersion%`nYour Version`: %CurrentVersion%`nNo new updates available.	; no updates available
return

ChangeLanguage:
Gui, Submit, NoHide														; submits contents of all controls for instant change
SoundPlay, misc\click.wav												; plays click sound
gosub, PopulateTexts													; assigns variable contents to each control's text (Text14 to Text18)
GuiControl,, OptionsText, %Text14%										; "Options" text
GuiControl,, LanguageChoice, %Text15%`:									; "Language" text
GuiControl,, DesktopFxChoice, %Text16%`:								; "Desktop FX" text
GuiControl,, TooltipFxChoice, %Text17%`:								; "Tooltip FX" text
GuiControl,, SaveText, %Text18%											; "Save" button text
GuiControl,, Text24, %Language%`:										; menu position number for initial display in dropdown menu
gosub, CheckIfJapanese													; check if "Japanese" is selected language
GuiControl,, WebsiteLink, %Text26%`:									; "My Website" text
Gui, Show,, %Text25%													; "Window Title" text
if DesktopChange = 0													; if Desktop FX is unchecked (no fade)
	GuiControl, Disable, FadeTime										; fade-time (in seconds) dropdown menu is disabled
if DesktopChange = 1													; if Desktop FX is checked (active fade)
	GuiControl, Enable, FadeTime										; fade-time (in seconds) dropdown menu is enabled
return
PopulateTexts:
Loop, 33																; reads INI file for keys' contents
{
	IniRead, Text%A_Index%, misc\options.ini, %Language%, key%A_Index%	; reads each key under chosen language and assigns to variable
	StringReplace, Text%A_Index%, Text%A_Index%, ||, `n, All			; replaces pipe-delimiters with line breaks (for accuracy if included)
}
return
CheckIfJapanese:
if Language = Japanese													; if Language is Japanese...
{
	GuiControl, Show, JapaneseSizeChoice								; show text for "Original Size"
	GuiControl, Show, JapaneseSize										; show checkbox for "Original Size" choice
}
else
{
	JapaneseSize = 0													; disables original Japanese sizing
	GuiControl, Hide, JapaneseSizeChoice								; hides text for "Original Size"
	GuiControl, Hide, JapaneseSize										; hides checkbox for "Original Size" choice
}
return

About:
Gui, +OwnDialogs														; MsgBox won't hide behind window
SoundPlay, misc\click.wav												; plays click sound
Loop, read, misc\info.txt												; reads information text file in "misc" folder
	LastLine := A_LoopReadLine											; finds last line of text file
VersionNumber := SubStr(LastLine, 2, 5)									; extracts version number from last line, minus the "v"
MsgBox, 4,, XP Shutdown and Logoff Menus`nby Aaron Bewza`n`nVersion`: %VersionNumber% `(beta`)`n%CurrentBuildDate%`n`nOpen history text file`? ; prompt to open history text file
ifMsgBox Yes															; if yes...
{
	SoundPlay, misc\click.wav											; plays click sound
	Gui, -AlwaysOnTop													; removes "always on top" status from main GUI and msgbox so text file can be unobscured
    Run, misc\info.txt													; history text file is opened
}
ifMsgBox No																; if no...
	SoundPlay, misc\click.wav											; plays click sound and msgbox closes
return

Save:
Gui, Submit																; submits contents of all controls
SoundPlay, misc\click.wav, Wait											; plays click sound
IniWrite, %Language%, misc\options.ini, MainOptions, Language			; stores language settings
IniWrite, %DesktopChange%, misc\options.ini, MainOptions, DesktopChange	; stores desktop effects settings
IniWrite, %FadeInTips%, misc\options.ini, MainOptions, FadeInTips		; stores bubble-tip effects settings
IniWrite, %FadeTime%, misc\options.ini, MainOptions, FadeTime			; stores number of seconds for fade duration
IniWrite, %JapaneseSize%, misc\options.ini, MainOptions, JapaneseSize	; stores if original Japanese size is used when matching language
ExitApp																	; exits menu

Link:
Run, http://weedtrek.ca													; opens Weed Trek official site
Gui, -AlwaysOnTop														; removes "AlwaysOnTop" status from GUI so it doesn't show over website
SoundPlay, misc\click.wav, Wait											; plays click sound
Return

!F4::																	; ALT+F4 by itself will not work correctly
Esc::																	; escape key
Cancel:																	; cancel button
GuiClose:																; if script is closed with the toolwindow "x"
SoundPlay, misc\click.wav, Wait											; plays click sound
OnExitCommand:															; everything below runs if script exits by any means
RemoveCustomPointers()													; restores system default pointers
ExitApp																	; exits script

Click:
SoundPlay, misc\click.wav, Wait											; plays click sound
return

MakeTrans:																; fake subroutines to avoid errors while loading "misc\functions.ahk"...
HideBubbleWindow:														; ...as Logoff and Shutdown only use it for bubble tip windows
return
