#
# FileOperations.ps1
#
. $PSScriptRoot\model.ps1
#$parentScript=  Split-Path -Parent $MyInvocation.MyCommand.Path
$relativePath = $(Get-Location)
function Run-FileOperations
{
	Param (
		 [Parameter(Mandatory=$true)] 
         [JingaModel[]]  $JingaModel ,
		 [Parameter(Mandatory=$true)] 
		 [string] $backupPath)
	Write-Host "Running File Operations For $file - Start"
	Write-Host "Backup Folder Configured - $backupPath"
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
		$relativeFile =  Get-RelativePath $jingaModel.FileName
		Write-Host 'Processing file -'$relativeFile
		Backup-Copy -file $relativeFile -backupPath $backupPath;
	    #Process String and Regex
		Replace-FileStringTokens -file $relativeFile -stringTokenList  $jingaModel.StringTypeCollection -regexTokenList $jingaModel.RegexCollection
		#Process Xpath 
		Replace-FileXpathTokens -file $relativeFile  -tokenlist $jingaModel.XpathTypeCollection
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
        Copy-Item $file $backupPath -Force -ErrorAction Stop
}
 


function Replace-FileStringTokens{
	param (
		 [Parameter(Mandatory=$true)] 
         [string] $file ,
		 [Parameter(Mandatory=$true)]  [AllowEmptyCollection()]
         [VariableModel[]] $stringTokenList ,
		 [Parameter(Mandatory=$true)]  [AllowEmptyCollection()]
		 [VariableModel[]] $regexTokenList 
) 
	  if ($file -eq $null) 
{
	Write-Warning "$file File have no content or bad format"
	return;
}
 if (-not (Test-Path $file ) ) {
	 Write-Warning "$file Unable to locate file"
	 return;
}
	if($stringTokenList.Count -eq 0 -and $regexTokenList.Count -eq 0)
	{
		Write-Warning 'No string/regex token defined'
		return;
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
		 [Parameter(Mandatory=$true)]  [AllowEmptyCollection()]
         [VariableModel[]] $tokenList
) 
if ($file -eq $null) 
{
	Write-Warning "$file File have no content or bad format"
	return;
}
 if (-not (Test-Path $file ) ) {
	 Write-Warning "$file Unable to locate file"
	 return;
}

if($tokenList.Count -eq 0)
 {
	 Write-Warning 'No xpath token defined'
	 return;
 }

	try{
       $xml = [xml] [System.IO.File]::ReadAllText($file) 
		}
	catch 
	{
	    ### IF not well formed XML then just ignore	
		Write-Verbose -Message $_.Exception.Message
		Write-Warning "Invalid XML file $($file) - file skipped"
		return;
	}
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


function Get-RelativePath($filePath)
{
	return Join-Path $relativePath $filePath
}