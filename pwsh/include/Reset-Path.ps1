<#
.SYNOPSIS
	Resets the PATH environment variable of the current session.
#>
function Reset-Path {
	# https://stackoverflow.com/a/31845512

	$Env:Path = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' `
		+ [System.Environment]::GetEnvironmentVariable('PATH', 'User')
}

Invoke-Command { Export-DotfilesFunction 'Reset-Path' } 2>&1 | Out-Null
