<#
.SYNOPSIS
	Creates a Windows shortcut (LNK).
#>
function New-Shortcut {
	[CmdletBinding()]
	param (
		# Path to the shortcut.
		[Parameter(Mandatory)]
		[string] $Path,

		# Path to the file or directory that the shortcut points to.
		[Parameter(Mandatory)]
		[ValidateScript({ Test-Path $_ })]
		[string] $TargetPath
	)

	# Make the path absolute
	$Path = $(if ([System.IO.Path]::IsPathRooted($Path)) { $Path } else { Join-Path (Get-Location) $Path })

	# Make shortcut
	# https://stackoverflow.com/a/9701907
	$shell = New-Object -ComObject 'WScript.Shell'
	$shortcut = $shell.CreateShortcut($Path)
	$shortcut.TargetPath = (Resolve-Path $TargetPath -ErrorAction Stop)
	$shortcut.Save()

	# Return the shortcut "item"
	Get-Item $Path
}

Invoke-Command { Export-DotfilesFunction 'New-Shortcut' } 2>&1 | Out-Null
