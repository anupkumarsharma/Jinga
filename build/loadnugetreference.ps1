$parentScript=  Split-Path -Parent $MyInvocation.MyCommand.Path
$parent = Split-Path -Parent $parentScript
write-host $parent
write-host "$parentScript\vendors"
$binDir = "$parentScript\vendors" 
Remove-Item "$parentScript\vendors\" -Recurse  -ErrorAction Ignore 
& "$parentScript\nuget\NuGet.exe" install "$parentScript\nuget\packages.config" -o "$parentScript\vendors\"
