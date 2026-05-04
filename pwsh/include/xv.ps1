function xv {
	$path = (Resolve-Path (Get-Clipboard)).Path

	if (Test-Path $path -PathType Leaf) {
		$path = Join-Path $path '..' -Resolve
	}

	x $path
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'xv'
