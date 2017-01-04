#
# FileOperations.ps1
#
. $PSScriptRoot\model.ps1
. $PSScriptRoot\logger.ps1
#$parentScript=  Split-Path -Parent $MyInvocation.MyCommand.Path
$relativePath = $(Get-Location)
function Run-FileOperations
{
	Param (
		 [Parameter(Mandatory=$true)] 
         [JingaModel[]]  $JingaModel ,
		 [Parameter(Mandatory=$true)] 
		 [string] $backupPath,
		 [Parameter(Mandatory=$false)]
		 [string]$scriptPath 
)
	if ($scriptPath) {
		$relativePath = $scriptPath
		}

	Log-Console -message "Backup Folder Configured - $backupPath" -level 'Info'
	Process-VairableSubstitutions -JingaModel $JingaModel  -backupPath $backupPath
	Log-Console -message "Running File Operations" -level 'Info'
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
		Log-Console -message "Initiating Process For File- $($relativeFile)" -level 'Info'
		 if (-not (Test-Path $relativeFile ) ) {
		 Log-Console -message "Skipped.Unable to locate file." -level 'Warn'
		 }else
		{
		Backup-Copy -file $relativeFile -backupPath $backupPath;
	    #Process String and Regex
		Replace-FileStringTokens -file $relativeFile -stringTokenList  $jingaModel.StringTypeCollection -regexTokenList $jingaModel.RegexCollection
		#Process Xpath 
		Replace-FileXpathTokens -file $relativeFile  -tokenlist $jingaModel.XpathTypeCollection
		Log-Console -message "Successfully Processed" -level 'Info'
		}
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
		Log-Console -message "File have no content or bad format" -level 'Warn'
	return;
}

	if($stringTokenList.Count -eq 0 -and $regexTokenList.Count -eq 0)
	{
		Log-Console -message "No string/regex token defined" -level 'Warn'
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
		Log-Console -message "File have no content or bad format" -level 'Warn'
	return;
}

if($tokenList.Count -eq 0)
 {
	 Log-Console -message "No xpath token defined" -level 'Warn'
	 return;
 }

	try{
       $xml = [xml] [System.IO.File]::ReadAllText($file) 
		}
	catch 
	{
	    ### IF not well formed XML then just ignore	
		Log-Console -message  $_.Exception.Message -level 'Verbose'
		Log-Console -message "Invalid XML file" -level 'Warn'
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