function wtsh {
	param (
		[string] $dir = '.'
	)

	wt sp -H -d (Resolve-Path $dir).Path
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'wtsh'
