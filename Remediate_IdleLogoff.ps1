Get-ChildItem -Path c:\ -Filter "*idlelogoff*" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force
