Function JumpModule() {
	param(
		[Parameter(Position=0)]
		[string]$command,
		[Parameter(Position=1)]
		[string]$nickname,
		[Parameter(Position=2)]
		[string]$id
	)

	# Define the path to the file where we'll store the nicknames and IDs
	$filePath = Join-Path $env:USERPROFILE "jump.txt"

	# Check if the file exists, if not, create it
	if (!(Test-Path $filePath)) {
		New-Item -ItemType File -Path $filePath -Force
	}

	# Handle the 'add' command
	if ($command -eq "add") {
		# Check if the nickname already exists
		$content = Get-Content $filePath
		$content = $content | Where-Object { $_ -notmatch "^$nickname " }

		# Add (or replace) the nickname and ID in the file
		$content += "`n$nickname $id"
		$content | Set-Content $filePath
	}
	# Handle the 'delete' command
	elseif ($command -eq "delete") {
		# Remove the nickname and ID from the file
		$content = Get-Content $filePath
		$content = $content | Where-Object { $_ -notmatch "^$nickname " }
		$content | Set-Content $filePath
	}
	# Handle the 'list' command
	elseif ($command -eq "list") {
		# Print all nicknames and IDs
		Get-Content $filePath
	}
	# Handle the 'help' command
	elseif ($command -eq "help") {
		# Define the available commands and their descriptions
		$commands = @{
			"add" = "Add a nickname and ID to the file."
			"delete" = "Delete a nickname and ID from the file."
			"list" = "List all nicknames and IDs."
			"help" = "List available commands and their descriptions."
			"<nickname>" = "Connect to the server with the specified nickname."
		}

		# Print the available commands and their descriptions
		$commands.GetEnumerator() | ForEach-Object {
			Write-Output "$($_.Key): $($_.Value)"
		}
	}
	elseif ($command -like "i-*") {
		# If the command starts with 'i-', assume it's a target for SSM session
		$id = $command.Substring(2)
		aws ssm start-session --profile default --target $command
	}
	else {
		# If the command isn't 'add', 'delete', 'list', 'help', or starts with 'i-', we assume it's a nickname
		$nickname = $command

		# Check if the nickname exists in the file
		$line = Get-Content $filePath | Where-Object { $_ -match "^$nickname " }

		if ($line) {
			# If the nickname exists, extract the ID and run the SSH command
			$id = $line.Split(' ')[1]
			aws ssm start-session --profile default --target $id
			#ssh "ubuntu@$id"
		}
		else {
			# If the nickname doesn't exist, print an error message
			Write-Error "Nickname / Command not found"
		}
	}
}

New-Alias -Name jump -Value JumpModule -Scope Global
Export-ModuleMember -Function 'JumpModule' -Alias 'jump'