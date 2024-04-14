Write-Host 'Removing startup shortcuts' -ForegroundColor Cyan
Remove-Item "$Env:APPDATA/Microsoft/Windows/Start Menu/Programs/Startup/Dotfiles.*.ahk.lnk" -ErrorAction SilentlyContinue

Write-Host 'Stopping processes' -ForegroundColor Cyan
& './Stop.ps1'

Write-Host 'Done' -ForegroundColor Green
