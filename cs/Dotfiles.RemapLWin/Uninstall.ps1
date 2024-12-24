Write-Host 'Removing startup shortcut' -ForegroundColor Cyan
Remove-Item "$Env:APPDATA/Microsoft/Windows/Start Menu/Programs/Startup/Dotfiles.RemapLWin.exe.lnk" -ErrorAction Ignore

Write-Host 'Stopping processes' -ForegroundColor Cyan
Get-Process 'Dotfiles.RemapLWin' -ErrorAction Ignore | Stop-Process

Write-Host 'Done' -ForegroundColor Green
