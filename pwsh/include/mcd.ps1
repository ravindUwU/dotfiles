<#
.SYNOPSIS
	Makes a new directory of the specified name and navigates into it.

.EXAMPLE
	PS a> mcd b
	PS a/b>
#>
function mcd {
	param (
		[string] $Name
	)

	New-Item $Name -ItemType Directory -ErrorAction Stop | Out-Null
	Set-Location $Name
}

Invoke-Command { Export-DotfilesFunction 'mcd' } 2>&1 | Out-Null
