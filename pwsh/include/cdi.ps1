<#
.SYNOPSIS
	Interactive `cd`s into directories.
#>
function cdi {
	param (
		[string] $dir = '.'
	)

	while ($true) {
		$selection = ('.', @(Get-ChildItem $dir -Directory | ForEach-Object { $_.Name })) `
			| fzf --height '~30%'

		if ($selection -eq '.') {
			break
		} else {
			$dir = Join-Path $dir $selection
		}
	}

	cd $dir
}

Export-DotfilesFunction 'cdi'
