
# YamlOperations.ps1
#
. $PSScriptRoot\model.ps1
function Run-YamlOperations
{
	param(
		 [Parameter(Mandatory=$true)]
		 [string]$YamlFilePath ,
		 [Parameter(Mandatory=$true)]
		 [string]$EnvironmentType)
	 Write-Host "Running YAML Operations - Start"
	 #validate file path
	if ($YamlFilePath -eq $null) {
	Write-Warning "$file File have no content or bad format"
	return;
	}
    if (-not (Test-Path $YamlFilePath ) ) {
	 Write-Error " Unable to locate yaml file - $YamlFilePath"
	  Break;
	}
	 #Get YAML From File
	 $yamlContent = Read-Yaml $YamlFilePath;
	 #Get YAML Model
	 $model = New-Object YamlModel
	 $model.SubstitutionModel = Parse-Yaml $yamlContent $EnvironmentType
	 $model.TypeModel =  Parse-Defination $yamlContent 
	 Write-Host "Running YAML Operations - Done"
	return $model;
}



function Read-Yaml ([string] $YamlFilePath) {
Write-Host "Yaml file path configured:$($YamlFilePath)"
$yaml = Get-Yaml -FromFile (Resolve-Path $YamlFilePath) 
#Validate YAML 
Validate-YamlStructure $yaml
return  $yaml
}

function Parse-Yaml {
	param(
		 [Parameter(Mandatory=$true)] 
		[System.Collections.HashTable]$yaml , 
		 [Parameter(Mandatory=$true)]
		[String]$EnvironmentName)
	$SubstitutionModel = @()
	#Find each setting 
	foreach ($configuration in $yaml.Configuration) {
		foreach ($Setting in $configuration.RuleSet) {
	         $TextCollection= @{}
			foreach ($Substitue in  $Setting.Substitute.GetEnumerator()) {
				if($Substitue.Key -eq $EnvironmentName)
				{
						$Substitue.Value.GetEnumerator()| % { $TextCollection.Add($_.Key,$_.Value)}
					break;
				}
				}
			
				$model = New-Object SubstitutionModel
			    $model.FileName = $Setting.File
				$model.SubstitutionCollection = $TextCollection;
			$SubstitutionModel += $model;
		}
	
}
	return $SubstitutionModel;
}

function Parse-Defination($yaml)
{
	$typeModel = New-Object TypeModel;
	$typeModel.RegexType = @{}
	$typeModel.XpathType = @{}
	foreach ($configuration in $yaml.Configuration) {
		foreach ($Define in $configuration.Define) {
			  $Define.TypeXpath.GetEnumerator()| % { $typeModel.XpathType.Add($_.Key,$_.Value)}
			  $Define.TypeRegEx.GetEnumerator()| % { $typeModel.RegexType.Add($_.Key,$_.Value)}
			}
	}
	return $typeModel;
}

function Validate-YamlStructure ($yamlContent){

}