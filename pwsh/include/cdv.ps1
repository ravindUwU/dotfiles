function cdv {
	$path = (Resolve-Path (Get-Clipboard)).Path

	if (Test-Path $path -PathType Leaf) {
		$path = Join-Path $path '..' -Resolve
	}

	Set-Location $path
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'cdv'
