<#
.SYNOPSIS
	Resets the PATH environment variable of the current session.
#>
function Reset-Path {
	# https://stackoverflow.com/a/31845512

	$env:PATH = `
		[System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::User) `
		+ ';' + [System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::Machine)
}

Export-DotfilesFunction 'Reset-Path'
