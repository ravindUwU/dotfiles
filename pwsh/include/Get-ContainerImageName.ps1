function Get-ContainerImageName {
	[CmdletBinding()]
	[OutputType([string])]
	param (
		[Parameter()]
		[switch] $Full
	)

	podman image list --format json `
		| ConvertFrom-Json `
		| Where-Object { $_.Tag, $_.Repository -notcontains '<none>' } `
		| ForEach-Object {
			$repo = if ($Full) {
				$_.Repository
			} else {
				$_.Repository `
					-replace '^docker.io/library/','' `
					-replace '^docker.io/',''
			}
			"$($repo):$($_.Tag)"
		} `
		| fzf --height '30%'
}

& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'Get-ContainerImageName'
