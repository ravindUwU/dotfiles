function flowers {
	if (-not (Get-Command 'jq' -ErrorAction Ignore)) {
		throw 'flowers: jq not found.'
	}

	try {
		Push-Location
		Set-Location $PSScriptRoot

		if ([System.Console]::OutputEncoding -isnot [System.Text.UTF8Encoding]) {
			$oldEncoding = [System.Console]::OutputEncoding
			[System.Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
		}

		Get-Random -Minimum 0 -Maximum (999999999 + 1) -Count 100000 `
			| jq -nf 'flowers.jq' -r --argjson frame 40
	}
	finally {
		if ($oldEncoding) {
			[System.Console]::OutputEncoding = $oldEncoding
		}

		Pop-Location
	}
}

Export-DotfilesFunction 'flowers'
