<#
.SYNOPSIS
	Lists directories in the current location and `cd`s into the selection.
#>
function cdi {
	param (
		[string] $dir = '.'
	)

	Set-Location $dir

	$selection = Get-ChildItem -Directory | ForEach-Object { $_.Name } | fzf --height '30%' --layout reverse

	if (-not ($null -eq $selection)) {
		Set-Location $selection
	}
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'cdi'
