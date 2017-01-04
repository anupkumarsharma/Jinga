 #
# e2e.ps1
#




function Get-RelativePath([string] $filePath)
{
	$root =  Join-Path $(Get-Location) "test\" 
	return Join-Path $root  $filePath
}

[string] $backupfilePath = @(Get-RelativePath 'workingDir\Backup')

### Import Module 
Remove-Module jinga -ErrorAction Ignore 
Import-Module @(Join-Path $(Get-Location) "\bin\jinga\Jinga.psm1")
$global:resultSet =  @()


function JingaShouldReplaceallTheStringTokenDefinedInYaml_Fact(){
#### Prepare
Clean-WorkingDirectory
copy-stringtypestubfiles
[string]$yamlFilepath =  @(Get-RelativePath 'testFiles\StringReplacement.yaml')
Invoke-Jinga  $yamlFilepath $backupfilePath 'development' $True
##Validate 
$r = validate-backupfiles 2
publish-result $r
$r = validate-stringReplacedFiles
publish-result $r 
############

}

function JingaShouldReplaceallTheXpathTokenDefinedInYaml_Fact(){
#### Prepare
Clean-WorkingDirectory
copy-xpathgtypestubfiles
[string]$yamlFilepath =  @(Get-RelativePath 'testFiles\XpathReplacement.yaml')
Invoke-Jinga  $yamlFilepath $backupfilePath 'development' $True
##Validate 
$r = validate-backupfiles 2
publish-result $r
$r = validate-xpathReplacedFiles
$returnValue =  publish-result $r 
write-host $returnValue
############
############

}


function JingaShouldReplaceallTheRegexTokenDefinedInYaml_Fact(){
#### Prepare
Clean-WorkingDirectory
copy-regexgtypestubfiles
[string]$yamlFilepath =  @(Get-RelativePath 'testFiles\RegexReplacement.yaml')
Invoke-Jinga  $yamlFilepath $backupfilePath 'development' 
##Validate 
$r = validate-backupfiles 2
publish-result $r
$r = validate-regexReplacedFiles
$returnValue =  publish-result $r 
write-host $returnValue
############
############

}



function publish-result($result,$final= 0)
{

 if($final -eq 1)
 {
   $isSuccess = $true
   $resultSet| ForEach-Object { if( $_ -like "*Success*" ) { Write-Host $_ -ForegroundColor Green} else {Write-Host $_ -ForegroundColor Red}}
   $resultSet| ForEach-Object {  if( $_ -like "*Failed*" -or $_ -like "*Failure*" ) { $isSuccess = $false;}}
 return $isSuccess
 }

 $global:resultSet+= $result
}

function Clean-WorkingDirectory(){
Remove-Item @(Get-RelativePath 'workingDir\') -Recurse -ErrorAction Ignore 
Remove-Item $backupfilePath -Recurse -ErrorAction Ignore 
}

function validate-backupfiles($fileCount){
# go to the folder and check the files is exists
$totalCount = (Get-ChildItem  $backupfilePath | Measure-Object ).Count

if($totalCount -ne $fileCount)
{
  return "Assert - Backup count - Failed"
}
else
{
  return "Assert - Backup count - Success"
}
}

function copy-stringtypestubfiles(){
xcopy @(Get-RelativePath 'specFiles\stringR_File1.config') @(Get-RelativePath 'workingDir\')
xcopy @(Get-RelativePath 'specFiles\stringR_File2.txt') @(Get-RelativePath 'workingDir\')
}

function validate-stringReplacedFiles(){
 $testResult = @();
# Read content of the string replaced file and validate the preset words
	$content = [System.IO.File]::ReadAllText( @(Get-RelativePath 'workingDir\stringR_File1.config'))
     $expectedTokens = 'postgres','myapp_development',10,'AnupHost'
     $expectedTokens| ForEach-Object { if($content -like '*'+$_+'*'){ $testResult+= "Assert - string replacement $($_) - Success" } else {$testResult+= "Assert - string replacement $($_) - Failure"} }
      
      $content = [System.IO.File]::ReadAllText( @(Get-RelativePath 'workingDir\stringR_File2.txt'))
     $expectedTokens = 'postgres','myapp_development','localhost'
     $expectedTokens| ForEach-Object { if($content -like '*'+$_+'*'){ $testResult+= "Assert - string replacement $($_) - Success" } else {$testResult+= "Assert - string replacement $($_) - Failure"} }
      
    return $testResult
}

function copy-xpathgtypestubfiles(){
xcopy @(Get-RelativePath 'specFiles\xpathR_File1.config') @(Get-RelativePath 'workingDir\')
xcopy @(Get-RelativePath 'specFiles\xpathR_File2.txt') @(Get-RelativePath 'workingDir\')
}

function validate-xpathReplacedFiles(){
 $testResult = @();
# Read content of the string replaced file and validate the preset words
	$content = [System.IO.File]::ReadAllText( @(Get-RelativePath 'workingDir\xpathR_File1.config'))
     $expectedTokens = 'GamesofThrones','Fire And Ice','RRMartin'
     $expectedTokens| ForEach-Object { if($content -like '*'+$_+'*'){ $testResult+= "Assert - Xpath replacement $($_) - Success" } else {$testResult+= "Assert - xp replacement $($_) - Failure"} }
      return $testResult

}

function copy-regexgtypestubfiles(){
xcopy @(Get-RelativePath 'specFiles\regExpathR_File1.config') @(Get-RelativePath 'workingDir\')
xcopy @(Get-RelativePath 'specFiles\regExR_File2.txt') @(Get-RelativePath 'workingDir\')
}
function validate-regexReplacedFiles(){
 $testResult = @();
# Read content of the string replaced file and validate the preset words
	$content = [System.IO.File]::ReadAllText( @(Get-RelativePath 'workingDir\regExpathR_File1.config'))
     $expectedTokens = 'triplea'
     $expectedTokens| ForEach-Object { if($content -like '*'+$_+'*'){ $testResult+= "Assert - RegEX replacement $($_) - Success" } else {$testResult+= "Assert - xp replacement $($_) - Failure"} }
	  
	  # Read content of the string replaced file and validate the preset words
	$content = [System.IO.File]::ReadAllText( @(Get-RelativePath 'workingDir\regExR_File2.txt'))
     $expectedTokens = 'IPREPLACED','DATEREPLACED'
     $expectedTokens| ForEach-Object { if($content -like '*'+$_+'*'){ $testResult+= "Assert - RegEX replacement $($_) - Success" } else {$testResult+= "Assert - xp replacement $($_) - Failure"} }
      return $testResult
}



######### FACTS ##############################
JingaShouldReplaceallTheStringTokenDefinedInYaml_Fact
JingaShouldReplaceallTheXpathTokenDefinedInYaml_Fact
JingaShouldReplaceallTheRegexTokenDefinedInYaml_Fact
##############################################

$code = publish-result $r 1
return $code 
