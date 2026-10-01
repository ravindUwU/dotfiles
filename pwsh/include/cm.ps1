if ($cm = "${global:Dotfiles.ContainerManager}".Trim()) {
	<#
	.SYNOPSIS
		Invokes the container manager.
	#>
	function cm {
		param (
			# Prevents the underlying command from being printed before invocation.
			[switch] $Raw
		)

		if (-not $Raw) {
			Write-Host "# $cm $args"
		}

		& $cm @args
	}

	& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'cm'

	<#
	.SYNOPSIS
		Invokes the `image` command of the container manager.
	#>
	function cmi {
		param (
			# Interactively select a short image name.
			[switch] $Select,

			# Interactively select a full image name.
			[switch] $SelectFull,

			# Prevents the underlying command from being printed before invocation.
			[switch] $Raw
		)

		if ($Select -or $SelectFull) {
			& $cm image list --format json `
				| ConvertFrom-Json `
				| Where-Object { $_.Tag, $_.Repository -notcontains '<none>' } `
				| ForEach-Object {
					$repo = if ($SelectFull) {
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
		else {
			if (-not $Raw) {
				Write-Host "# $cm image $args"
			}
			& $cm image @args
		}
	}

	& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'cmi'

	<#
	.SYNOPSIS
		Invokes the `container` command of the container manager.
	#>
	function cmc {
		param (
			# Interactively select a container name.
			[switch] $Select,

			# Prevents the underlying command from being printed before invocation.
			[switch] $Raw
		)

		if ($Select) {
			& $cm container list --format json `
				| ConvertFrom-Json `
				| ForEach-Object { $_.Names } `
				| fzf --height '30%'
		}
		else {
			if (-not $Raw) {
				Write-Host "# $cm container $args"
			}
			& $cm container @args
		}
	}

	& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'cmc'

	<#
	.SYNOPSIS
		Invokes the `compose` command of the container manager.
	#>
	function cmco {
		param (
			# Adds `--force-recreate --always-recreate-deps` to the invocation.
			[switch] $Recreate,

			# Prevents the underlying command from being printed before invocation.
			[switch] $Raw
		)

		if ($Recreate) {
			$args = $args + '--force-recreate', '--always-recreate-deps'
		}

		if (-not $Raw) {
			Write-Host "# $cm compose $args"
		}
		& $cm compose @args
	}

	& ((Get-Command 'Export-DotfilesFunction' -ErrorAction Ignore) ?? {}) 'cmco'
}
