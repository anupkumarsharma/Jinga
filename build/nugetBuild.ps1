## This nuget script is invoked by build.ps, to create a nuget package.
$parentScript=  Split-Path -Parent $MyInvocation.MyCommand.Path
$parent = Split-Path -Parent $parentScript # '..\'
$psdPath = Join-Path $parent Jinga\jinga.psd1

write-host  $parent 
try
{
    $manifest = Test-ModuleManifest -Path $psdPath -WarningAction SilentlyContinue -ErrorAction Stop
    $version = $manifest.Version.ToString()
}
catch
{
    throw
}

"Version number $version"

$binDir = "$parent\bin"
if (Test-Path $binDir -PathType container) {
    Remove-Item -Recurse -Force $binDir  -ErrorAction Ignore 	
}

Copy-Item -Recurse $parentScript\install $binDir\tools
Copy-Item -Recurse $parentScript\vendors $binDir\vendors


