function cdv {
	Set-Location (Get-Clipboard)
}

Invoke-Command { Export-DotfilesFunction 'cdv' } 2>&1 | Out-Null
