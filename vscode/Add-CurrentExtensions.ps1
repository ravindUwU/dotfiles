<#
.SYNOPSIS
	Adds currently installed VSCode extensions to the list of extensions recommended in the Dotfiles
	VSCode workspace.
#>

try {
	$file = (Resolve-Path "$PSScriptRoot/../.vscode/extensions.json").Path

	$exts = [System.Collections.Generic.HashSet[string]]::new([string[]](
		[string[]](Get-Content $file | ConvertFrom-Json).recommendations `
			| ForEach-Object { $_.ToLower() }
	))

	foreach ($ext in [string[]](code --list-extensions)) {
		$exts.Add($ext.ToLower()) | Out-Null
	}

	@{
		recommendations = $exts | Sort-Object
	} `
		| ConvertTo-Json `
		| jq --tab `
		| Out-File $file -Encoding utf8

	# No trailing commas :( but that's okay
}
catch {
	$_
}
