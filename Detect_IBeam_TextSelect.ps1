﻿$Path = "HKCU:\Control Panel\Cursors"
$Name = "IBeam"
$Type = "STRING"
$Value = "C:\WINDOWS\Cursors\beam_il.cur"

Try {
    $Registry = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
    If ($Registry -eq $Value){
        Write-Output "Compliant"
        Exit 0
    } 
    else
    {
    Write-Warning "Not Compliant"
    Exit 1
    }
} 
Catch {
    Write-Warning "Not Compliant"
    Exit 1
}