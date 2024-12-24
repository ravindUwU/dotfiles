function Install-DotfilesPrompt {

	${Global:Dotfiles.Prompt.Old} = Get-Content -Path 'Function:\prompt' -ErrorAction Ignore
	${Global:Dotfiles.Prompt.Old} | Out-Null # suppress PSUseDeclaredVarsMoreThanAssignments

	Set-Content -Path 'Function:\prompt' -Value {
		# Write time
		Write-Host "$([datetime]::Now.ToString('hh:mm:sst').ToLower()) " -NoNewline -ForegroundColor DarkGray

		# Warn if elevated session
		# https://superuser.com/a/756696
		if (
			(
				[System.Security.Principal.WindowsPrincipal] `
				[System.Security.Principal.WindowsIdentity]::GetCurrent()
			).IsInRole(
				[System.Security.Principal.WindowsBuiltInRole]::Administrator
			)
		) {
			Write-Host '[Admin] ' -NoNewline -ForegroundColor Red
		}

		# Write non-dev .NET environment
		if (($null -ne $Env:DOTNET_ENVIRONMENT) -and ('Development' -ne $Env:DOTNET_ENVIRONMENT)) {
			Write-Host "[.NET: $Env:DOTNET_ENVIRONMENT] " -NoNewline -ForegroundColor Yellow
		}

		# Write PowerShell label
		Write-Host "$(${Global:Dotfiles.Prompt.Label} ?? 'PS') " -NoNewline

		# Write current location, replace home directory with ~
		$dir = "$($ExecutionContext.SessionState.Path.CurrentLocation)"
		$homeDir = $Env:USERPROFILE
		if (($homeDir -eq $dir) -or $dir.ToLower().StartsWith("$homeDir\".ToLower())) {
			$dir = "~$($dir.Substring($homeDir.Length))"
		}
		Write-Host $dir -NoNewline

		# Write `>`s
		Write-Host "$('>' * ($NestedPromptLevel + 1))" -NoNewline

		# Must return a truthy object so that PowerShell knows that the prompt has been defined and
		# wouldn't print its own prompt. This object is also printed out.
		' '
	}
}

function Uninstall-DotfilesPrompt {
	if ($null -ne ${Global:Dotfiles.Prompt.Old}) {
		Set-Content -Path 'Function:\prompt' -Value ${Global:Dotfiles.Prompt.Old}
		Remove-Variable -Name 'Dotfiles.Prompt.Old' -Scope 'Global'
	}
}
