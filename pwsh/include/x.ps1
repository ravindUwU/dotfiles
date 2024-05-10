<#
.SYNOPSIS
	Opens a path with explorer.exe.

.EXAMPLE
	# Open the current directory (a/b)
	PS a/b> x

	# Open a directory (a/b/c)
	PS a/b> x c

	# Open the home directory
	PS a/b> x ~

	# Open something within home directory
	PS a/b> x ~/t.txt

	# Open a file (a/b/t.txt)
	PS a/b> x t.txt
#>
function x {
	param (
		# When specified, x uses Resolve-Path to make the path absolute before opening it. Paths in
		# which the home directory is referenced as ~ are therefore supported.
		#
		# When unspecified, the current directory is used.
		[string] $Path
	)

	if ($Path -eq '') {
		explorer.exe '.'
	} else {
		explorer.exe (Resolve-Path $Path).Path
	}
}

Invoke-Command { Export-DotfilesFunction 'x' } 2>&1 | Out-Null
