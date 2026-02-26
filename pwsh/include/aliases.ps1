function Set-DotfilesAliases {

	$aliases = @{
		'gh' = 'Get-Help'
		'sl' = 'hehe'
	}

	foreach ($a in $aliases.GetEnumerator()) {
		Set-Alias -Name $a.Key -Value $a.Value -Scope 'Global' -Force
	}

	$aliases.Keys
}
