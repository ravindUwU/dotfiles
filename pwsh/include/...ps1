<#
.SYNOPSIS
	Navigates down the specified number of directories.

.EXAMPLE
	PS a/b> ..
	PS a>

.EXAMPLE
	PS a/b/c> .. 2
	PS a>
#>
function .. {
	param (
		[int] $n = 1
	)

	Set-Location (@('..') * $n -join '/')
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) '..'
