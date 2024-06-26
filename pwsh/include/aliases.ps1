function Set-DotfilesAliases {

	$aliases = @{
		'gh' = 'Get-Help'
	}

	foreach ($a in $aliases.GetEnumerator()) {
		Set-Alias -Name $a.Key -Value $a.Value -Scope 'Global'
	}

	$aliases.Keys
}
