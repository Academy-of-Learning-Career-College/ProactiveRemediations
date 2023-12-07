if((Get-ScheduledTask -TaskName *rebootcsp*).Length -gt 0){
    if((Get-ScheduledTask -TaskName *rebootcsp*).State -eq "Enabled"){
    Return $false
}

} else {
    Get-ScheduledTask -TaskName *rebootcsp* | Disable-ScheduledTask
}
