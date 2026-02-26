function hehe {
	if ($true, $false | Get-Random) {
		pspsps
	} else {
		fih
	}
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'hehe'
