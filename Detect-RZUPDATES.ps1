#Check for RZGet
$scriptsdir = Join-Path $env:SystemDrive scriptfiles
$rzget = Join-Path $scriptsdir rzget.exe
$rzurl = "https://github.com/rzander/ruckzuck/releases/latest/download/RZGet.exe"

if(!(Test-Path $rzget)) {
    # Write-Debug RZGet does not exist, downloading
    if(!(Test-Path $scriptsdir)){mkdir $scriptsdir}
    iwr -Uri $rzurl -UseBasicParsing -OutFile $rzget
}

#Check for updates
$rzupdates = & $rzget update --list --all

if($rzupdates.Length -eq 0){
    $true
} else {
    $false
}


