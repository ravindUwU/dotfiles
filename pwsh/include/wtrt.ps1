function wtrt {
	param (
		[string] $dir = '.'
	)

	wt nt -d (Resolve-Path $dir).Path
	Start-Sleep -Seconds 1
	exit
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'wtrt'
