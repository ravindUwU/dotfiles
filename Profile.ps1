<#
.SYNOPSIS
	Creates a directory of the specified name, and `cd`s into it.
#>
function mcd
{
	param([string] $name)

	New-Item $name -ItemType Directory
	Set-Location $name
}

<#
.SYNOPSIS
	`cd`s down the specified number of directories.
#>
function ..
{
	param([int] $n = 1)

	Set-Location (@('..') * $n -join '/')
}

<#
.SYNOPSIS
	Reloads the `PATH` environment variable.
#>
function Reload-Path
{
	# https://stackoverflow.com/a/31845512
	$env:Path = [System.Environment]::GetEnvironmentVariable('PATH','Machine') + ';' `
		+ [System.Environment]::GetEnvironmentVariable('PATH','User')
}

# Windows Terminal
# TODO: Make conditional on OS == Windows, maybe also Windows Terminal installed?
# TODO: Document!
# TODO: `function wt` with better documentation, etc.
# TODO: Is there a better way to accept $dir? DirectoryInfo or FileInfo (or equilvant) objects
#       instead of string?

function wt_NewTab
{
	param([string] $path = '.')

	wt.exe --window 0 new-tab --startingDirectory (Resolve-Path $path).Path
}

function wt_Split
{
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)] [ValidateSet('v','h')] [string] $direction,
		[Parameter()] [string] $path = '.'
	)

	switch ($direction) {
		'v' { $directionArg = '--vertical' }
		'h' { $directionArg = '--horizontal' }
	}

	wt.exe --window 0 split-pane $directionArg --startingDirectory (Resolve-Path $path).Path
}

# Aliases
Set-Alias gh Get-Help
Set-Alias x explorer.exe
