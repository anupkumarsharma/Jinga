#region Third Party Modules 
  Import-Module 'C:\Workspace_Anup-SeedProject\Jinga\PowerYaml-master\PowerYaml.psm1'
#region  Functions
. $PSScriptRoot\Functions\fileoperations.ps1
. $PSScriptRoot\Functions\jingaoperations.ps1
. $PSScriptRoot\Functions\yamloperations.ps1
. $PSScriptRoot\Functions\model.ps1


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
            "jinga"
        }
	$file = "C:\Workspace_Anup-SeedProject\Jinga\Sample.yaml"
	$backup = 'C:\Workspace_Anup-SeedProject\Jinga\Backup'
	  try {
	[YamlModel] $yamlModel = Run-YamlOperations -YamlFilePath $file -EnvironmentType 'development'
	[JingaModel[]] $JingaModel  =  Run-JingaOperation -YamlModel $yamlModel
	Run-FileOperations -JingaModel $JingaModel  -backupPath $backup 
		  }
	catch {
      
		}
	
}

export-modulemember -function Invoke-Jinga