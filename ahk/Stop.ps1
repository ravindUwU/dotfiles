Get-Process 'AutoHotkey64' -ErrorAction SilentlyContinue `
	| Where-Object { $_.CommandLine.ToLower().Contains($PSScriptRoot.ToLower()) } `
	| Stop-Process
