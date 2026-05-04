<#
.SYNOPSIS
	Gets the length of the contents of the clipboard.
#>
function gcbl {
	(Get-Clipboard).Length
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'gcbl'
