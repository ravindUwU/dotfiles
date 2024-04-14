# RemapLWin

Remaps <kbd>LWin</kbd> to <kbd>LWin</kbd>+<kbd>Space</kbd> _while preserving other
<kbd>LWin</kbd>-based keystrokes_ (e.g., <kbd>LWin</kbd>+<kbd>&lt;N&gt;</kbd> to switch apps,
<kbd>LWin</kbd>+<kbd>Tab</kbd> to open the task view, etc.).

I have <kbd>LWin</kbd>+<kbd>Space</kbd> bound to launch PowerToys Run, so this program essentially
replaces the Windows start menu with PowerToys Run. I might be able to remove this program when they
close https://github.com/microsoft/PowerToys/issues/3269, which should allow binding PowerToys Run
to a single key press.

I'd prefer to use an AutoHotkey script for this. I tried the script below, but it didn't work quite
right because <kbd>LWin</kbd> opened PowerToys run in the background and the start menu in the
foreground, and I've no idea how to fix it.

```ahk
#SingleInstance

if A_IsAdmin
{
	; https://stackoverflow.com/a/57440840

	LWin up::
	{
		if (A_PriorKey == 'LWin')
		{
			Send '#{Space}'
		}
	}

	LWin & d::
	{
		Send '#d'
	}
}
else
{
	; Restart elevated
	; https://stackoverflow.com/a/57440848
	; https://www.autohotkey.com/docs/v2/lib/Run.htm#RunAs

	Run Format('*RunAs "{}" "{}"', A_AhkPath, A_ScriptFullPath)
}
```
