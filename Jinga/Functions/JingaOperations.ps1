#
# JingaOperations.ps1
#
. $PSScriptRoot\model.ps1


function Run-JingaOperation 
{
	Param (
		 [Parameter(Mandatory=$true)] 
         [YamlModel]  $YamlModel )
	     [JingaModel[]] $JingaModelCollection = @()

	foreach ($model in $YamlModel.SubstitutionModel) {
	$jingaModel = 	Get-JingaFactoryObject
		$jingaModel.FileName = $model.FileName;
		foreach ($Submodel in $model.SubstitutionCollection.GetEnumerator()) {
			 if($YamlModel.TypeModel.XpathType.ContainsKey($Submodel.Key))
			{
				 $jingaModel.XpathTypeCollection+=Add-VariableToCollection $Submodel $YamlModel.TypeModel.XpathType[$Submodel.Key]
				continue;
			}
				 if($YamlModel.TypeModel.RegexType.ContainsKey($Submodel.Key))
			{
				 $jingaModel.RegexCollection+=Add-VariableToCollection $Submodel $YamlModel.TypeModel.RegexType[$Submodel.Key]
				continue;
			}
			$jingaModel.StringTypeCollection+=Add-VariableToCollection  $Submodel $YamlModel.TypeModel.XpathType[$Submodel.Key]
		}
		$JingaModelCollection+=$jingaModel;
		}
	
		return $JingaModelCollection;
}

function Get-JingaFactoryObject()
{
		$jingaModel = New-Object JingaModel
		$jingaModel.StringTypeCollection = @()
		$jingaModel.XpathTypeCollection = @()
		$jingaModel.RegexCollection = @()
	return $jingaModel;
}

function Add-VariableToCollection($model,$typeProperty)
{
	$variable = New-Object VariableModel;
	$variable.Name = $model.Key;
	$variable.Value = $model.Value;
	$variable.TypeProperty = $typeProperty;
	return $variable;

}