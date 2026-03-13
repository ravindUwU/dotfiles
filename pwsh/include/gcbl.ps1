<#
.SYNOPSIS
	Gets the length of the contents of the clipboard.
#>
function gcbl {
	(Get-Clipboard).Length
}

Export-DotfilesFunction 'gcbl'
