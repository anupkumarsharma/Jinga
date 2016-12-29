
$parent = '..\'
$binDir = "$parent\bin"
$jingaDirectory = "$parent\jinga\"
$jingaBinDirectory = "$binDir\jinga\"
$jingaBinFunctionDirectory = "$binDir\jinga\Functions\"

# Run tests

# Create Package 


  if (Test-Path $jingaBinDirectory ) {Remove-Item $jingaBinDirectory -Recurse} 
  if (Test-Path $jingaBinFunctionDirectory ) {Remove-Item $jingaBinFunctionDirectory -Recurse}
 New-Item $jingaBinDirectory -ItemType directory | Out-Null
 New-Item $jingaBinFunctionDirectory -ItemType directory | Out-Null
@( "jinga.psm1","jinga.psd1" ) |% { Copy-Item $jingaDirectory$_ $jingaBinDirectory }
@( "Functions\*" ) |% { Copy-Item $jingaDirectory$_ $jingaBinFunctionDirectory }
	
# Run Nuget

