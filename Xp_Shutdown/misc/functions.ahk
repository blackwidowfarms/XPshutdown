
; functions

XpArrowPointer()											; calls XP arrow pointer
{
	XpArrowPointer := DllCall("LoadCursorFromFile", Str, A_ScriptDir "\images\Cursor_1.cur")		
	DllCall("SetSystemCursor", Uint, XpArrowPointer, Int, 32512)	; applies as default
}

XpHandPointer()												; calls XP hand pointer
{
	XpHandPointer := DllCall("LoadCursorFromFile", Str, A_ScriptDir "\images\Cursor_15.cur")
    DllCall("SetSystemCursor", Uint, XpHandPointer, Int, 32512)	; applies as default only while over certain controls
}

RemoveCustomPointers()											; change to default arrow/hand pointers
{
	DllCall("SystemParametersInfo", UInt, 0x57, UInt, 0, UInt, 0, UInt, 0)
}

LoadCustomFonts()											; adds temporary fonts from "misc" folder
{
	DllCall("GDI32.DLL\AddFontResourceEx", Str, A_ScriptDir "\misc\XpTahoma.ttf", UInt, (FR_PRIVATE:=0x10), Int, 0)	; XpTahoma.ttf
	DllCall("GDI32.DLL\AddFontResourceEx", Str, A_ScriptDir "\misc\Klingon.ttf", UInt, (FR_PRIVATE:=0x10), Int, 0)	; Klingon.ttf
}

RemoveCustomFonts()											; removes temporary fonts
{
	DllCall("GDI32.DLL\RemoveFontResourceEx",Str, A_ScriptDir "\misc\XPtahoma.ttf", UInt, (FR_PRIVATE:=0x10), Int, 0)	; XpTahoma.ttf
	DllCall("GDI32.DLL\AddFontResourceEx", Str, A_ScriptDir "\misc\Klingon.ttf", UInt, (FR_PRIVATE:=0x10), Int, 0)	; Klingon.ttf
}

AddGraphicBtn(Btn_X, Btn_Y, Btn_H, Btn_W, Btn_Identifier, Btn_Up, Btn_Hvr, Btn_Dwn)	; add image buttons
{
	global
	Gui, Default: Add, Picture
		, +AltSubmit %Btn_X% %Btn_Y% %Btn_H% %Btn_W% gNothing v%Btn_Identifier%Hvr hwnd%Btn_Identifier%Hvr_hwnd
		, %Btn_Hvr%											; hover-state image
	Gui, Default: Add, Picture
		, +AltSubmit %Btn_X% %Btn_Y% %Btn_H% %Btn_W% gNothing v%Btn_Identifier%Dwn hwnd%Btn_Identifier%Dwn_hwnd
		, %Btn_Dwn%											; down-state image
	Gui, Default: Add, Picture
		, +AltSubmit %Btn_X% %Btn_Y% %Btn_H% %Btn_W% gNothing v%Btn_Identifier% hwnd%Btn_Identifier%_hwnd
		, %Btn_Up%											; default-state image
	return
}

MouseLDown(wParam, lParam, msg, hwnd)						; mouse-down on images
{
	global
	MidClick = 1											; mouse button is in process of clicking down
	if (hwnd = %ButtonMouseOn%Hvr_HWND)						; if mouse is over a button's hover-image
	{
		Gui, BubbleWindow: +AlwaysOnTop						; sets bubble texts to be on top of main GUI
		GuiControl, Default: -Redraw, %ButtonMouseOn%Hvr	; hover-state button remains underneath
		GuiControl, Default: -Redraw, %ButtonMouseOn%		; default-state button remains underneath
		GuiControl, Default: +Redraw, %ButtonMouseOn%Dwn	; down-state button is redrawm
	}
	MidClick = 0											; mouse button is not clicking down
	GetKeyState, MouseLBtnState, LButton, P					; detects state of mouse button
	if MouseLBtnState = U									; if mouse button up, click has not completed
		MouseLUp("", "", "", %hwnd%)						; does not register the click
	Gui, IconImage: +AlwaysOnTop							; if bubble-tip window is active, it needs to stay on top or lose focus
	return
}

MouseLUp(wParam, lParam, msg, hwnd)							; mouse-up on images
{
	global
	MidClick = 1											; if mouse button is in process of clicking down
	if (hwnd = %ButtonMouseOn%Dwn_HWND)						; if mouse is over a button's down-image
		gosub, %ButtonMouseOn%_Up							; runs subroutine associated with chosen button on mouse-up
	MidClick = 0											; mouse button is not clicking down
	return
}

PreventRepeating() ; stops CONTROL from repeating and flickering the "Shutdown w/Updates" window
{
	Static PrevRep := Object()
	if PrevRep[A_ThisHotkey]
		Exit
	if InStr(A_ThisHotkey,"Up")
	{
		PrevRep[SubStr(A_ThisHotkey,1,-3)] := False
		Exit
	}	
	PrevRep[A_ThisHotkey] := True
	Hotkey, %A_ThisHotkey%%A_Space%Up,%A_ThisHotkey%
}
