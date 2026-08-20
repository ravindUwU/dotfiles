function Get-ContainerName {
	[CmdletBinding()]
	[OutputType([string])]
	param ()

	podman container list --format json `
		| ConvertFrom-Json `
		| ForEach-Object { $_.Names | ForEach-Object { $_ } }
		| fzf --height '30%'
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'Get-ContainerName'
