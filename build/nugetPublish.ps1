$parentScript=  Split-Path -Parent $MyInvocation.MyCommand.Path
$parent = Split-Path -Parent $parentScript
write-host $parent
$binDir = "$parent\bin"
###.\nuget\nuget pack ".\nuget\jinga.nuspec" -Verbosity quiet -Version $version
& "$parentScript\nuget\NuGet.exe" pack "$parentScript\nuget\jinga.nuspec" -outputdirectory "$binDir\" -Verbosity quiet  -basepath "$binDir\"