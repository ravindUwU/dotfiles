param (
	# May include,
	#     [bool] UsePrompt
	#     [bool] UseAutoCd
	#     [bool] UseUtf8
	[hashtable] $Options
)

${script:exportedFunctions} ??= @()

<#
.SYNOPSIS
	Registers a function name to be exported by the Dotfiles module.
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

# Install requested features
if ($Options.UsePrompt) { Install-DotfilesPrompt }
if ($Options.UseAutoCd) { Install-DotfilesAutoCd }
if ($Options.UseUtf8) { Install-DotfilesUtf8 }

# Clean up if the module is removed
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/remove-module?view=powershell-7.4#example-5-using-the-onremove-event
$ExecutionContext.SessionState.Module.OnRemove += {

	# Uninstall previously installed features
	if ($Options.UsePrompt) { Uninstall-DotfilesPrompt }
	if ($Options.UseAutoCd) { Uninstall-DotfilesAutoCd }
	if ($Options.UseUtf8) { Uninstall-DotfilesUtf8 }

	# Remove Dotfiles variables
	Remove-Variable -Name 'Dotfiles.*' -Scope 'Global'
}
