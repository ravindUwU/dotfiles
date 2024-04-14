. "$PSScriptRoot/../../pwsh/include/New-Shortcut.ps1"

try {
	Push-Location .
	Set-Location $PSScriptRoot

	Write-Host 'Cleaning' -ForegroundColor Cyan
	Remove-Item 'bin' -Recurse -Force -ErrorAction SilentlyContinue
	Remove-Item 'obj' -Recurse -Force -ErrorAction SilentlyContinue

	Write-Host 'Building' -ForegroundColor Cyan
	dotnet publish --configuration Release --runtime win-x64 --output '../.published/Dotfiles.RemapLWin'

	$shortcutPath = "$Env:APPDATA/Microsoft/Windows/Start Menu/Programs/Startup/Dotfiles.RemapLWin.exe.lnk"
	$exePath = Resolve-Path '../.published/Dotfiles.RemapLWin/Dotfiles.RemapLWin.exe' -ErrorAction Stop

	Write-Host 'Removing existing startup shortcut' -ForegroundColor Cyan
	Remove-Item $shortcutPath -ErrorAction SilentlyContinue

	Write-Host 'Making new startup shortcut' -ForegroundColor Cyan
	New-Shortcut -Path $shortcutPath -TargetPath $exePath | Out-Null

	Write-Host 'Starting' -ForegroundColor Cyan
	& $exePath

	Write-Host 'Done' -ForegroundColor Green
}
finally {
	Pop-Location
}
