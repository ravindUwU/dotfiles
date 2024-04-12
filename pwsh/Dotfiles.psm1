param (
	# May include,
	#     [bool] InstallPrompt
	[hashtable] $Options
)

<#
.SYNOPSIS
	Registers a function name to be exported by the Dotfiles module.

	Conditionally invoke as,
		Invoke-Command { Export-DotfilesFunction '<name>' } 2>&1 | Out-Null
#>
function Export-DotfilesFunction {
	param (
		[string] $Name
	)

	${Script:Dotfiles.Export.Functions} ??= @()
	${Script:Dotfiles.Export.Functions} += $Name
}

# Source all scripts
foreach ($file in (Get-ChildItem "$PSScriptRoot/include/*.ps1" -ErrorAction Stop)) {
	. $file
}

# Export members
Export-ModuleMember `
	-Function ${Script:Dotfiles.Export.Functions} `
	-Alias (Set-DotfilesAliases)

# Install prompt if requested
if ($Options.InstallPrompt) {
	Install-DotfilesPrompt
}

# Clean up if the module is removed
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/remove-module?view=powershell-7.4#example-5-using-the-onremove-event
$ExecutionContext.SessionState.Module.OnRemove += {

	# Uninstall prompt if previously installed
	if ($Options.InstallPrompt) {
		Uninstall-DotfilesPrompt
	}

	# Remove Dotfiles variables
	Remove-Variable -Name 'Dotfiles.*' -Scope 'Global'
}
