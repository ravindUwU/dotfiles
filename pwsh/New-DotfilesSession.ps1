<#
.SYNOPSIS
	Starts a PowerShell instance with the Dotfiles module loaded. Intended for use when testing out
	changes to contents of the module.
#>
param (
	[Parameter()]
	[switch] $Confirm
)

$init = {
	# Override prompt label
	${Global:Dotfiles.Prompt.Label} = 'DOTFILES'

	# Import module
	Import-Module '.\Dotfiles.psm1' -ArgumentList @{ 'InstallPrompt' = $true }

	# Exit immediately, if the module didn't load
	if (-not (Get-Module 'Dotfiles' -ErrorAction SilentlyContinue)) {
		Write-Host 'Module not loaded; exiting' -ForegroundColor Red
		exit
	}
}

# Try to convert the init script into a single command string. Syntax unaware string manipulation
# that removes indentation, empty lines and line comments.
# TODO: Convert init script into single line command using the PowerShell parser/script block AST?
$commands = `
	($init.ToString() -replace '\t','').Trim() `
	-replace '\r','' `
	-split '\n' `
	| Where-Object { $_.Trim()  } `
	| Where-Object { -not $_.StartsWith('#') }

$command = $commands -join ' ; '

# Write out commands & confirm if requested
if ($Confirm) {
	Write-Host 'Script:' -ForegroundColor Cyan
	$commands | ForEach-Object { Write-Host "`t $_" }

	Write-Host "`nCommand:" -ForegroundColor Cyan
	Write-Host "`t$command`n"

	if ($Host.UI.PromptForChoice($null, 'Continue?', @(
		[System.Management.Automation.Host.ChoiceDescription]::new('&No')
		[System.Management.Automation.Host.ChoiceDescription]::new('&Yes')
	), 0) -ne 1) {
		exit
	}
}

# Start instance
pwsh -NoLogo -NoProfile -NoExit -WorkingDirectory $PSScriptRoot -Command $command
