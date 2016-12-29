#
# FileOperations.ps1
#
. $PSScriptRoot\model.ps1

function Run-FileOperations
{
	Param (
		 [Parameter(Mandatory=$true)] 
         [JingaModel[]]  $JingaModel ,
		 [Parameter(Mandatory=$true)] 
		 [string] $backupPath)

	Write-Host "Running File Operations For $file - Start"
	Process-VairableSubstitutions -JingaModel $JingaModel  -backupPath $backupPath
	Write-Host "Running File Operations - Done"
}


function Process-VairableSubstitutions
{
	param (
		 [Parameter(Mandatory=$true)] 
         [JingaModel[]]  $JingaModel,
		 [Parameter(Mandatory=$true)]  
		 [string] $backupPath )

	foreach($model in $JingaModel.GetEnumerator())
	{
		[JingaModel]$jingaModel = $model;
		Write-Host
		Backup-Copy -file $jingaModel.FileName -backupPath $backupPath;
	 #Process String and Regex
		Replace-FileStringTokens -file $jingaModel.FileName -stringTokenList  $jingaModel.StringTypeCollection -regexTokenList $jingaModel.RegexCollection
		 #Process Xpath 
		Replace-FileXpathTokens -file $jingaModel.FileName  -tokenlist $jingaModel.XpathTypeCollection
	}
}

function Backup-Copy {
	param (
		 [Parameter(Mandatory=$true)] 
         [string] $file,
		 [Parameter(Mandatory=$true)] 
		 [string] $backupPath)

    if (-not (Test-Path $backupPath ) ) {
        New-Item $backupPath -ItemType directory | Out-Null
    }
        Copy-Item $file $backupPath -Force -ErrorAction SilentlyContinue
    $fileName = (Get-Item $file).Name
   Write-Host  "$backupPath\$fileName"
}
 


function Replace-FileStringTokens{
	param (
		 [Parameter(Mandatory=$true)] 
         [string] $file ,
		 [Parameter(Mandatory=$true)] 
         [VariableModel[]] $stringTokenList ,
		 [Parameter(Mandatory=$true)] 
		 [VariableModel[]] $regexTokenList 
) 
	   if (-not (Test-Path $file ) ) {
		   throw exception("$file File have no content or bad format");
		   }
if ($file -eq $null) 
{
	Write-Warning "$file File have no content or bad format"
	return;
   # throw exception("$file File have no content or bad format");
}

# Take the buffer and replace the string tokens
		$content = [System.IO.File]::ReadAllText($file)
	foreach ($h in $stringTokenList) {
		$content =$content.Replace($h.Name,$h.Value)
}

	foreach ($h in $regexTokenList) {
		$content =$content -replace $h.TypeProperty,$h.Value
}

[System.IO.File]::WriteAllText($file, $content)
}

function  Replace-FileXpathTokens{
	param (
		 [Parameter(Mandatory=$true)] 
    [string] $file ,
		 [Parameter(Mandatory=$true)] 
    [VariableModel[]] $tokenList
) 

 if (-not (Test-Path $file ) ) {
		   throw exception("$file File have no content or bad format");
		   }
if ($file -eq $null) 
{
	Write-Warning "$file File have no content or bad format"
	return;
   # throw exception("$file File have no content or bad format");
}
		
$xml = [xml] [System.IO.File]::ReadAllText($file) 
	foreach ($h in $tokenList) {
		Edit-XmlNodes $xml -xpath $h.TypeProperty -value $h.Value
}

$xml.save($file)
	}

function Edit-XmlNodes {
param (
	 [Parameter(Mandatory=$true)] 
    [xml] $doc ,
	 [Parameter(Mandatory=$true)] 
    [string] $xpath ,
	 [Parameter(Mandatory=$true)] 
    [string] $value ,
    [bool] $condition = $true
)    
    if ($condition -eq $true) {
        $nodes = $doc.SelectNodes($xpath)
         
        foreach ($node in $nodes) {
            if ($node -ne $null) {
                if ($node.NodeType -eq "Element") {
                    $node.InnerXml = $value
                }
                else {
                    $node.Value = $value
                }
            }
        }
    }
}