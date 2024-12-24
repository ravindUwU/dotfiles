param (
	# May include,
	#     [bool] UsePrompt
	[hashtable] $Options
)

${script:exportedFunctions} ??= @()

<#
.SYNOPSIS
	Registers a function name to be exported by the Dotfiles module.

	Conditionally invoke as,
		& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) '<name>'
#>
function Export-DotfilesFunction {
	param ([string] $name)
	${script:exportedFunctions} += $name
}

# Source includes
foreach ($file in (Get-ChildItem "$PSScriptRoot/include/*.ps1" -ErrorAction Stop)) {
	. $file
}

# Export members
Export-ModuleMember `
	-Function ${script:exportedFunctions} `
	-Alias (Set-DotfilesAliases)

# Install prompt if requested
if ($Options.UsePrompt) {
	Install-DotfilesPrompt
}

# Clean up if the module is removed
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/remove-module?view=powershell-7.4#example-5-using-the-onremove-event
$ExecutionContext.SessionState.Module.OnRemove += {

	# Uninstall prompt if previously installed
	if ($Options.UsePrompt) {
		Uninstall-DotfilesPrompt
	}

	# Remove Dotfiles variables
	Remove-Variable -Name 'Dotfiles.*' -Scope 'Global'
}
