class DotfilesPrompt {
	[bool] $HasTime
	[bool] $HasElevationWarning
	[bool] $HasDotnetEnvironment
	[bool] $HasCurrentDir
	[string] $HomeDir

	[DotfilesPrompt] Clone() {
		return [DotfilesPrompt]@{
			HasTime = $this.HasTime
			HasElevationWarning = $this.HasElevationWarning
			HasDotnetEnvironment = $this.HasDotnetEnvironment
			HasCurrentDir = $this.HasCurrentDir
			HomeDir = $this.HomeDir
		}
	}
}

${script:Dotfiles.Prompt.Presets} = @{
	Default = [DotfilesPrompt]@{
		HasTime = $true
		HasElevationWarning = $true
		HasDotnetEnvironment = $true
		HasCurrentDir = $true
		HomeDir = $Env:USERPROFILE
	}
}

function Get-DotfilesPromptPreset {
	[CmdletBinding()]
	[OutputType([DotfilesPrompt])]
	param (
		[Parameter(Mandatory)]
		[string] $Name
	)

	$p = ${script:Dotfiles.Prompt.Presets}
	if ($p.Keys -notcontains $Name) {
		throw "Preset name must be one of [$($p.Keys -join ', ')]."
	}
	$p[$Name]
}

function Get-DotfilesPrompt {
	[CmdletBinding()]
	[OutputType([DotfilesPrompt])]
	param ()

	${global:Dotfiles.Prompt} ?? (Get-DotfilesPromptPreset 'Default')
}

function Set-DotfilesPrompt {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory, ParameterSetName='Preset')]
		[string] $Preset,

		[Parameter(ParameterSetName='Custom')]
		[switch] $Extend,

		[Parameter(ParameterSetName='Custom')]
		[switch] $Time,

		[Parameter(ParameterSetName='Custom')]
		[switch] $ElevationWarning,

		[Parameter(ParameterSetName='Custom')]
		[switch] $DotnetEnvironment,

		[Parameter(ParameterSetName='Custom')]
		[switch] $CurrentDir,

		[Parameter(ParameterSetName='Custom')]
		[string] $HomeDir
	)

	switch ($PSCmdlet.ParameterSetName) {
		'Preset' {
			${global:Dotfiles.Prompt} = Get-DotfilesPromptPreset $Preset
			break
		}

		'Custom' {
			$resolvedHomeDir = if ($HomeDir) { (Resolve-Path $HomeDir).Path }

			if ($Extend) {
				$bound = $PSBoundParameters.Keys
				$p = (Get-DotfilesPrompt).Clone()

				if ($bound -contains 'Time') { $p.HasTime = $Time }
				if ($bound -contains 'ElevationWarning') { $p.HasElevationWarning = $ElevationWarning }
				if ($bound -contains 'DotnetEnvironment') { $p.HasDotnetEnvironment = $DotnetEnvironment }
				if ($bound -contains 'CurrentDir') { $p.HasCurrentDir = $CurrentDir }
				if ($bound -contains 'HomeDir') { $p.HomeDir = $resolvedHomeDir }

				${global:Dotfiles.Prompt} = $p
			} else {
				${global:Dotfiles.Prompt} = [DotfilesPrompt]@{
					HasTime = $Time
					HasElevationWarning = $ElevationWarning
					HasDotnetEnvironment = $DotnetEnvironment
					HasCurrentDir = $CurrentDir
					HomeDir = $resolvedHomeDir
				}
			}
			break
		}
	}
}

function Install-DotfilesPrompt {
	${global:Dotfiles.Prompt.Old} = Get-Content -Path 'Function:\prompt' -ErrorAction Ignore

	Set-DotfilesPrompt -Preset 'Default'

	Set-Content -Path 'Function:\prompt' -Value {
		# Print escape code to set terminal working directory of the current shell, which will be
		# used when a new pane/tab is made.
		# https://learn.microsoft.com/windows/terminal/tutorials/new-tab-same-directory
		$loc = $ExecutionContext.SessionState.Path.CurrentLocation
		if ($loc.Provider.Name -eq 'FileSystem') {
			Write-Host "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\" -NoNewline
		}

		$p = Get-DotfilesPrompt

		# Write time
		if ($p.HasTime) {
			Write-Host "$([datetime]::Now.ToString('hh:mm:sst').ToLower()) " -NoNewline -ForegroundColor DarkGray
		}

		# Warn if elevated session
		# https://superuser.com/a/756696
		if (
			$p.HasElevationWarning `
			-and (
				[System.Security.Principal.WindowsPrincipal] `
				[System.Security.Principal.WindowsIdentity]::GetCurrent()
			).IsInRole(
				[System.Security.Principal.WindowsBuiltInRole]::Administrator
			)
		) {
			Write-Host '[Admin] ' -NoNewline -ForegroundColor Red
		}

		# Write non-dev .NET environment
		if (
			$p.HasDotnetEnvironment `
			-and ($null -ne $Env:DOTNET_ENVIRONMENT) `
			-and ('Development' -ne $Env:DOTNET_ENVIRONMENT)
		) {
			Write-Host "[.NET: $Env:DOTNET_ENVIRONMENT] " -NoNewline -ForegroundColor Yellow
		}

		# Write label
		Write-Host "$(${global:Dotfiles.Prompt.Label} ?? 'PS')$(if ($p.HasCurrentDir) { ' ' })" -NoNewline

		# Write current directory
		if ($p.HasCurrentDir) {
			$cwd = "$($ExecutionContext.SessionState.Path.CurrentLocation)"

			# Replace home directory with ~
			if ($p.HomeDir) {
				$h = $p.HomeDir
				if (($h -eq $cwd) -or $cwd.ToLower().StartsWith("$h\".ToLower())) {
					$cwd = "~$($cwd.Substring($h.Length))"
				}
			}

			Write-Host $cwd -NoNewline
		}

		# Write `>`s
		Write-Host "$('>' * ($NestedPromptLevel + 1))" -NoNewline

		# Return a truthy object (which is also printed out!) so that PowerShell knows that the
		# prompt has been printed and won't print its own default prompt.
		' '
	}
}

function Uninstall-DotfilesPrompt {
	if ($null -ne ${global:Dotfiles.Prompt.Old}) {
		Set-Content -Path 'Function:\prompt' -Value ${global:Dotfiles.Prompt.Old}
		Remove-Variable -Name 'Dotfiles.Prompt.Old' -Scope 'Global'
	}
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'Set-DotfilesPrompt'
