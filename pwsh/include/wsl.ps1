if (Get-Command 'wsl.exe' -ErrorAction Ignore) {
	<#
	.SYNOPSIS
		Opens WSL to the Linux home directory (~) instead of the current Windows directory. Use
		`wsl.exe` to open WSL directly.
	#>
	function wsl {
		wsl.exe --cd '~' @args
	}

	& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'wsl'
}
