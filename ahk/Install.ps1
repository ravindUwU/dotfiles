. "$PSScriptRoot/../pwsh/include/New-Shortcut.ps1"

try {
	Push-Location .
	Set-Location $PSScriptRoot

	& './Stop.ps1'

	Get-ChildItem '*.ahk' | ForEach-Object {
		$ahkName = $_.BaseName
		$ahkPath = $_.FullName
		$shortcutPath = "$Env:APPDATA/Microsoft/Windows/Start Menu/Programs/Startup/Dotfiles.$($_.Name).lnk"

		Write-Host "$ahkName`: Removing existing startup shortcut" -ForegroundColor Cyan
		Remove-Item $shortcutPath -ErrorAction SilentlyContinue

		Write-Host "$ahkName`: Making new startup shortcut" -ForegroundColor Cyan
		New-Shortcut -Path $shortcutPath -TargetPath $ahkPath | Out-Null

		Write-Host "$ahkName`: Starting" -ForegroundColor Cyan
		& $ahkPath
	}

	Write-Host 'Done' -ForegroundColor Green
}
finally {
	Pop-Location
}
