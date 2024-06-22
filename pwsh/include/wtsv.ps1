function wtsv {
	param (
		[string] $dir = '.'
	)

	wt sp -V -d (Resolve-Path $dir).Path
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'wtsv'
