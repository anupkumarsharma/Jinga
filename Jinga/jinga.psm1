#region Third Party Modules - Todo - Replace with better mechanism
$relativePath = Split-Path -Parent $script:MyInvocation.MyCommand.Path
$relativePath=[string]::Join('\', $relativePath.Split('\')[0..$($relativePath.Split('\').Length-2)])
Import-Module @(Join-Path $relativePath "\vendors\PowerYaml.1.0.1\tools\PowerYaml.psm1")
#region  Functions
. $PSScriptRoot\Functions\fileoperations.ps1
. $PSScriptRoot\Functions\jingaoperations.ps1
. $PSScriptRoot\Functions\yamloperations.ps1
. $PSScriptRoot\Functions\model.ps1
. $PSScriptRoot\Functions\logger.ps1


<#
Bootstrapper will be delegated with all the initialization tasks. Like loading 3rd party libraries etc.  
#>
function Invoke-Jinga {

	 [CmdletBinding()]
	   param(
        [Parameter(Position=0,Mandatory=1)][string]$file,
	    [Parameter(Position=1,Mandatory=1)][string]$backup,
		[Parameter(Position=2,Mandatory=1)][string]$environmentType,
		[Parameter(Position = 3, Mandatory = 0)][switch] $nologo = $false
		   )
		  
	 if (-not $nologo) {
           Write-Host "Jinga- author anup sharma" -ForegroundColor White
        }
		  
			[YamlModel] $yamlModel = Run-YamlOperations -YamlFilePath $file -EnvironmentType $environmentType
	        if($yamlModel -ne $null) {[JingaModel[]] $JingaModel  =  Run-JingaOperation -YamlModel $yamlModel}
			if($JingaModel -ne $null) {Run-FileOperations -JingaModel $JingaModel  -backupPath $backup }
		
}

export-modulemember -function Invoke-Jinga