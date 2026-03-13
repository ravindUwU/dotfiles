function cdv {
	$path = (Resolve-Path (Get-Clipboard)).Path

	if (Test-Path $path -PathType Leaf) {
		$path = Join-Path $path '..' -Resolve
	}

	cd $path
}

Export-DotfilesFunction 'cdv'
