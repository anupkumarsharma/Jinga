$parentScript=  Split-Path -Parent $MyInvocation.MyCommand.Path
$parent = Split-Path -Parent $parentScript
#$parent = '..\'
$binDir = "$parent\bin"
$jingaDirectory = "$parent\jinga\"
$jingaBinDirectory = "$binDir\jinga\"
$jingaBinFunctionDirectory = "$binDir\jinga\Functions\"
$jingaBuildDirectory = "$parent\build\"

# Run tests

#Get Nuget Package 
$binDir = "$parent\bin"
if (Test-Path $binDir -PathType container) {
    Remove-Item -Recurse -Force $binDir
}

& $jingaBuildDirectory\loadnugetreference.ps1
#Create package 
& $jingaBuildDirectory\nugetBuild.ps1

# Add jinga Package 


  if (Test-Path $jingaBinDirectory ) {Remove-Item $jingaBinDirectory -Recurse} 
  if (Test-Path $jingaBinFunctionDirectory ) {Remove-Item $jingaBinFunctionDirectory -Recurse}
 New-Item $jingaBinDirectory -ItemType directory | Out-Null
 New-Item $jingaBinFunctionDirectory -ItemType directory | Out-Null
@( "jinga.psm1","jinga.psd1" ) |% { Copy-Item $jingaDirectory$_ $jingaBinDirectory }
@( "Functions\*" ) |% { Copy-Item $jingaDirectory$_ $jingaBinFunctionDirectory }
	
# Run Nuget

