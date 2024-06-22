function wtnt {
	param (
		[string] $dir = '.'
	)

	wt nt -d (Resolve-Path $dir).Path
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'wtnt'
