function wtnt {
	wt nt -d .
}

Invoke-Command { Export-DotfilesFunction 'wtnt' } 2>&1 | Out-Null
