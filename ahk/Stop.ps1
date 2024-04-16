Get-Process 'AutoHotkey64' -ErrorAction SilentlyContinue `
	| Where-Object {
		# CLI includes path to a Dotfiles AHK script
		$_.CommandLine -like "*$PSScriptRoot[/\]*.ahk*"
	} `
	| ForEach-Object {
		Write-Output "Stopping $($_.Name)#$($_.Id) ($($_.CommandLine))"
		$_ | Stop-Process
	}
