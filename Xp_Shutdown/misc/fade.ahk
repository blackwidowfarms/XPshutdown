#SingleInstance, force
#NoTrayIcon
IniRead, FadeTime, misc\options.ini, MainOptions, FadeTime, 4			; gets number of seconds of desktop fade feature's duration, 4 seconds default
FadeTime := (FadeTime *1000)											; converts to milliseconds
if WinExist("LogoffWindow") or WinExist("ShutdownWindow")				; prevents user from cornering themselves by running this fade function by itself
{
	hBM := FsGrayscale(X,Y,,,W,H)
	hFG := DllCall("CreateBitmap","Int",1,"Int",1,"Int",1,"Int",32,"PtrP",0x10000000,"Ptr") ; 0x79000000 was original
	Gui, Bkg: New, +ToolWindow -Caption +E0x8000000 hwndBackgroundBitmap 					; +LastFound +AlwaysOnTop interfered
	Gui, Bkg: Margin, 0, 0																	; no margins
	Gui, Bkg: Add, Picture,, HBITMAP:%hBM%													; adds original greyscale bitmap of background?
	Gui, Bkg: Add, Picture,xp yp wp hp BackgroundTrans, HBITMAP:%hFG%						; adds the one which I presume fades?
	Gui, Bkg: Show, x%X% y%Y% w%W% h%H% Hide, BackgroundBitmap								; initially hidden
	DllCall("AnimateWindow", "Ptr", BackgroundBitmap, "Int", FadeTime, "Int", 0xA0000)		; 4000ms fade time matches XP
}
else
	ExitApp
return

FsGrayscale(ByRef X1:=0, ByRef Y1:=0, ByRef X2:=0, ByRef Y2:=0, ByRef W:=0, ByRef H:=0)		; makes greyscale screenshot
{
	Local
	VarSetCapacity(WININFO,62), NumPut(62,WININFO,"Int"), PW:=&WININFO
	DllCall("GetWindowInfo", "Ptr",hWnd:=DllCall("GetDesktopWindow", "Ptr"), "Ptr",&WININFO)
	Loop, Parse, % "X1.Y1.X2.Y2.W.H",.
	%A_LoopField% := (A_Index<5 ? NumGet(PW+0,A_Index*4,"Int") : A_Index=5 ? X2-X1 : Y2-Y1)

	tBM := DllCall("CopyImage", "Ptr"
	   , DllCall( "CreateBitmap", "Int",1, "Int",1, "Int",0x1, "Int",8, "Ptr",0, "Ptr")
	   , "Int",0, "Int",W, "Int",H, "Int",0x2008, "Ptr")

	tDC := DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
	DllCall("DeleteObject", "Ptr",DllCall("SelectObject", "Ptr",tDC, "Ptr",tBM, "Ptr"))
	Loop % (255, n:=0x000000, VarSetCapacity(RGBQUAD256,256*4,0))
		Numput(n+=0x010101, RGBQUAD256, A_Index*4, "Int")
	DllCall("SetDIBColorTable", "Ptr",tDC, "Int",0, "Int",256, "Ptr",&RGBQUAD256)

	sDC := DllCall("GetDC", "Ptr",hWnd, "Ptr")
	DllCall("BitBlt", "Ptr",tDC, "Int",0,  "Int",0,  "Int",W, "Int",H
		, "Ptr",sDC, "Int",X1, "Int",Y1, "Int",0x00CC0020)

	Return (tBM, DllCall("ReleaseDC", "Ptr",hWnd, "Ptr",sDC),  DllCall("DeleteDC", "Ptr",tDC))
}
return
