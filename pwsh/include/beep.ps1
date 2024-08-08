<#
.SYNOPSIS
	Uses `Console.Beep` to play a sound of a specific frequency & duration.
#>
function beep {
	param (
		[int] $Frequency = 400,
		[int] $Duration = 500
	)

	[System.Console]::Beep($Frequency, $Duration)
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'beep'
