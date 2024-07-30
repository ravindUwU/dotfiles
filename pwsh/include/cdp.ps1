<#
.SYNOPSIS
	Interactively browse projects located in the ~/Projects directory, and `cd` into the selection.
	Any extra arguments specified are used as the initial search term.

.EXAMPLE
	PS> ls ~/Projects
	p1
	p2

	PS ~/Projects> cdp
	>
	2/2
	  p1
	▌ p2

	PS ~/Projects/p2>

.EXAMPLE
	PS> cdp
	^C
	PS ~/Projects>

.EXAMPLE
	PS ~/Projects> cdp 2
	> 2
	1/2
	▌ p2

	PS ~/Projects/p2>

.NOTES
	Use ~/Dotfiles.Cdp.Projects.ps1 to configure subprojects,

		@{
			'<project>' = @{
				Subprojects = ('<subproject 1>', '<subproject 2>')
			}
		}
#>
function cdp {
	# Load config
	if (Test-Path "$HOME/Dotfiles.Cdp.Projects.ps1") {
		$config = . "$HOME/Dotfiles.Cdp.Projects.ps1"
	}

	Set-Location "$HOME/Projects"

	# Make list of projects
	$projects = Get-ChildItem -Directory | ForEach-Object {

		# Yield project
		$projectName = $_.Name
		$projectPath = $_.FullName
		[PSCustomObject]@{
			Name = $projectName
			Path = $projectPath
			ParentName = $null
		}

		# Yield subprojects
		($config[$_.Name].Subprojects ?? @()) | ForEach-Object {
			$subprojectName = "$projectName/$_"
			$subprojectPath = Join-Path $projectPath $_
			[PSCustomObject]@{
				Name = $subprojectName
				Path = $subprojectPath
				ParentName = $projectName
			}
		}
	}

	# Prompt for selection using fzf
	$selection = $projects | ForEach-Object { $_.Name } | `
		fzf --height '30%' --layout reverse $(if ($args) { '-q' ; "$($args -join ' ') " })

	# Find selected project & cd into it
	$project = $projects | Where-Object Name -eq $selection | Select-Object -First 1
	if ($null -ne $project) {
		[System.Console]::Title = $project.ParentName ?? $project.Name
		Set-Location $project.Path
	}
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'cdp'
