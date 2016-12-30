Remove-Item vendors\ -Recurse
.\nuget\NuGet.exe  install .\nuget\packages.config -o "vendors\"
