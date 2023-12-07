function Out-VersionObject {
	param ( [string] $Name, [string] $Version, [string] $SP, [string] $Code )

	$InfoHash = @{
		Name    = $Name
		Version = $Version
		SP      = $SP
		Code    = $Code
	}

	$InfoStack = New-Object -TypeName PSObject -Property $InfoHash

	#Add a (hopefully) unique object type name
	$InfoStack.PSTypeNames.Insert(0, "DotNet.Version")

	#Sets the "default properties" when outputting the variable... but really for setting the order
	$defaultProperties = @('Name', 'Version', 'SP', 'Code')
	$defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet(‘DefaultDisplayPropertySet’, [string[]]$defaultProperties)
	$PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)
	$InfoStack | Add-Member MemberSet PSStandardMembers $PSStandardMembers


	if($InfoStack.Version -match "3.5"){Return $true}
}



# .Net less than 4.0
if (test-path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP') {
	Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\*' | ForEach-Object {
		if ($_.Version) {
			if ($_.SP) { $SP = [string] $_.SP } else { $SP = [string] "n/a" }
			Out-VersionObject -name $_.PSChildName -Version $_.Version -SP $SP -Code 'n/a'
		}
	}
}

$core = get-command -Name dotnet.exe -ErrorAction SilentlyContinue
if ($core) {
	$core | ForEach-Object {
		try {
			$result = & $_.Name --info
			if ($result) {
				$result = $result | ForEach-Object { if ($_) { $_ } }
				$CLI = $result | Select-String "Command Line Tools" -Context 3 -List
				if ($CLI) {
					$ver = $CLI[0].Context.PostContext | Select-String "Version"
					$ver = $ver.Line.Split(":")[1].Trim()
					$hash = $CLI[0].Context.PostContext | Select-String "hash"
					$hash = $hash.Line.Split(":")[1].Trim()
					$name = $CLI[0].Line
					if ($name) {
						Out-VersionObject -Name $name -Version $ver -SP "n/a" -Code $hash
					}
				}
				$Frame = $result | Select-String "Framework Host" -Context 0, 3 -List
				if ($Frame) {
					$ver = $Frame[0].Context.PostContext | Select-String "Version"
					$ver = $ver.Line.Split(":")[1].Trim()
					$hash = $Frame[0].Context.PostContext | Select-String "build"
					$hash = $hash.Line.Split(":")[1].Trim()
					$name = $Frame.Line
					if ($name) {
						Out-VersionObject -Name $name.Replace('Microsoft', '').Trim() -Version $ver -SP "n/a" -Code $hash
					}
				}
				$Hostver = $result | Select-String "^Host " -Context 0, 2 -List
				if ($Hostver) {
					$ver = $Hostver[0].Context.PostContext | Select-String "Version"
					$ver = $ver.Line.Split(":")[1].Trim()
					$hash = $Hostver[0].Context.PostContext | Select-String "commit"
					$hash = $hash.Line.Split(":")[1].Trim()
					$name = ".NET Core $($Hostver.Line.Replace(' (useful for support)', '').Replace(':', ''))"
					if ($name) {
						Out-VersionObject -Name $name.Replace('Microsoft', '').Trim() -Version $ver -SP "n/a" -Code $hash
					}
				}
				$SDK = $result | Select-String "dotnet\\sdk]$" -List
				if ($SDK) {
					$sdk | ForEach-Object {
						$ver = ($_.ToString().Trim() -split ' ')[0]
						$name = ".NET Core SDK"
						if ($ver) {
							Out-VersionObject -Name $name -Version $ver -SP "n/a" -Code ''
						}
					}
				}
				$Runtime = $result | Select-String "Microsoft.NETCore.App" -List
				if ($Runtime) {
					$Runtime | ForEach-Object {
						$ver = ($_.ToString().Trim() -split ' ')[1]
						$name = ".NET Core RunTime"
						if ($ver) {
							Out-VersionObject -Name $name -Version $ver -SP "n/a" -Code ''
						}
					}
				}
			}
		} catch {
			Write-Host ''
			Write-Host "Could not process/parse .Net Core via 'dotnet --info'" -ForegroundColor Yellow
			if ($PSVersionTable.PSVersion.Major -eq 2) {
				Write-Host '  Why are you still running PowerShell v2?!?!' -ForegroundColor Red
			}
		}
	}
}

