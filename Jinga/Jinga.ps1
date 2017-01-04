# Invocation Script of Jinga

 param(
        [Parameter(Position=0,Mandatory=1)][string]$yamlFile,
	    [Parameter(Position=1,Mandatory=1)][string]$backup,
		[Parameter(Position=2,Mandatory=1)][string]$environmentType,
		[Parameter(Position=3, Mandatory=0)][string]$scriptPath,
		[Parameter(Position = 4, Mandatory = 0)][switch] $nologo = $false
	         
	    
 )
write-host $scriptPath
if (!$scriptPath) {
  $scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.path)
}

 $moduleBasePath = $(Split-Path -parent $MyInvocation.MyCommand.path)
Remove-Module jinga -ErrorAction Ignore 
Remove-Module PowerYaml -ErrorAction Ignore 
import-module (join-path $moduleBasePath '\vendors\PowerYaml.1.0.1\tools\PowerYaml.psm1')
import-module (join-path $moduleBasePath jinga.psm1)
if ($help) {
  Get-Help Invoke-jinga -full
  return
}

Invoke-jinga $yamlFile $backup $environmentType  $scriptPath $nologo 
