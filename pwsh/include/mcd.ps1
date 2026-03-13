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
	cd $Name
}

Export-DotfilesFunction 'mcd'
