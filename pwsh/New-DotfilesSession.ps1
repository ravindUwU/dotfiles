<#
.SYNOPSIS
	Starts a PowerShell instance with the Dotfiles module loaded. Intended for use when testing out
	changes to contents of the module.
#>
[CmdletBinding()]
param ()

try {
	Push-Location '.'
	Set-Location $PSScriptRoot

	# Start pwsh
	pwsh -NoLogo -NoProfile -NoExit -WorkingDirectory $PSScriptRoot {
		# Override prompt label
		${global:Dotfiles.Prompt.Label} = 'DOTFILES'

		# Import module
		Import-Module './Dotfiles.psm1' -ArgumentList @{
			'UsePrompt' = $true
			'UseAutoCd' = $true
		}

		# Exit immediately, if the module didn't load
		if (-not (Get-Module 'Dotfiles' -ErrorAction Ignore)) {
			Write-Host 'Module not loaded; exiting' -ForegroundColor Red
			exit
		}
	}
}
finally {
	Pop-Location
}
