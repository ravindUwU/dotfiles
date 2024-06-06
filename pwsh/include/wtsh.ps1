function wtsh {
	wt sp -H -d .
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'wtsh'
