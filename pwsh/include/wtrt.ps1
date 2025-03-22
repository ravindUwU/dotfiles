function wtrt {
	param (
		[string] $dir = '.'
	)

	wtnt
	Start-Sleep -Seconds 1
	exit
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'wtrt'
