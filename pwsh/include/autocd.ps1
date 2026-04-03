function Install-DotfilesAutoCd {
	[CmdletBinding()]
	param ()

	${global:Dotfiles.AutoCd.Old} = $ExecutionContext.SessionState.InvokeCommand.CommandNotFoundAction

	# https://github.com/PowerShell/PowerShell/blob/a51e7be624ab6dbde17f1d35ef470b69b8ebc2db/src/System.Management.Automation/engine/MshCmdlet.cs#L340-L347
	$ExecutionContext.SessionState.InvokeCommand.CommandNotFoundAction = {
		param ([object] $s, [System.Management.Automation.CommandLookupEventArgs] $e)

		if (
			(
				# Command starts with ./ or ../
				$e.CommandName.StartsWith(".$([System.IO.Path]::DirectorySeparatorChar)") `
				-or $e.CommandName.StartsWith(".$([System.IO.Path]::AltDirectorySeparatorChar)") `
				-or $e.CommandName.StartsWith("..$([System.IO.Path]::DirectorySeparatorChar)") `
				-or $e.CommandName.StartsWith("..$([System.IO.Path]::AltDirectorySeparatorChar)")
			) `
			-and (
				# Container exists
				Test-Path -PathType Container $e.CommandName
			)
		) {
			$e.CommandScriptBlock = { cd $e.CommandName }.GetNewClosure()
			$e.StopSearch = $true
		}
		else {
			(${global:Dotfiles.AutoCd.Old})?.Invoke($s, $e)
		}
	}
}

function Uninstall-DotfilesAutoCd {
	[CmdletBinding()]
	param ()

	if (${global:Dotfiles.AutoCd.Old}) {
		$ExecutionContext.SessionState.InvokeCommand.CommandNotFoundAction = ${global:Dotfiles.AutoCd.Old}
		Remove-Variable -Name 'Dotfiles.AutoCd.Old' -Scope 'Global'
	}
}
