$parent = '..\'
$psdPath = Join-Path $parent Jinga\jinga.psd1

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
    Remove-Item $binDir -Recurse -Force
}


Copy-Item -Recurse $dir\install $binDir\tools
Copy-Item -Recurse $dir\vendors $binDir\vendors


