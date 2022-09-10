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

# Aliases
Set-Alias gh Get-Help
Set-Alias x explorer.exe
