
# YamlOperations.ps1
#
. $PSScriptRoot\model.ps1
. $PSScriptRoot\logger.ps1

function Run-YamlOperations
{
	param(
		 [Parameter(Mandatory=$true)] [string]$YamlFilePath ,
		 [Parameter(Mandatory=$true)][string]$EnvironmentType,
		 [Parameter(Mandatory=$false)][string] $scriptPath
	
	)
	 #Locate Yaml file
	 $yamlRelativePath = Find-YamlFile $YamlFilePath $scriptPath
	 #Get YAML From File
	 $yamlContent = Read-Yaml $yamlRelativePath;
	 #Get YAML Model
	 $model = New-Object YamlModel
	 $model.SubstitutionModel = Parse-Yaml $yamlContent $EnvironmentType
	 $model.TypeModel =  Parse-Defination $yamlContent 
	Log-Console -message "Running YAML Operations - Done" -level 'Info'
	return $model;
}



function Read-Yaml ([string] $YamlFilePath) {
	Log-Console -message "Yaml file path configured - $($YamlFilePath)" -level 'Info'
#Write-Host "Yaml file path configured:$($YamlFilePath)"
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

function Get-RelativePath($filePath)
{
	return Join-Path $relativePath $filePath
}

function Validate-File($filepath)
{
	  if(Test-Path $filepath){
			return $relativeFile;
		}
	  else { return $false;}

	
}

### Helps locate the Yaml file, Folks might want to hard code the path, pass script executing path, or assume it should pick from  PWD
function Find-YamlFile($filePath,$scriptPath)
{

if ($scriptPath) {
	  # If script path is passed check, if script path contains the yaml file
		 $relativeFile = Join-Path $scriptPath $filePath
	   if(Test-Path $relativeFile){ return $relativeFile; }  else {
		  # write -Verbose 'Not found $($relativeFile)'
		   Log-Console -message "Not found $($relativeFile)" -level 'Verbose'
	   }
	}
	# If no,  Check if the yaml file can be located by absolute Yaml path 
        if(Test-Path $filePath){  return $filePath; } else {
			#write -Verbose 'Not found $($filePath)'
			  Log-Console -message "Not found $($filePath)" -level 'Verbose'
		}
	     $relativeFile = Join-Path $(Get-Location) $filePath 
	# If no, Check if the yaml file can be located in current script path 
	    if(Test-Path $relativeFile){  return $relativeFile;  }  else {write -Verbose 'Not found $($relativeFile)'}
	  Log-Console -message "Unable to locate yaml file - $YamlFilePath" -level 'Error'
	 # Write-Error " Unable to locate yaml file - $YamlFilePath"
	  Break;
}