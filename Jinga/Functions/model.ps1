#
# Model.ps1
#

Class VariableModel{
	[string] $Name;
    [string] $TypeProperty;
	[string] $Value;
}

Class JingaModel {
	[String] $FileName;
    [String] $EnvironmentName;
	   [VariableModel[]]  $StringTypeCollection; 
	  [VariableModel[]]	$XpathTypeCollection; 
	   [VariableModel[]]	 $RegexCollection; 
  
}

Class YamlModel {
	 $SubstitutionModel ;
	[TypeModel] $TypeModel;
	}

Class SubstitutionModel {
	[String] $FileName;
    [String] $EnvironmentName;
	[System.Collections.HashTable] $SubstitutionCollection; 
  
}

Class TypeModel {
    [System.Collections.HashTable] $XpathType;
	[System.Collections.HashTable] $RegexType;
}

