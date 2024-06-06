function wtsv {
	wt sp -V -d .
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'wtsv'
