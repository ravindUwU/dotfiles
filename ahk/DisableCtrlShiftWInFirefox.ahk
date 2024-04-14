; Disable Ctrl+Shift+W in Firefox, because it closes the active window and I keep accidentally
; pressing it because I use Ctrl+Shift+{E,R,T} often.

#HotIf WinActive("ahk_exe firefox.exe")
^+w::
{
}
