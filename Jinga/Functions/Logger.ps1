#
# logger.ps1
#

function Log-Console{
	param(
	[Parameter(Mandatory=$false)] 
        [ValidateSet("Error","Warn","Info")] 
        [string]$Level="Info", 
		 [ValidateNotNullOrEmpty()] 
        [Alias("LogContent")] 
		[string]$Message 
         )
    # Write message to error, warning, or verbose pipeline and specify $LevelText 
        switch ($Level) { 
            'Error' { 
                Write-Error $Message 
                } 
            'Warn' { 
                Write-Warning $Message 
                } 
            'Info' { 
                Write-host $Message -ForegroundColor Green
                } 
            } 
         }