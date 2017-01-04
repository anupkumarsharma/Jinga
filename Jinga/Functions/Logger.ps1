#
# logger.ps1
#

function Log-Console{
	param(
	[Parameter(Mandatory=$false)] 
        [ValidateSet("Error","Warn","Info","Verbose")] 
        [string]$Level="Info", 
		[ValidateNotNullOrEmpty()] 
        [Alias("LogContent")] 
		[string]$Message 
         )
    # Write message to error, warning, or verbose pipeline and specify $LevelText 
        switch ($Level) { 
            'Error' { 
                Write-Error $Message -ForegroundColor Red
                } 
            'Warn' { 
                Write-host $Message  -ForegroundColor Yellow
                } 
            'Info' { 
                Write-host $Message -ForegroundColor Green
                } 

			 'Verbose' { 
                Write-Verbose $Message 
                } 

            } 
         }