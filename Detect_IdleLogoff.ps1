(Get-ChildItem -Path c:\ -Filter "*idlelogoff*" -Recurse -ErrorAction SilentlyContinue).Count -gt 0
