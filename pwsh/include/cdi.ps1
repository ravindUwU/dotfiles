<#
.SYNOPSIS
	Lists directories in the current location and `cd`s into the selection.
#>
function cdi {
	param (
		[string] $dir = '.'
	)

	cd $dir

	$selection = Get-ChildItem -Directory | ForEach-Object { $_.Name } | fzf --height '30%' --layout reverse

	if (-not ($null -eq $selection)) {
		cd $selection
	}
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'cdi'
