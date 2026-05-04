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
#>
function cdp {
	$projectRoot = "$HOME/Projects"

	# Make list of projects
	$projects = @(
		[PSCustomObject]@{
			Name = "/"
			Path = $projectRoot
			ParentName = $null
		}

		Get-ChildItem $projectRoot -Directory | ForEach-Object {
			# Yield project
			$projectName = $_.Name
			$projectPath = $_.FullName
			[PSCustomObject]@{
				Name = $projectName
				Path = $projectPath
				ParentName = $null
			}
		}
	)

	# Prompt for selection using fzf
	$selection = $projects | ForEach-Object { $_.Name } | `
		fzf --height '30%' --layout reverse $(if ($args) { '-q' ; "$($args -join ' ') " })

	# Find selected project & cd into it
	$project = $projects | Where-Object Name -eq $selection | Select-Object -First 1
	if ($null -ne $project) {
		cd $project.Path

		if ('/' -ne $project.Name) {
			[System.Console]::Title = $project.ParentName ?? $project.Name
		}
	}
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'cdp'
