# XPshutdown
XP Shutdown and Logoff
Aaron Bewza
www.weedtrek.ca

- select main options and language settings by opening "XP_Options"
- press CONTROL to toggle "XP Shutdown w/Updates" feature in "XP_Shutdown" (almost complete)
- press and hold SHIFT to see "Hibernate" button in "XP_Shutdown"

Version History:
(Alpha)
September 2020:
v0.900 built basic menu, it was enough, so I stopped working on it
November 2020:
v0.910 when asked to, I added rough version of hover bubble text
v0.911 fine-tuned bubble-text windows, less flickering but still buggy
December 2020:
v0.912 using higher resolution bubbles made by Enger
v0.913 solved flicker on bubble-text windows, thanks mikeyww
v0.914 now using real XP buttons, thanks Millenashea for finding them
v0.915 made Log Off GUI and INI file for options to simplify things
v0.916 made Settings GUI to interact with INI file
v0.920 supports 5 languages, Millenashea made correct Japanese
v0.921 supports 12 languages, centered all texts under buttons
v0.930 supports 108 languages, also translates bubble-tip texts
v0.931 fixed Bliss wallpaper from being applied on program exit
v0.932 optimized folders, hopefully fixed bubble-tip positions
v0.933 added realtime language changes for in the options menu
(Beta)
v0.940 added background fade thanks to SKAN
v0.941 used math to align buttons correctly on both menus
v0.942 added actual XP arrow and hand pointer cursors
v0.943 included an XP Tahoma font (no install), works
v0.944 tried to match original XP texts on both main dialogs
v0.945 styled balloon-tip bubble sizes and texts to match XP
v0.946 disabled XP Tahoma font if Japanese language chosen
v0.947 fixed pointer/bubble tips locking while mouse over desktop
v0.948 moved most functions into "misc\functions.ahk"
v0.949 added "less width" bubble-tip images for short one-liners
V0.950 fixed XP pointer sticking on, added line breaks in bubble-tips
v0.951 fixed some minor errors, cleaned up and added more comments
v0.952 fixed ESC mapping so it works correctly while in window
v0.953 removed some "click" sounds, more accurate to original XP
v0.954 added some rough shadows under bubble-tip windows
v0.955 background fade now happens underneath main window, buggy
v0.956 somewhat fixed background fade integration but not 100%
v0.957 fixed button "flicker" using guicontrol +-redraw
v0.958 adjusted some bubble-tip images' heights to match XP
v0.959 replaced 2 dropdowns with checkboxes for "yes/no" choices
v0.960 moved stuff to options.ini to standardize language variables
v0.961 wrapped INI key contents in quotation marks for reliability
v0.962 added Klingon.ttf font to properly display Klingon (English) 
v0.963 customize font-type and font-size per chosen language in INI
v0.964 replaced "Stand By" bubble-tip with correct text (had Hibernate text)
v0.965 added shift-key trigger for "Hibernate" button and its bubble text
v0.966 added Arabic to languages, not sure why I didn't see it before
v0.967 added "shutdown w/updates" feature (press CONTROL to activate)
January 2021:
v0.968 fixed z-order issue with overlay icon and bubble-tip windows
v0.969 fixed underline height issue in custom XpTahoma font
v0.970 "shutdown w/updates" opens Windows Updates, fixed Cancel button not showing
v0.971 fixed underlined text not lining up with other text, applied to all languages
v0.972 moved fade into its own EXE, allows ESC and menu buttons while fading
v0.973 disabled fade.exe/fade.ahk from being accidentally run independently
v0.974 fixed "update icon position" issue, Millenshea updated Japanese text
v0.975 figured out a way to remove bold text but only for Japanese
v0.976 shortcut keys are now underlined in the main buttons' texts
v0.977 added program update feature, in English only for now
v0.978 fixed keyboard shortcuts for Logoff, Hibernate and Shutdown w/updates
v0.979 added feature to choose how long background fade takes, in seconds
v0.980 warns AHK users if "misc\fade.ahk" is not compiled into EXE
v0.981 confirmed working on Windows XP, Vista, 7, 8.1 and 10 (32 and 64-bit)
v0.982 using 32-bit EXEs for maximum compatibility, fixed more Japanese issues
V0.983 added correct bubble-tip text for when CTRL is pressed (english and japanese so far)
v0.984 fix attempt for "Hibernate" function not working. Now using "shutdown /h" and DLL-call
v0.985 fixed "H" key not triggering "Hibernate" while SHIFT is held down to see its button
v0.986 fixed inaccurate rounded corners on all button images, looks better now (fail!)
v0.987 finished translations for "Turn Off" button's "Turn off & install updates" bubble text
v0.988 finished "Log Off" original Japanese size. I'm trying to implement TAB while "OnMouseMove"
v0.989 changed the "Cancel, Save, About and Update" buttons to a style somewhat closer to XP
v0.990 fixed main image buttons, all corners finally correct. Scaled up background image, sharper
v0.991 a few minor visual adjustments, strengthened font code (wasn't showing correctly some PCs)
February 2021:
v0.992 realized I can use BMPs for button images now, so I replaced all button JPGs with BMPs
