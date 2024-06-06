<#
.SYNOPSIS
	Resets the PATH environment variable of the current session.
#>
function Reset-Path {
	# https://stackoverflow.com/a/31845512

	$Env:Path = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' `
		+ [System.Environment]::GetEnvironmentVariable('PATH', 'User')
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'Reset-Path'
