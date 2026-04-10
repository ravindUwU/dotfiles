function Install-DotfilesUtf8 {
	[CmdletBinding()]
	param ()

	if ([System.Console]::InputEncoding -isnot [System.Text.UTF8Encoding]) {
		${global:Dotfiles.Utf8.Input.Old} = [Console]::InputEncoding
		[Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
	}

	if ([System.Console]::OutputEncoding -isnot [System.Text.UTF8Encoding]) {
		${global:Dotfiles.Utf8.Output.Old} = [Console]::OutputEncoding
		[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
	}
}

function Uninstall-DotfilesUtf8 {
	[CmdletBinding()]
	param ()

	if (${global:Dotfiles.Utf8.Input.Old}) {
		[Console]::InputEncoding = ${global:Dotfiles.Utf8.Input.Old}
		Remove-Variable -Name 'Dotfiles.Utf8.Input.Old' -Scope 'Global'
	}

	if (${global:Dotfiles.Utf8.Output.Old}) {
		[Console]::OutputEncoding = ${global:Dotfiles.Utf8.Output.Old}
		Remove-Variable -Name 'Dotfiles.Utf8.Output.Old' -Scope 'Global'
	}
}
