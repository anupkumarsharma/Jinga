

param($installPath, $toolsPath, $package)
write-host 'Starting Init script ' 
write-host $toolsPath
write-host  $installPath
write-host  $package
$jingaModule = Join-Path $installPath 'jinga.psm1'
$powerYAmlModule = Join-Path $installPath '\vendors\PowerYaml.1.0.1\tools\PowerYaml.psm1'
import-module $powerYAmlModule
import-module $jingaModule


