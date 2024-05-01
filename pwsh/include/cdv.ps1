function cdv {
	$path = (Resolve-Path (Get-Clipboard)).Path

	if (Test-Path $path -PathType Leaf) {
		$path = Join-Path $path '..' -Resolve
	}

	Set-Location $path
}

Invoke-Command { Export-DotfilesFunction 'cdv' } 2>&1 | Out-Null
