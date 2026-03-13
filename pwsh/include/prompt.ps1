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
		HomeDir = $null
	}
	Minimal = [DotfilesPrompt]@{
		HasTime = $false
		HasElevationWarning = $true
		HasDotnetEnvironment = $true
		HasCurrentDir = $false
		HomeDir = $null
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
		[ValidateSet('Default', 'Minimal')]
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
		$s = ''

		# OSC 9;9 sequence to tell the terminal about the current working directory.
		# https://learn.microsoft.com/windows/terminal/tutorials/new-tab-same-directory
		$loc = $ExecutionContext.SessionState.Path.CurrentLocation
		if ($loc.Provider.Name -eq 'FileSystem') {
			$s += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
		}

		$p = Get-DotfilesPrompt

		$bg = $PSStyle.Background
		$fg = $PSStyle.Foreground

		# Time
		if ($p.HasTime) {
			$s += "$($fg.BrightBlack)$([datetime]::Now.ToString('hh:mm:sst').ToLower())$($PSStyle.Reset) "
		}

		$hasTag = $false

		# Elevated session warning
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
			$s += "$($bg.BrightRed)$($fg.BrightWhite) Admin $($PSStyle.Reset)"
			$hasTag = $true
		}

		# Non-dev .NET environment
		if (
			$p.HasDotnetEnvironment `
			-and ($null -ne $Env:DOTNET_ENVIRONMENT) `
			-and ('Development' -ne $Env:DOTNET_ENVIRONMENT)
		) {
			$s += "$($bg.BrightYellow)$($fg.Black) .NET: $Env:DOTNET_ENVIRONMENT $($PSStyle.Reset)"
			$hasTag = $true
		}

		# Label, defaulting to "PS".
		$s += "$(if ($hasTag) { ' '})$(${global:Dotfiles.Prompt.Label} ?? 'PS')$(if ($p.HasCurrentDir) { ' ' })"

		# Current directory, with home dir abbreviated as ~.
		if ($p.HasCurrentDir) {
			$cwd = "$($ExecutionContext.SessionState.Path.CurrentLocation)"

			$h = if ($p.HomeDir) { $p.HomeDir } else { $HOME }
			if (
				($h -eq $cwd) `
				-or $cwd.ToLower().StartsWith("$h\".ToLower()) `
				-or $cwd.ToLower().StartsWith("$h/".ToLower())
			) {
				$cwd = "~$($cwd.Substring($h.Length))"
			}

			$s += $cwd
		}

		# Everything above + ">"s according to the nested prompt level.
		"$s$('>' * ($NestedPromptLevel + 1)) "
	}
}

function Uninstall-DotfilesPrompt {
	if ($null -ne ${global:Dotfiles.Prompt.Old}) {
		Set-Content -Path 'Function:\prompt' -Value ${global:Dotfiles.Prompt.Old}
		Remove-Variable -Name 'Dotfiles.Prompt.Old' -Scope 'Global'
	}
}

Export-DotfilesFunction 'Set-DotfilesPrompt'
