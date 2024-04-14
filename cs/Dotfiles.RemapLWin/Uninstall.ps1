Write-Host 'Removing startup shortcut' -ForegroundColor Cyan
Remove-Item "$Env:APPDATA/Microsoft/Windows/Start Menu/Programs/Startup/Dotfiles.RemapLWin.exe.lnk" -ErrorAction SilentlyContinue

Write-Host 'Stopping processes' -ForegroundColor Cyan
Get-Process 'Dotfiles.RemapLWin' -ErrorAction SilentlyContinue | Stop-Process

Write-Host 'Done' -ForegroundColor Green
