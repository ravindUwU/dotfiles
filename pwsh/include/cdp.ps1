<#
.SYNOPSIS
	Open a project located in the ~/Projects directory.

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

	# Make list of projects
	$projects = Get-ChildItem "$HOME/Projects" -Directory | ForEach-Object {

		# Yield project
		$projectName = $_.Name
		$projectPath = $_.FullName
		[PSCustomObject]@{
			Name = $projectName
			Path = $projectPath
		}

		# Yield subprojects
		($config[$_.Name].Subprojects ?? @()) | ForEach-Object {
			$subprojectName = "$projectName/$_"
			$subprojectPath = Join-Path $projectPath $_
			[PSCustomObject]@{
				Name = $subprojectName
				Path = $subprojectPath
			}
		}
	}

	# Prompt for selection using fzf
	$selection = $projects | ForEach-Object { $_.Name } | fzf --height '30%' --layout reverse

	# Find selected project & cd into it
	$project = $projects | Where-Object Name -eq $selection | Select-Object -First 1
	if ($null -ne $project) {
		Set-Location $project.Path
	}
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'cdp'
